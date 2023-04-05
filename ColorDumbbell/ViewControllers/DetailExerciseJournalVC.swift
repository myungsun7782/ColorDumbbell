//
//  DetailExerciseJournalVC.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class DetailExerciseJournalVC: UIViewController {
    // UIStatusBarStyle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // UIStackView
    @IBOutlet weak var leftStackView: UIStackView!
    
    // UIButton
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    // UILabel
    @IBOutlet weak var dateLabel: UILabel!
    
    // UITableView
    @IBOutlet weak var detailJournalTableView: UITableView!
    
    // ViewModel
    let viewModel = DetailExerciseJournalVM()
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    // Variables
    
    // Constants
    let BACK_BUTTON_IMAGE: UIImage? = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .bold))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        action()
        bind()
    }
    
    private func initUI() {
        // UIButton
        configureButton()
        
        // UILabel
        configureLabel()
        
        // UINavigationController
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        // UITableView
        configureTableView()
        
        // LoadingView
        configureLoadingView()
    }
    
    private func action() {
        // UIStackView
        leftStackView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.viewModel.delegate?.transferData(exerciseJournal: self.viewModel.exerciseJournal, editorMode: .edit)
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        // UIButton
        editButton.rx.tap
            .subscribe(onNext: { _ in
                self.presentJournalRegisterVC()
            })
            .disposed(by: disposeBag)
        
    }
    
    private func bind() {
        
    }
    
    private func configureButton() {
        backButton.setImage(BACK_BUTTON_IMAGE, for: .normal )
    }
    
    private func configureLabel() {
        dateLabel.text = viewModel.journalDate
    }
    
    private func configureTableView() {
        detailJournalTableView.dataSource = self
        detailJournalTableView.delegate = self
        registerTableViewCell()
    }
    
    private func registerTableViewCell() {
        detailJournalTableView.register(UINib(nibName: Cell.detailJournalTitleCell, bundle: nil), forCellReuseIdentifier: Cell.detailJournalTitleCell)
        detailJournalTableView.register(UINib(nibName: Cell.detailJournalPhotoCell, bundle: nil), forCellReuseIdentifier: Cell.detailJournalPhotoCell)
        detailJournalTableView.register(UINib(nibName: Cell.labelCell, bundle: nil), forCellReuseIdentifier: Cell.labelCell)
        detailJournalTableView.register(UINib(nibName: Cell.detailJournalSetCell, bundle: nil), forCellReuseIdentifier: Cell.detailJournalSetCell)
        detailJournalTableView.register(UINib(nibName: Cell.exerciseTitleCell, bundle: nil), forCellReuseIdentifier: Cell.exerciseTitleCell)
        detailJournalTableView.register(UINib(nibName: Cell.buttonCell, bundle: nil), forCellReuseIdentifier: Cell.buttonCell)
    }
    
    private func configureLoadingView() {
        if !viewModel.exerciseJournal.photoIdArray!.isEmpty {
            LoadingManager.shared.showLoading()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                LoadingManager.shared.hideLoading()
            }
        }
    }
    
    private func presentJournalRegisterVC() {
        let journalRegisterVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: VC.journalRegisterVC) as! JournalRegisterVC
        
        journalRegisterVC.viewModel.exerciseJournal = viewModel.exerciseJournal
        journalRegisterVC.viewModel.editorMode = .edit
        journalRegisterVC.viewModel.title = viewModel.exerciseJournal.title
        journalRegisterVC.viewModel.startTime = viewModel.exerciseJournal.startTime
        journalRegisterVC.viewModel.endTime = viewModel.exerciseJournal.endTime
        journalRegisterVC.viewModel.exerciseArray = viewModel.exerciseJournal.exerciseArray
        journalRegisterVC.viewModel.delegate = self

        present(journalRegisterVC, animated: true)
    }
}

