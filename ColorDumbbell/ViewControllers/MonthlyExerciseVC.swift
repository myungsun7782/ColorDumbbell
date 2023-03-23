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
    let BACK_BUTTON_IMAGE: UIImage? = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        action()
        viewModel.makeGroupExerciseArray()
    }
    
    private func initUI() {
        // UINavigationController
        navigationController?.navigationBar.isHidden = true
        
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
}

extension MonthlyExerciseVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.exerciseJournalArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let groupedExerciseArray = viewModel.exerciseJournalArray[section].groupedExerciseArray {
            return groupedExerciseArray.count + 1
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
        cell.setData(index: indexPath.row-1, lastIndex: viewModel.exerciseJournalArray[indexPath.section].groupedExerciseArray!.count-1, currentLevelColor: ColorManager.shared.getCyclamen(), exerciseArray: viewModel.exerciseJournalArray[indexPath.section].groupedExerciseArray![indexPath.row-1])
        
        return cell
    }
}
