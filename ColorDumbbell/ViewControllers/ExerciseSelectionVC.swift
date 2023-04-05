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
        addExerciseVC.viewModel.exerciseDelegate = self
        addExerciseVC.modalPresentationStyle = .overCurrentContext
        addExerciseVC.modalTransitionStyle = .coverVertical
        
        self.present(addExerciseVC, animated: true)
    }
}

extension ExerciseSelectionVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return NUMBER_OF_SECTION
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.isEditorModeOn ? viewModel.totalExerciseArray[0].count + 2 : viewModel.totalExerciseArray[0].count + 1
        } else if section == 1 {
            return viewModel.isEditorModeOn ? viewModel.totalExerciseArray[1].count + 2 : viewModel.totalExerciseArray[1].count + 1
        } else if section == 2 {
            return viewModel.isEditorModeOn ? viewModel.totalExerciseArray[2].count + 2 : viewModel.totalExerciseArray[2].count + 1
        } else if section == 3 {
            return viewModel.isEditorModeOn ? viewModel.totalExerciseArray[3].count + 2 : viewModel.totalExerciseArray[3].count + 1
        } else if section == 4 {
            return viewModel.isEditorModeOn ? viewModel.totalExerciseArray[4].count + 2 : viewModel.totalExerciseArray[4].count + 1
        }
        
        return viewModel.isEditorModeOn ? viewModel.totalExerciseArray[5].count + 2 : viewModel.totalExerciseArray[5].count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 4 || indexPath.section == 5 {
            if indexPath.row == 0 {
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
            if !viewModel.isEditorModeOn {
                if indexPath.row != 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: Cell.exerciseContentCell) as! ExerciseContentCell
                    
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
                    
                    return cell
                }
            } else {
                if indexPath.row == viewModel.totalExerciseArray[indexPath.section].count + 1 {
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
                } else {
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
                }
            }
        }
        return UITableViewCell()
    }
}

extension ExerciseSelectionVC: UIAdaptivePresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        presentActionSheetAlert()
        return false
    }
}

extension ExerciseSelectionVC: ExerciseDelegate {
    func selectExercises(exerciseArray: [Exercise]) {}
    func manageExercise(section: Int, row: Int, exerciseName: String, editorMode: EditorMode) {
        if editorMode == .new {
            let exercise: Exercise = Exercise(name: exerciseName,
                                              area: viewModel.EXERCISE_AREA_ARRAY[section].rawValue,
                                              quantity: [ExerciseQuantity](),
                                              id: UUID().uuidString,
                                              type: ExerciseType.custom.rawValue)
            viewModel.totalExerciseArray[section].append(exercise)
        } else if editorMode == .edit {
            viewModel.totalExerciseArray[section][row].name = exerciseName
        }
        selectionTableView.reloadData()
    }
}