extension DetailExerciseJournalVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if !viewModel.exerciseJournal.photoIdArray!.isEmpty {
            return 4 + viewModel.exerciseJournal.exerciseArray.count
        }
        return 3 + viewModel.exerciseJournal.exerciseArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !viewModel.exerciseJournal.photoIdArray!.isEmpty {
            if section == 0 || section == 1 || section == 2 || section == (3 + viewModel.exerciseJournal.exerciseArray.count) {
                return 1
            }
            return viewModel.exerciseJournal.exerciseArray[section-3].quantity.count + 1
        } else {
            if section == 0 || section == 1 || section == (2 + viewModel.exerciseJournal.exerciseArray.count) {
                return 1
            }
            return viewModel.exerciseJournal.exerciseArray[section-2].quantity.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !viewModel.exerciseJournal.photoIdArray!.isEmpty {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.detailJournalTitleCell) as! DetailJournalTitleCell

                cell.setData(exerciseJournal: viewModel.exerciseJournal)

                return cell
            } else if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.detailJournalPhotoCell) as! DetailJournalPhotoCell

                cell.setData(photoIdList: viewModel.exerciseJournal.photoIdArray!, detailExerciseJournalVC: self)
                

                return cell
            } else if indexPath.section == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.labelCell) as! LabelCell

                return cell
            } else if indexPath.section == (3 + viewModel.exerciseJournal.exerciseArray.count) {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.buttonCell) as! ButtonCell
                
                cell.deleteButton.rx.tap
                    .subscribe(onNext: { _ in
                        AlertManager.shared.presentTwoButtonAlert(title: "삭제", message: "정말로 해당 운동 일지를 삭제하시겠습니까?", buttonTitle: "확인", style: .alert) {
                            LoadingManager.shared.showLoading()
                            FirebaseManager.shared.deleteExerciseJournal(exerciseJournal: self.viewModel.exerciseJournal) { isSuccess in
                                if isSuccess {
                                    LoadingManager.shared.hideLoading()
                                    self.viewModel.delegate?.transferData(exerciseJournal: self.viewModel.exerciseJournal, editorMode: .delete)
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        } completionHandler: { alert in
                            self.present(alert, animated: true)
                        }
                    })
                    .disposed(by: cell.disposeBag)
                
                return cell
            }
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.exerciseTitleCell) as! ExerciseTitleCell

                cell.setData(isHidden: true,
                             exercise: viewModel.exerciseJournal.exerciseArray[indexPath.section-3])

                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.detailJournalSetCell) as! DetailJournalSetCell

                // MARK: - 유저 현재 레벨에 맞는 색깔로 수정해주기
                cell.setData(index: indexPath.row-1,
                             lastIndex: viewModel.exerciseJournal.exerciseArray[indexPath.section-3].quantity.count - 1,
                             currentLevelColor: ColorManager.shared.getCyclamen(),
                             set: indexPath.row,
                             weight: viewModel.exerciseJournal.exerciseArray[indexPath.section-3].quantity[indexPath.row-1].weight,
                             reps: viewModel.exerciseJournal.exerciseArray[indexPath.section-3].quantity[indexPath.row-1].reps)

                return cell
            }
        } else {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.detailJournalTitleCell) as! DetailJournalTitleCell

                cell.setData(exerciseJournal: viewModel.exerciseJournal)

                return cell
            } else if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.labelCell) as! LabelCell

                return cell
            } else if indexPath.section == (2 + viewModel.exerciseJournal.exerciseArray.count) {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.buttonCell) as! ButtonCell
                
                cell.deleteButton.rx.tap
                    .subscribe(onNext: { _ in
                        AlertManager.shared.presentTwoButtonAlert(title: "삭제", message: "정말로 해당 운동 일지를 삭제하시겠습니까?", buttonTitle: "확인", style: .alert) {
                            LoadingManager.shared.showLoading()
                            FirebaseManager.shared.deleteExerciseJournal(exerciseJournal: self.viewModel.exerciseJournal) { isSuccess in
                                if isSuccess {
                                    LoadingManager.shared.hideLoading()
                                    self.viewModel.delegate?.transferData(exerciseJournal: self.viewModel.exerciseJournal, editorMode: .delete)
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        } completionHandler: { alert in
                            self.present(alert, animated: true)
                        }
                    })
                    .disposed(by: cell.disposeBag)
                
                return cell
            }
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.exerciseTitleCell) as! ExerciseTitleCell

                cell.setData(isHidden: true,
                             exercise: viewModel.exerciseJournal.exerciseArray[indexPath.section-2])

                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.detailJournalSetCell) as! DetailJournalSetCell

                // MARK: - 유저 현재 레벨에 맞는 색깔로 수정해주기
                cell.setData(index: indexPath.row-1,
                             lastIndex: viewModel.exerciseJournal.exerciseArray[indexPath.section-2].quantity.count - 1,
                             currentLevelColor: ColorManager.shared.getCyclamen(),
                             set: indexPath.row,
                             weight: viewModel.exerciseJournal.exerciseArray[indexPath.section-2].quantity[indexPath.row-1].weight,
                             reps: viewModel.exerciseJournal.exerciseArray[indexPath.section-2].quantity[indexPath.row-1].reps)

                return cell
            }
        }
    }
}

extension DetailExerciseJournalVC: ExerciseJournalDelegate {
    func transferData(exerciseJournal: ExerciseJournal, editorMode: EditorMode) {
        viewModel.exerciseJournal = exerciseJournal
        detailJournalTableView.reloadData()
    }
}
