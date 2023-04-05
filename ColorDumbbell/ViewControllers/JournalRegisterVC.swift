//
//  JournalRegisterVC.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/11.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import RxKeyboard
import Photos
import YPImagePicker
import SwiftDate

class JournalRegisterVC: UIViewController {
    // UIStatusBarStyle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // UIButton
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet var weightButtonArray: [UIButton]!
    @IBOutlet var repsButtonArray: [UIButton]!
    @IBOutlet weak var confirmButton: UIButton!
    
    // UITextField
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    
    // UIStackView
    @IBOutlet weak var containerStackView: UIStackView!
    
    // UIView
    @IBOutlet weak var containerView: UIView!
    
    
    // UITableView
    @IBOutlet weak var journalTableView: UITableView!
    
    // ViewModel
    let viewModel = JournalRegisterVM()
    
    // Variables
    
    // Constants
    let ADD_PHOTO_CELL_TITLE: String = "사진 추가..."
    let ADD_EXERCISE_CELL_TITLE: String = "운동 추가..."
    let TIME_INTERVAL: TimeInterval = 3600
    let ALERT_TITLE: String = "올바르지 않은 시간 설정"
    let ALERT_MESSAGE: String = "종료 시간은 시작 시간보다 이후이어야 합니다."
    let ALERT_CHECK_ACTION_TTILE: String = "확인"
    let ACTION_SHEET_ALERT_MESSAGE: String = "이 변경 사항을 폐기하겠습니까?"
    let ALERT_DISCARD_ACTION_TITLE: String = "변경 사항 폐기"
    let ALERT_CANCEL_ACTION_TITLE: String = "계속 편집하기"
    let BUTTON_CORNER_RADIUS: CGFloat = 6
    let TEXT_FIELD_FONT_SIZE: CGFloat = 16
    let STACK_VIEW_CORNER_RADIUS: CGFloat = 20
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        action()
        bind()
        viewModel.fetchPhotos(journalRegisterVC: self)
        self.presentationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isModalInPresentation = false
    }
    
    override func viewWillLayoutSubviews() {
        journalTableView.reloadData()
    }

    private func initUI() {
        // UIButton
        cancelButton.rx.tap
            .subscribe(onNext: { _ in
                self.presentActionSheetAlert()
            })
            .disposed(by: disposeBag)
        
        // UITableView
        configureTableView()
        
        // UIButton
        configureButton()
        
        // UIStackView
        configureStackView()
        
        // UIView
        configureView()
    }
    
    private func action() {
        // UIButton
        confirmButton.rx.tap
            .subscribe(onNext: { _ in
                guard let section = self.viewModel.section else { return }
                guard let row = self.viewModel.row else { return }
                guard let weightText = self.weightTextField.text else { return }
                guard let repsText = self.repsTextField.text else { return }
                guard let weight = Double(weightText) else { return }
                guard let reps = Int(repsText) else { return }
                self.updateSetCell(section: section, row: row, weight: weight, reps: reps)
                self.resetSetCell()
                self.containerStackView.isHidden = true
                self.containerView.isHidden = true
                self.view.endEditing(true)
            })
            .disposed(by: disposeBag)

        for (i, button) in weightButtonArray.enumerated() {
            button.rx.tap
                .subscribe(onNext: { _ in
                    guard let weight = self.weightTextField.text else { return }
                    if let doubleValue = Double(weight) {
                        let result = doubleValue + self.viewModel.WEIGHT_BUTTON_VALUE_ARRAY[i]

                        if result < 0 {
                            self.weightTextField.text = self.viewModel.WEIGHT_DEFAULT_VALUE
                        } else if String(result).count > 5 {
                            self.weightTextField.text = self.viewModel.WEIGHT_MAXIMUM_VALUE
                        } else {
                            self.weightTextField.text = String(result)
                        }
                    }
                })
                .disposed(by: disposeBag)
        }

        for (i, button) in repsButtonArray.enumerated() {
            button.rx.tap
                .subscribe(onNext: { _ in
                    guard let reps = self.repsTextField.text else { return }
                    if let intValue = Int(reps) {
                        let result = intValue + self.viewModel.REPS_BUTTON_VALUE_ARRAY[i]

                        if result < 0 {
                            self.repsTextField.text = self.viewModel.REPS_DEFAULT_VALUE
                        } else if result > 9999 {
                            self.repsTextField.text = self.viewModel.REPS_MAXIMUM_VALUE
                        } else {
                            self.repsTextField.text = String(result)
                        }
                    }
                })
                .disposed(by: disposeBag)
        }
        
        registerButton.rx.tap
            .subscribe(onNext: { [self] _ in
                guard let title = self.viewModel.title else { return }
                if self.viewModel.validateButton(journalRegisterVC: self, title: title, exerciseArray: self.viewModel.exerciseArray) {
                    // MARK: - ExerciseJournal 객체 생성해서 Delegate로 ExerciseCalendar에 넘겨주기
                    guard let startTime = self.viewModel.startTime else { return }
                    guard let endTime = self.viewModel.endTime else { return }
                    let totalExerciseTime = getMinutes(startTime: startTime, endTime: endTime) < 0 ? (-1) * self.getMinutes(startTime: startTime, endTime: endTime) : self.getMinutes(startTime: startTime, endTime: endTime)
                    
                    if viewModel.editorMode == .new {
                        let exerciseJournal = ExerciseJournal(id: UUID().uuidString, title: title, registerDate: Date(), startTime: self.viewModel.startTime!, endTime: self.viewModel.endTime!, totalExerciseTime: totalExerciseTime, photoIdArray: self.viewModel.getPhotoIdArray(), exerciseArray: self.viewModel.exerciseArray)
                        
                        LoadingManager.shared.showLoading()
                        if !exerciseJournal.photoIdArray!.isEmpty {
                            FirebaseManager.shared.uploadImage(photoAndIdList: viewModel.photoAndIdList) { _ in
                                FirebaseManager.shared.addExerciseJournal(exerciseJournal: exerciseJournal) { isSuccess in
                                    if isSuccess {
                                        LoadingManager.shared.hideLoading()
                                        self.viewModel.delegate?.transferData(exerciseJournal: exerciseJournal, editorMode: .new)
                                        self.dismiss(animated: true)
                                    }
                                }
                            }
                        } else {
                            FirebaseManager.shared.addExerciseJournal(exerciseJournal: exerciseJournal) { isSuccess in
                                if isSuccess {
                                    LoadingManager.shared.hideLoading()
                                    self.viewModel.delegate?.transferData(exerciseJournal: exerciseJournal, editorMode: .new)
                                    self.dismiss(animated: true)
                                }
                            }
                        }
                    } else if viewModel.editorMode == .edit {
                        if let exerciseJournal = viewModel.exerciseJournal {
                            let existingPhotoIdList = exerciseJournal.photoIdArray!
                            let deduplicatedList = self.viewModel.photoAndIdList.filter { (_, photoId) in
                                return !existingPhotoIdList.contains(photoId)
                            }
                            let idList = self.viewModel.photoAndIdList.map { (_, photoId) in
                                return photoId
                            }
                            exerciseJournal.title = title
                            exerciseJournal.startTime = startTime
                            exerciseJournal.endTime = endTime
                            exerciseJournal.totalExerciseTime = totalExerciseTime
                            exerciseJournal.photoIdArray = idList
                            exerciseJournal.exerciseArray = viewModel.exerciseArray
                            exerciseJournal.divisionExerciseArray(exerciseArray: viewModel.exerciseArray)
                            
                            LoadingManager.shared.showLoading()
                            if !deduplicatedList.isEmpty {
                                FirebaseManager.shared.uploadImage(photoAndIdList: deduplicatedList) { _ in
                                    FirebaseManager.shared.modifyExerciseJournal(exerciseJournal: exerciseJournal) { isSuccess in
                                        if isSuccess {
                                            LoadingManager.shared.hideLoading()
                                            self.viewModel.delegate?.transferData(exerciseJournal: exerciseJournal, editorMode: .edit)
                                            self.dismiss(animated: true)
                                        }
                                    }
                                }
                            } else {
                                FirebaseManager.shared.modifyExerciseJournal(exerciseJournal: exerciseJournal) { isSuccess in
                                    if isSuccess {
                                        self.viewModel.delegate?.transferData(exerciseJournal: exerciseJournal, editorMode: .edit)
                                        
                                        LoadingManager.shared.hideLoading()
                                        self.dismiss(animated: true)
                                    }
                                }
                            }
                        }
                    }
                }
            })
            .disposed(by: disposeBag)

        // RxKeyboard
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] keyboardHeight in
                let height = keyboardHeight > 0 ? -keyboardHeight + view.safeAreaInsets.bottom : 0
                
                if self.containerStackView.isHidden == false {
                    self.containerStackView.snp.updateConstraints { make in
                        make.bottom.equalTo(view.safeAreaLayoutGuide).offset(height)
                    }
                } else {
                    self.containerStackView.snp.updateConstraints { make in
                        make.bottom.equalTo(view.safeAreaLayoutGuide)
                    }
                }
                
                view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
        
        // UITextField
        weightTextField.rx.text.orEmpty
            .map { String($0.prefix(5))}
            .bind(to: weightTextField.rx.text)
            .disposed(by: disposeBag)

        weightTextField.rx.text.orEmpty
            .subscribe(onNext: { weight in
                if weight.isEmpty {
                    self.weightTextField.text = "\(self.viewModel.WEIGHT_DEFAULT_VALUE)"
                } else if weight.count == 2 {
                    if weight[weight.startIndex] == "0" {
                        self.weightTextField.text!.remove(at: self.weightTextField.text!.startIndex)
                    }
                }
            })
            .disposed(by: disposeBag)

        repsTextField.rx.text.orEmpty
            .map { String($0.prefix(4))}
            .bind(to: repsTextField.rx.text)
            .disposed(by: disposeBag)

        repsTextField.rx.text.orEmpty
            .subscribe(onNext: { reps in
                if reps.isEmpty {
                    self.repsTextField.text = "\(self.viewModel.REPS_DEFAULT_VALUE)"
                } else if reps.count == 2 {
                    if reps[reps.startIndex] == "0" {
                        self.repsTextField.text!.remove(at: self.repsTextField.text!.startIndex)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bind() {
 
    }

    private func configureTableView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        journalTableView.addGestureRecognizer(tap)
        journalTableView.dataSource = self
        journalTableView.delegate = self
        registerTableViewCells()
    }
    
    private func registerTableViewCells() {
        journalTableView.register(UINib(nibName: Cell.titleCell, bundle: nil), forCellReuseIdentifier: Cell.titleCell)
        journalTableView.register(UINib(nibName: Cell.exerciseTimeCell, bundle: nil), forCellReuseIdentifier: Cell.exerciseTimeCell)
        journalTableView.register(UINib(nibName: Cell.addCell, bundle: nil), forCellReuseIdentifier: Cell.addCell)
        journalTableView.register(UINib(nibName: Cell.exerciseAddCell, bundle: nil), forCellReuseIdentifier: Cell.exerciseAddCell)
        journalTableView.register(UINib(nibName: Cell.photoFileCell, bundle: nil), forCellReuseIdentifier: Cell.photoFileCell)
        journalTableView.register(UINib(nibName: Cell.exerciseTitleCell, bundle: nil), forCellReuseIdentifier: Cell.exerciseTitleCell)
        journalTableView.register(UINib(nibName: Cell.exerciseSetCell, bundle: nil), forCellReuseIdentifier: Cell.exerciseSetCell)
        journalTableView.register(UINib(nibName: Cell.exerciseUtilityCell, bundle: nil), forCellReuseIdentifier: Cell.exerciseUtilityCell)
    }
    
    private func configureButton() {
        weightButtonArray.forEach { button in
            button.layer.cornerRadius = BUTTON_CORNER_RADIUS
        }
        repsButtonArray.forEach { button in
            button.layer.cornerRadius = BUTTON_CORNER_RADIUS
        }
    
        registerButton.setTitle(viewModel.editorMode == .new ? "추가" : "수정", for: .normal)
    }
    
    private func configureStackView() {
        containerStackView.layer.cornerRadius = .zero
        containerStackView.roundCorners(corners: [.topLeft, .topRight], radius: STACK_VIEW_CORNER_RADIUS)
        containerStackView.isHidden = true
    }
    
    private func configureView() {
        containerView.isHidden = true
    }
    
    private func presentInvalidTimeAlert() {
        let alert = UIAlertController(title: ALERT_TITLE, message: ALERT_MESSAGE, preferredStyle: .alert)
        let checkAction = UIAlertAction(title: ALERT_CHECK_ACTION_TTILE, style: .cancel)
        
        alert.addAction(checkAction)
        
        present(alert, animated: true, completion: nil)
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
    
    private func presentExerciseSelectionVC() {
        let exerciseSelctionVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: VC.exerciseSelectionVC) as! ExerciseSelectionVC
        
        exerciseSelctionVC.viewModel.exerciseDelegate = self
        
        self.present(exerciseSelctionVC, animated: true)
    }
    
    private func updateSetCell(section: Int, row: Int, weight: Double, reps: Int) {
        viewModel.exerciseArray[section].quantity[row].weight = weight
        viewModel.exerciseArray[section].quantity[row].reps = reps
        journalTableView.reloadData()
    }
    
    private func selectSetCell(section: Int, row: Int) {
        for (i, _) in viewModel.exerciseArray.enumerated() {
            for (j, _) in viewModel.exerciseArray[i].quantity.enumerated() {
                if i == section && j == row {
                    continue
                } else {
                    viewModel.exerciseArray[i].quantity[j].isFocused = false
                }
            }
        }
        journalTableView.reloadData()
    }
    
    private func resetSetCell() {
        for (i, _) in viewModel.exerciseArray.enumerated() {
            for (j, _) in viewModel.exerciseArray[i].quantity.enumerated() {
                viewModel.exerciseArray[i].quantity[j].isFocused = false
            }
        }
        journalTableView.reloadData()
    }
    
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func getMinutes(startTime: Date, endTime: Date) -> Int {
        let startHour = startTime.convertTo(region: Region.current).hour
        let startMin = startTime.convertTo(region: Region.current).minute
        let endHour = endTime.convertTo(region: Region.current).hour
        let endMin = endTime.convertTo(region: Region.current).minute
        var result = (endHour - startHour) * 60
        
        result += endMin - startMin
        
        return result
    }
    
    private func presentDetailImageVC(index: Int) {
        let detailImageVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: VC.detailImageVC) as! DetailImageVC

        detailImageVC.selectedImage = self.viewModel.photoAndIdList[index].0
        detailImageVC.modalPresentationStyle = .overCurrentContext
        detailImageVC.modalTransitionStyle = .crossDissolve

        self.present(detailImageVC, animated: true)
    }
}

extension JournalRegisterVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.exerciseArray.count + 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        } else if section == 2 {
            return viewModel.photoAndIdList.count + 1
        } else if section == viewModel.exerciseArray.count + 3 {
            return 1
        }
        
        return viewModel.exerciseArray[section-3].quantity.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.titleCell) as! TitleCell
            
            if let title = viewModel.title {
                cell.setData(title: title)
            }
            
            cell.titleTextField.rx.text.orEmpty
                .subscribe(onNext: { text in
                    self.viewModel.title = text
                })
                .disposed(by: cell.disposeBag)
        
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.exerciseTimeCell) as! ExerciseTimeCell
            
            cell.setData(startTime: self.viewModel.startTime!,
                         endTime: self.viewModel.endTime!,
                         totalExerciseTime: self.getMinutes(startTime: self.viewModel.startTime!, endTime: self.viewModel.endTime!),
                         isEditingMode: viewModel.isEditingMode)
            
            cell.startTimePicker.rx.controlEvent([.valueChanged])
                .asObservable()
                .subscribe(onNext: { _ in
                    cell.endTimePicker.date = cell.startTimePicker.date.addingTimeInterval(self.TIME_INTERVAL)
                    cell.endTimePicker.minimumDate = cell.startTimePicker.date + 1.minutes
                    cell.totalExerciseTimeLabel.text = "\(self.getMinutes(startTime: cell.startTimePicker.date, endTime: cell.endTimePicker.date))분"
                    self.viewModel.startTime = cell.startTimePicker.date
                    self.viewModel.endTime = cell.endTimePicker.date
                    guard let exerciseTotalTime = Int(cell.totalExerciseTimeLabel.text!) else { return }
                    self.viewModel.totalExerciseTime = exerciseTotalTime
                })
                .disposed(by: cell.disposeBag)

            cell.endTimePicker.rx.controlEvent([.valueChanged])
                .asObservable()
                .subscribe(onNext: { _ in
                    cell.totalExerciseTimeLabel.text = "\(self.getMinutes(startTime: cell.startTimePicker.date, endTime: cell.endTimePicker.date))분"
                    self.viewModel.startTime = cell.startTimePicker.date
                    self.viewModel.endTime = cell.endTimePicker.date
                    guard let exerciseTotalTime = Int(cell.totalExerciseTimeLabel.text!) else { return }
                    self.viewModel.totalExerciseTime = exerciseTotalTime
                })
                .disposed(by: cell.disposeBag)
            
            return cell
        } else if indexPath.section == 2 {
            if indexPath.row != viewModel.photoAndIdList.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.photoFileCell) as! PhotoFileCell
                
                cell.setData(index: indexPath.row, photoId: "Photo\(indexPath.row+1).jpg")
                
                cell.containerStackView.rx.tapGesture()
                    .when(.recognized)
                    .subscribe(onNext: { _ in
                        self.presentDetailImageVC(index: indexPath.row)
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.deleteButton.rx.tap
                    .subscribe(onNext: { _ in
                        AlertManager.shared.presentTwoButtonAlert(title: "삭제", message: "정말로 해당 사진을 삭제하시겠습니까?", buttonTitle: "확인", style: .alert) {
                            self.viewModel.photoAndIdList.remove(at: indexPath.row)
                            self.journalTableView.reloadData()
                        } completionHandler: { alert in
                            self.present(alert, animated: true)
                        }
                    })
                    .disposed(by: cell.disposeBag)
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.addCell) as! AddCell
                
                cell.setData(title: ADD_PHOTO_CELL_TITLE)
                cell.setTopConstarint(isEmpty: viewModel.photoAndIdList.isEmpty)
                cell.containerStackView.rx.tapGesture()
                    .when(.recognized)
                    .subscribe(onNext: { _ in
                        if self.viewModel.MAX_NUMBER_OF_PHOTO == self.viewModel.photoAndIdList.count {
                            self.viewModel.presentPhotoMaxAlert(journalRegisterVC: self)
                        } else {
                            self.viewModel.presentImagePicker(journalRegisterVC: self)
                        }
                    })
                    .disposed(by: cell.disposeBag)
                
                return cell
            }
        } else if indexPath.section == viewModel.exerciseArray.count + 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.exerciseAddCell) as! ExerciseAddCell
            
            cell.setData(title: ADD_EXERCISE_CELL_TITLE)
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

                cell.setData(index: indexPath.section-3, exercise: viewModel.exerciseArray[indexPath.section-3])
                cell.editButton.rx.tap
                    .subscribe(onNext: { _ in
                        AlertManager.shared.presentTwoButtonAlert(title: "삭제", message: "정말로 해당 운동을 삭제하시겠습니까?", buttonTitle: "확인", style: .alert) {
                            self.viewModel.exerciseArray.remove(at: indexPath.section-3)
                            self.journalTableView.reloadData()
                        } completionHandler: { alert in
                            self.present(alert, animated: true)
                        }
                    })
                    .disposed(by: cell.disposeBag)
                
                return cell
            } else if indexPath.row == viewModel.exerciseArray[indexPath.section-3].quantity.count + 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.exerciseUtilityCell) as! ExerciseUtilityCell
                
                cell.setData(index: indexPath.section-3)
                
                cell.addButton.rx.tap
                    .subscribe(onNext: { _ in
                        if indexPath.section-3 < self.viewModel.exerciseArray.count {
                            self.viewModel.exerciseArray[indexPath.section-3].quantity.append(ExerciseQuantity())
                            self.journalTableView.reloadData()
                        }
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.deleteButton.rx.tap
                    .subscribe(onNext: { _ in
                        if !self.viewModel.exerciseArray[indexPath.section-3].quantity.isEmpty {
                            self.viewModel.exerciseArray[indexPath.section-3].quantity.remove(at: self.viewModel.exerciseArray[indexPath.section-3].quantity.count-1)
                            self.journalTableView.reloadData()
                        }
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.timerButton.rx.tap
                    .subscribe(onNext: { _ in

                    })
                    .disposed(by: cell.disposeBag)

                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.exerciseSetCell) as! ExerciseSetCell

                cell.setData(set: indexPath.row,
                            weight: viewModel.exerciseArray[indexPath.section-3].quantity[indexPath.row-1].weight,
                             reps: viewModel.exerciseArray[indexPath.section-3].quantity[indexPath.row-1].reps,
                             isFocused: viewModel.exerciseArray[indexPath.section-3].quantity[indexPath.row-1].isFocused)

                cell.dataStackView.rx.tapGesture()
                    .when(.recognized)
                    .subscribe(onNext: { _ in
                        self.viewModel.exerciseArray[indexPath.section-3].quantity[indexPath.row-1].isFocused = !self.viewModel.exerciseArray[indexPath.section-3].quantity[indexPath.row-1].isFocused
                        self.selectSetCell(section: indexPath.section-3, row: indexPath.row-1)
                        self.viewModel.input.selectedSection.onNext(indexPath.section-3)
                        self.viewModel.input.selectedRow.onNext(indexPath.row-1)
                        self.weightTextField.text = "\(self.viewModel.exerciseArray[indexPath.section-3].quantity[indexPath.row-1].weight)"
                        self.repsTextField.text = "\(self.viewModel.exerciseArray[indexPath.section-3].quantity[indexPath.row-1].reps)"
                        self.containerStackView.isHidden = false
                        self.containerStackView.layer.cornerRadius = 0
                        self.containerStackView.roundCorners(corners: [.topLeft, .topRight], radius: self.STACK_VIEW_CORNER_RADIUS)
                        self.view.layoutIfNeeded()
                        self.containerView.isHidden = false
                    })
                    .disposed(by: cell.disposeBag)

                return cell
            }
        }
    }
}

extension JournalRegisterVC: ExerciseDelegate {
    func manageExercise(section: Int, row: Int, exerciseName: String, editorMode: EditorMode) {}
    
    func selectExercises(exerciseArray: [Exercise]) {
        exerciseArray.forEach { exercise in
            var selectedExercise = exercise
            selectedExercise.quantity.append(ExerciseQuantity())
            viewModel.exerciseArray.append(selectedExercise)
        }
        journalTableView.reloadData()
    }
}

extension JournalRegisterVC: WeightAndRepetitionDelegate {
    func transferData(section: Int, row: Int, weight: Double, reps: Int) {
        viewModel.exerciseArray[section].quantity[row].weight = weight
        viewModel.exerciseArray[section].quantity[row].reps = reps
        journalTableView.reloadData()
    }
}

extension JournalRegisterVC: UIAdaptivePresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        presentActionSheetAlert()
        return false
    }
}
