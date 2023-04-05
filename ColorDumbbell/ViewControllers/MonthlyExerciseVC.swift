//
//  MonthlyExerciseVC.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class MonthlyExerciseVC: UIViewController {
    // UIStatusBarStyle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // UIStackView
    @IBOutlet weak var leftStackView: UIStackView!
    
    // UIButton
    @IBOutlet weak var backButton: UIButton!
    
    // UILabel
    @IBOutlet weak var monthLabel: UILabel!
    
    // UITableView
    @IBOutlet weak var monthlyExerciseTableView: UITableView!
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    // ViewModel
    let viewModel = MonthlyExerciseVM()
    
    // Variables

    // Constants
    let BACK_BUTTON_IMAGE: UIImage? = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .bold))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        action()
    }
    
    private func initUI() {
        // UINavigationController
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        // UIButton
        configureButton()
        
        // UILabel
        configureLabel()
        
        // UITableView
        configureTableView()
    }
    
    private func action() {
        // UIButton
        leftStackView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                if let modifiedExerciseJournal = self.viewModel.modifiedExerciseJournal {
                    self.viewModel.delegate?.transferData(exerciseJournal: modifiedExerciseJournal, editorMode: .edit)
                }
                if let deletedExerciseJournal = self.viewModel.deletedExerciseJournal {
                    self.viewModel.delegate?.transferData(exerciseJournal: deletedExerciseJournal, editorMode: .delete)
                }
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureButton() {
        backButton.setImage(BACK_BUTTON_IMAGE, for: .normal)
    }
    
    private func configureLabel() {
        monthLabel.text = viewModel.month
    }
    
    private func configureTableView() {
        monthlyExerciseTableView.dataSource = self
        monthlyExerciseTableView.delegate = self
        registerTableViewCell()
    }
    
    private func registerTableViewCell() {
        monthlyExerciseTableView.register(UINib(nibName: Cell.exerciseDateCell, bundle: nil), forCellReuseIdentifier: Cell.exerciseDateCell)
        monthlyExerciseTableView.register(UINib(nibName: Cell.exerciseCalendarCell, bundle: nil), forCellReuseIdentifier: Cell.exerciseCalendarCell)
    }
    
    private func presentDetailExerciseJournalVC(exerciseJournal: ExerciseJournal) {
        let detailExerciseJournalVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: VC.detailExerciseJournal) as! DetailExerciseJournalVC
        
        detailExerciseJournalVC.viewModel.journalDate = TimeManager.shared.dateToString(date: exerciseJournal.startTime.date, options: [.month, .day])
        detailExerciseJournalVC.viewModel.exerciseJournal = exerciseJournal
        detailExerciseJournalVC.viewModel.delegate = self
        
        navigationController?.pushViewController(detailExerciseJournalVC, animated: true)
    }
}

extension MonthlyExerciseVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.exerciseJournalArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !viewModel.exerciseJournalArray[section].groupedExerciseArray.isEmpty {
            return viewModel.exerciseJournalArray[section].groupedExerciseArray.count + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.exerciseDateCell) as! ExerciseDateCell
            
            cell.setData(exerciseJournal: viewModel.exerciseJournalArray[indexPath.section])
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.exerciseCalendarCell) as! ExerciseCalendarCell
        
        // MARK: - 사용자 현재 레벨에 맞는 색깔로 수정하기!
        cell.setData(index: indexPath.row-1,
                     lastIndex: viewModel.exerciseJournalArray[indexPath.section].groupedExerciseArray.count-1,
                     currentLevelColor: ColorManager.shared.getCyclamen(),
                     exerciseArray: viewModel.exerciseJournalArray[indexPath.section].groupedExerciseArray[indexPath.row-1])
        
        cell.containerStackView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.presentDetailExerciseJournalVC(exerciseJournal: self.viewModel.exerciseJournalArray[indexPath.section])
            })
            .disposed(by: cell.disposeBag)
        
        return cell
    }
}

extension MonthlyExerciseVC: ExerciseJournalDelegate {
    func transferData(exerciseJournal: ExerciseJournal, editorMode: EditorMode) {
        if editorMode == .edit {
            for (idx, exerciseJournalObj) in viewModel.exerciseJournalArray.enumerated() {
                if exerciseJournalObj.id == exerciseJournal.id {
                    viewModel.modifiedExerciseJournal = exerciseJournal
                    viewModel.exerciseJournalArray[idx] = exerciseJournal
                    break
                }
            }
        } else if editorMode == .delete {
            for (idx, exerciseJournalObj) in viewModel.exerciseJournalArray.enumerated() {
                if exerciseJournalObj.id == exerciseJournal.id {
                    viewModel.deletedExerciseJournal = exerciseJournal
                    viewModel.exerciseJournalArray.remove(at: idx)
                    break
                }
            }
        }
        monthlyExerciseTableView.reloadData()
    }
}
