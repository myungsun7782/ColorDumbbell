//
//  ViewController.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/06.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftDate

class MainVC: UIViewController {
    // UIStatusBarStyle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent 
    }
    
    // UITableView
    @IBOutlet weak var mainTableView: UITableView!
    
    
    // ViewModel
    let viewModel = MainVM()
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        action()
        bind()
        viewModel.fetchExerciseJournals()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchCurrentMonthData()
    }
    
    private func initUI() {
        // UITableView
        configureTableView()
    }
    
    private func action() {
        
    }
    
    private func bind() {
        viewModel.output.fetchTimeDataDone
            .subscribe(onNext: { _ in
                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.fetchEntireJournalDataDone
            .subscribe(onNext: { _ in
                
            })
            .disposed(by: disposeBag)
    }
    
    private func configureTableView() {
        mainTableView.dataSource = self
        mainTableView.delegate = self
        registerTableViewCell()
    }
    
    private func registerTableViewCell() {
        mainTableView.register(UINib(nibName: Cell.mainTopCell, bundle: nil), forCellReuseIdentifier: Cell.mainTopCell)
        mainTableView.register(UINib(nibName: Cell.mainMidCell, bundle: nil), forCellReuseIdentifier: Cell.mainMidCell)
        mainTableView.register(UINib(nibName: Cell.mainBottomCell, bundle: nil), forCellReuseIdentifier: Cell.mainBottomCell)
    }
    
    private func presentJournalRegisterVC() {
        let journalRegisterVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: VC.journalRegisterVC) as! JournalRegisterVC
        
        let currentDate = Date()
        journalRegisterVC.viewModel.startTime = currentDate.convertTo(region: Region.current).date
        journalRegisterVC.viewModel.endTime = currentDate.convertTo(region: Region.current).date.addingTimeInterval(60)
        journalRegisterVC.viewModel.delegate = self
        journalRegisterVC.viewModel.exerciseJournalArray = viewModel.exerciseJournalArray
        
        present(journalRegisterVC, animated: true)
    }
}

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.mainTopCell) as! MainTopCell
            let userName = UserDefaultsManager.shared.getUserName()
            
            cell.setData(name: userName, index: indexPath.row)
            cell.convenienceButton.rx.tap
                .subscribe(onNext: { _ in
                    self.presentJournalRegisterVC()
                })
                .disposed(by: cell.disposeBag)
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.mainMidCell) as! MainMidCell
            
            cell.setData(exerciseTimeArray: viewModel.exerciseTimeArray)
            
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.mainBottomCell) as! MainBottomCell
            
            cell.setData(currentMonthCount: viewModel.currentMonthCount, previousMonthCount: viewModel.previousMonthCount)
            
            return cell
        }
       
        return UITableViewCell()
    }
}

extension MainVC: ExerciseJournalDelegate {
    func transferData(exerciseJournal: ExerciseJournal, editorMode: EditorMode) {
        if editorMode == .new {
            if TimeManager.shared.dateToString(date: Date(), options: [.year, .month, .day]) == TimeManager.shared.dateToString(date: exerciseJournal.registerDate, options: [.year, .month, .day]) {
                viewModel.updateUserTotalCount(exerciseJournal: exerciseJournal, editorMode: editorMode)
            }
        } 
    }
}

