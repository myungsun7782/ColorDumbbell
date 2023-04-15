//
//  ExerciseSelectionVC.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/13.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class ExerciseSelectionVC: UIViewController {
    // UIStatusBarStyle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // UITableView
    @IBOutlet weak var selectionTableView: UITableView!
    
    // UIButton
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    // ViewModel
    let viewModel = ExerciseSelectionVM()
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    // Constants
    let ACTION_SHEET_ALERT_MESSAGE: String = "이 변경 사항을 폐기하겠습니까?"
    let ALERT_DISCARD_ACTION_TITLE: String = "변경 사항 폐기"
    let ALERT_CANCEL_ACTION_TITLE: String = "계속 편집하기"
    let NUMBER_OF_SECTION: Int = 6
    let BUTTON_FONT_SIZE: CGFloat = 17
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        action()
        bind()
        self.presentationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isModalInPresentation = false
    }
    
    override func viewWillLayoutSubviews() {
        selectionTableView.reloadData()
    }

    private func initUI() {
        // UITableView
        configureTableView()
        
        // UIButton
        configureButton()
    }
    
    private func action() {
        // UIButton
        cancelButton.rx.tap
            .subscribe(onNext: { _ in
                self.presentActionSheetAlert()
            })
            .disposed(by: disposeBag)
        
        finishButton.rx.tap
            .subscribe(onNext: { _ in
                self.viewModel.exerciseDelegate?.selectExercises(exerciseArray:  self.viewModel.getSelectedExercises(totalExerciseArray: self.viewModel.totalExerciseArray))
                self.dismiss(animated: true)
               
            })
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        
    }
    
    private func configureTableView() {
        selectionTableView.dataSource = self
        selectionTableView.delegate = self
        
        selectionTableView.register(UINib(nibName: Cell.exerciseTitleCell, bundle: nil), forCellReuseIdentifier: Cell.exerciseTitleCell)
        selectionTableView.register(UINib(nibName: Cell.exerciseContentCell, bundle: nil), forCellReuseIdentifier: Cell.exerciseContentCell)
        selectionTableView.register(UINib(nibName: Cell.exerciseRegisterCell, bundle: nil), forCellReuseIdentifier: Cell.exerciseRegisterCell)
        selectionTableView.register(UINib(nibName: Cell.routineSelectionCell, bundle: nil), forCellReuseIdentifier: Cell.routineSelectionCell)
    }
    
    private func configureButton() {
        finishButton.isEnabled = viewModel.validateFinishButton()
        finishButton.setTitleColor(finishButton.isEnabled ? ColorManager.shared.getCarminePink() : ColorManager.shared.getQuickSilver(), for: .normal)
    }
    
    private func presentActionSheetAlert() {
        let alert = UIAlertController(title: nil, message: ACTION_SHEET_ALERT_MESSAGE, preferredStyle: .actionSheet)
        
        let discardAction = UIAlertAction(title: ALERT_DISCARD_ACTION_TITLE, style: .destructive) { _ in
            self.dismiss(animated: true)
        }
        let cancelAction = UIAlertAction(title: ALERT_CANCEL_ACTION_TITLE, style: .cancel)
        alert.addAction(discardAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func presentAddExerciseVC(editorMode: EditorMode, section: Int, row: Int, exercise: Exercise? = nil) {
        let addExerciseVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: VC.addExerciseVC) as! AddExerciseVC
        
        addExerciseVC.viewModel.editorMode = editorMode
        addExerciseVC.viewModel.exercise = exercise
        addExerciseVC.viewModel.section = section
        addExerciseVC.viewModel.row = row
        addExerciseVC.viewModel.totalExerciseArray = viewModel.totalExerciseArray
        addExerciseVC.viewModel.exerciseDelegate = self
        addExerciseVC.modalPresentationStyle = .overCurrentContext
        addExerciseVC.modalTransitionStyle = .coverVertical
        
        self.present(addExerciseVC, animated: true)
    }
}

