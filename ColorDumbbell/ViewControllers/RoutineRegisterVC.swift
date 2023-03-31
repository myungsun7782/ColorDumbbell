//
//  RoutineRegisterVC.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/28.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class RoutineRegisterVC: UIViewController {
    // UIButton
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    // UITableView
    @IBOutlet weak var routineTableView: UITableView!
    
    // ViewModel
    let viewModel = RoutineRegisterVM()
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    // Variables
    
    // Constants
    let ACTION_SHEET_ALERT_MESSAGE: String = "이 변경 사항을 폐기하겠습니까?"
    let ALERT_DISCARD_ACTION_TITLE: String = "변경 사항 폐기"
    let ALERT_CANCEL_ACTION_TITLE: String = "계속 편집하기"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        action()
        self.presentationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isModalInPresentation = false
    }
    
    override func viewWillLayoutSubviews() {
        routineTableView.reloadData()
    }
    
    private func initUI() {
        // UIButton
        configureButton()
        
        // UITableView
        configureTableView()
    }
    
    private func action() {
        // UIButton
        cancelButton.rx.tap
            .subscribe(onNext: { _ in
                AlertManager.shared.presentActionSheetAlert(title: nil, message: self.ACTION_SHEET_ALERT_MESSAGE, firstButtonTitle: self.ALERT_DISCARD_ACTION_TITLE, secondButtonTitle: self.ALERT_CANCEL_ACTION_TITLE) {
                    self.dismiss(animated: true)
                } completionHandler: { alert in
                    self.present(alert, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .subscribe(onNext: { _ in
                // 루틴 객체 생성 후 delegate로 넘겨주기
                if self.viewModel.validateButton(routineRegisterVC: self, title: self.viewModel.title, exerciseArray: self.viewModel.exerciseArray) {
                    guard let title = self.viewModel.title else { return }
                    
                    if self.viewModel.editorMode == .new {
                        let routine = Routine(name: title, memo: self.viewModel.memo ?? "", exerciseArray: self.viewModel.exerciseArray)
                        self.viewModel.delegate?.transferData(section: self.viewModel.section, routine: routine, editorMode: self.viewModel.editorMode)
                    } else if self.viewModel.editorMode == .edit {
                        guard let section = self.viewModel.section else { return }
                        guard var modifiableRoutine = self.viewModel.modifiableRoutine else { return }
                        let memo = self.viewModel.memo ?? ""
                        
                        modifiableRoutine.name = title
                        modifiableRoutine.memo = memo
                        modifiableRoutine.exerciseArray = self.viewModel.exerciseArray
                        
                        self.viewModel.delegate?.transferData(section: section, routine: modifiableRoutine, editorMode: self.viewModel.editorMode)
                    }
                    self.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func configureButton() {
        addButton.setTitle(viewModel.editorMode == .new ? "추가" : "수정", for: .normal)
    }
    
    private func configureTableView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        routineTableView.addGestureRecognizer(tap)
        routineTableView.dataSource = self
        routineTableView.delegate = self
        registerTableViewCell()
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func registerTableViewCell() {
        routineTableView.register(UINib(nibName: Cell.titleCell, bundle: nil), forCellReuseIdentifier: Cell.titleCell)
        routineTableView.register(UINib(nibName: Cell.exerciseAddCell, bundle: nil), forCellReuseIdentifier: Cell.exerciseAddCell)
        routineTableView.register(UINib(nibName: Cell.exerciseTitleCell, bundle: nil), forCellReuseIdentifier: Cell.exerciseTitleCell)
        routineTableView.register(UINib(nibName: Cell.routineSetCell, bundle: nil), forCellReuseIdentifier: Cell.routineSetCell)
    }
    
    private func presentExerciseSelectionVC() {
        let exerciseSelctionVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: VC.exerciseSelectionVC) as! ExerciseSelectionVC
        
        exerciseSelctionVC.viewModel.exerciseDelegate = self
        
        self.present(exerciseSelctionVC, animated: true)
    }
    
    
}

extension RoutineRegisterVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.exerciseArray.count + 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 || section == viewModel.exerciseArray.count + 2 {
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.titleCell) as! TitleCell
            let placeHoler: String = "루틴 이름"
            
            cell.textFieldPlaceHolder = placeHoler
            cell.configureTextField()
            if let title = viewModel.title {
                cell.setData(title: title)
            }
            cell.titleTextField.rx.controlEvent([.editingDidEndOnExit])
                .asObservable()
                .subscribe(onNext: {  _ in
                    cell.titleTextField.resignFirstResponder()
                })
                .disposed(by: cell.disposeBag)
            cell.titleTextField.rx.text.orEmpty
                .subscribe(onNext: { title in
                    self.viewModel.title = title
                })
                .disposed(by: cell.disposeBag)
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.titleCell) as! TitleCell
            let placeHolder: String = "메모"
            
            cell.textFieldPlaceHolder = placeHolder
            cell.configureTextField()
            if let memo = viewModel.memo {
                cell.setData(title: memo)
            }
            cell.titleTextField.rx.controlEvent([.editingDidEndOnExit])
                .asObservable()
                .subscribe(onNext: {  _ in
                    cell.titleTextField.resignFirstResponder()
                })
                .disposed(by: cell.disposeBag)
    
            cell.titleTextField.rx.text.orEmpty
                .subscribe(onNext: { memo in
                    self.viewModel.memo = memo
                })
                .disposed(by: cell.disposeBag)
            
            return cell
        } else if indexPath.section == viewModel.exerciseArray.count + 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.exerciseAddCell) as! ExerciseAddCell
            let title: String = "운동 추가..."
            
            cell.setData(title: title)
            cell.containerStackView.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { _ in
                    self.presentExerciseSelectionVC()
                })
                .disposed(by: cell.disposeBag)
            
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.exerciseTitleCell) as! ExerciseTitleCell
                
                cell.setData(index: .zero, exercise: viewModel.exerciseArray[indexPath.section-2])
                cell.editButton.rx.tap
                    .subscribe(onNext: { _ in
                        AlertManager.shared.presentTwoButtonAlert(title: "삭제", message: "정말로 해당 운동을 삭제하시겠습니까?", buttonTitle: "확인", style: .alert) {
                            self.viewModel.exerciseArray.remove(at: indexPath.section-2)
                            self.routineTableView.reloadData()
                        } completionHandler: { alert in
                            self.present(alert, animated: true)
                        }
                    })
                    .disposed(by: cell.disposeBag)
                
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.routineSetCell) as! RoutineSetCell
            
            cell.setData(index: indexPath.row, exercise: viewModel.exerciseArray[indexPath.section-2])
            cell.plusButton.rx.tap
                .subscribe(onNext: { _ in
                    if self.viewModel.exerciseArray[indexPath.section-2].quantity.count <= self.viewModel.MAX_SET_COUNT {
                        self.viewModel.exerciseArray[indexPath.section-2].quantity.append(ExerciseQuantity())
                        self.routineTableView.reloadData()
                    }
                })
                .disposed(by: cell.disposeBag)
            cell.minusButton.rx.tap
                .subscribe(onNext: { _ in
                    if self.viewModel.exerciseArray[indexPath.section-2].quantity.count > self.viewModel.MIN_SET_COUNT {
                        self.viewModel.exerciseArray[indexPath.section-2].quantity.removeLast()
                        self.routineTableView.reloadData()
                    }
                })
                .disposed(by: cell.disposeBag)
            
            return cell
        }
    }
}

extension RoutineRegisterVC: ExerciseDelegate {
    func manageExercise(section: Int, row: Int, exerciseName: String, editorMode: EditorMode) {}
    
    func selectExercises(exerciseArray: [Exercise]) {
        exerciseArray.forEach { exercise in
            var selectedExercise = exercise
            selectedExercise.quantity.append(ExerciseQuantity())
            viewModel.exerciseArray.append(selectedExercise)
        }
        routineTableView.reloadData()
    }
}

extension RoutineRegisterVC: UIAdaptivePresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        AlertManager.shared.presentActionSheetAlert(title: nil, message: ACTION_SHEET_ALERT_MESSAGE, firstButtonTitle: ALERT_DISCARD_ACTION_TITLE, secondButtonTitle: ALERT_CANCEL_ACTION_TITLE) {
            self.dismiss(animated: true)
        } completionHandler: { alert in
            self.present(alert, animated: true)
        }
        return false
    }
}