extension ExerciseSelectionVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.routineArray.isEmpty ? viewModel.totalExerciseArray.count : viewModel.totalExerciseArray.count + 1
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.routineArray.isEmpty {
            let totalExerciseCount = viewModel.totalExerciseArray[section].count
            return viewModel.isEditorModeOn ? totalExerciseCount+2 : totalExerciseCount+1
        } else {
            if section == viewModel.totalExerciseArray.count {
                return viewModel.routineArray.count
            } else {
                let totalExerciseCount = viewModel.totalExerciseArray[section].count
                return viewModel.isEditorModeOn ? totalExerciseCount+2 : totalExerciseCount+1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == viewModel.totalExerciseArray.count {
            if viewModel.routineArray.isEmpty { return UITableViewCell() }
            return getRoutineSelectionCell(tableView: tableView, indexPath: indexPath)
        } else {
            if viewModel.totalExerciseArray[indexPath.section].isEmpty { return UITableViewCell() }
            if indexPath.row == 0 {
                return getExerciseTitleCell(tableView: tableView, indexPath: indexPath)
            } else {
                if viewModel.isEditorModeOn && indexPath.row == viewModel.totalExerciseArray[indexPath.section].count+1 {
                    return getExerciseRegisterCell(tableView: tableView, indexPath: indexPath)
                } else {
                    return getExerciseContentCell(tableView: tableView, indexPath: indexPath, isEditorMode: viewModel.isEditorModeOn)
                }
            }
        }
    }
    
    func getRoutineSelectionCell(tableView: UITableView, indexPath: IndexPath) -> RoutineSelectionCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.routineSelectionCell) as! RoutineSelectionCell
        let isSingleData = viewModel.routineArray.count == 1 ? true : false

        cell.setData(index: indexPath.row,
                     lastIndex: viewModel.routineArray.count - 1,
                     isSingleData: isSingleData,
                     name: viewModel.routineArray[indexPath.row].name,
                     routineArray: viewModel.routineArray)
        cell.containerStackView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.viewModel.routineDelegate?.transferData(section: nil,
                                                             routine: self.viewModel.routineArray[indexPath.row],
                                                             editorMode: .new)
                self.dismiss(animated: true)
            })
            .disposed(by: cell.disposeBag)

        return cell
    }
    
    func getExerciseTitleCell(tableView: UITableView, indexPath: IndexPath) -> ExerciseTitleCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.exerciseTitleCell) as! ExerciseTitleCell
        cell.setData(index: indexPath.section, isEditorModeOn: viewModel.isEditorModeOn)
        
        cell.editButton.rx.tap
            .subscribe(onNext: { _ in
                self.viewModel.isEditorModeOn = !self.viewModel.isEditorModeOn
                DispatchQueue.main.async {
                    self.selectionTableView.reloadData()
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: cell.disposeBag)
        
        return cell
    }
    
    func getExerciseRegisterCell(tableView: UITableView, indexPath: IndexPath) -> ExerciseRegisterCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.exerciseRegisterCell) as! ExerciseRegisterCell
        
        cell.setData(isEditorModeOn: viewModel.isEditorModeOn)
        cell.containerStackView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.presentAddExerciseVC(editorMode: .new,
                                          section: indexPath.section,
                                          row: indexPath.row-1)
            })
            .disposed(by: cell.disposeBag)
        
        return cell
    }
    
    func getExerciseContentCell(tableView: UITableView, indexPath: IndexPath, isEditorMode: Bool) -> ExerciseContentCell {
        if isEditorMode {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.exerciseContentCell) as! ExerciseContentCell
            
            cell.setData(exerciseName: viewModel.totalExerciseArray[indexPath.section][indexPath.row-1].name,
                         isEditorModeOn: true,
                         index: indexPath.row,
                         exerciseArray: viewModel.totalExerciseArray[indexPath.section])
            cell.setCheckButtonConfiguration(isClicked: viewModel.totalExerciseArray[indexPath.section][indexPath.row-1].isChecked)
            cell.containerStackView.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { _ in
                    self.presentAddExerciseVC(editorMode: .edit,
                                              section: indexPath.section,
                                              row: indexPath.row-1,
                                              exercise: self.viewModel.totalExerciseArray[indexPath.section][indexPath.row-1])
                    
                    DispatchQueue.main.async {
                        self.selectionTableView.reloadData()
                    }
                    self.configureButton()
                })
                .disposed(by: cell.disposeBag)
            
            cell.deleteButton.rx.tap
                .subscribe(onNext: { _ in
                    AlertManager.shared.presentTwoButtonAlert(title: "운동 삭제", message: "정말로 해당 운동을 삭제하시겠습니까?", buttonTitle: "확인", style: .alert) {
                        // MARK: - Cloud Firestore에서도 삭제하기
                        let selectedExercise = self.viewModel.totalExerciseArray[indexPath.section][indexPath.row-1]
                        ExerciseManager.shared.figureExercise(exerciseObj: selectedExercise, editorMode: .delete)
                        if selectedExercise.type == ExerciseType.basis.rawValue {
                            FirebaseManager.shared.deleteDefaultExercise(exercise: selectedExercise) { isSuccess in
                                if isSuccess {
                                    self.viewModel.totalExerciseArray[indexPath.section].remove(at: indexPath.row-1)
                                    DispatchQueue.main.async {
                                        self.selectionTableView.reloadData()
                                    }
                                }
                            }
                        } else if selectedExercise.type == ExerciseType.custom.rawValue {
                            FirebaseManager.shared.deleteCustomExercise(exercise: selectedExercise) { isSuccess in
                                if isSuccess {
                                    self.viewModel.totalExerciseArray[indexPath.section].remove(at: indexPath.row-1)
                                    DispatchQueue.main.async {
                                        self.selectionTableView.reloadData()
                                    }
                                }
                            }
                        }
                    } completionHandler: { alert in
                        self.present(alert, animated: true)
                    }
                })
                .disposed(by: cell.disposeBag)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.exerciseContentCell) as! ExerciseContentCell
            
            if !viewModel.totalExerciseArray[indexPath.section].isEmpty {
                cell.setData(exerciseName: viewModel.totalExerciseArray[indexPath.section][indexPath.row-1].name, isEditorModeOn: false, index: indexPath.row, exerciseArray: viewModel.totalExerciseArray[indexPath.section])
                cell.setCheckButtonConfiguration(isClicked: viewModel.totalExerciseArray[indexPath.section][indexPath.row-1].isChecked)
                cell.containerStackView.rx.tapGesture()
                    .when(.recognized)
                    .subscribe(onNext: { _ in
                        self.viewModel.totalExerciseArray[indexPath.section][indexPath.row-1].isChecked = !self.viewModel.totalExerciseArray[indexPath.section][indexPath.row-1].isChecked
                        DispatchQueue.main.async {
                            self.selectionTableView.reloadData()
                        }
                        self.configureButton()
                    })
                    .disposed(by: cell.disposeBag)
            }
            
            return cell
        }
    }
}

extension ExerciseSelectionVC: UIAdaptivePresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
}

extension ExerciseSelectionVC: ExerciseDelegate {
    func selectExercises(exerciseArray: [Exercise]) {}
    func manageExercise(section: Int, row: Int, exercise: Exercise, editorMode: EditorMode) {
        if editorMode == .new {
            viewModel.totalExerciseArray[section].append(exercise)
            ExerciseManager.shared.figureExercise(exerciseObj: exercise, editorMode: .new)
        } else if editorMode == .edit {
            ExerciseManager.shared.figureExercise(exerciseObj: viewModel.totalExerciseArray[section][row], editorMode: .edit)
            viewModel.totalExerciseArray[section][row].name = exercise.name
        }
        selectionTableView.reloadData()
    }
}
