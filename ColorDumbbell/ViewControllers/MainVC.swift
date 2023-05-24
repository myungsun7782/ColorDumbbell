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
import UserNotifications

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
    
    // UNUserNotificationCenter
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initNotification()
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
    
    private func initNotification() {
        userNotificationCenter.delegate = self
        requestNotificationAuthorization()
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
    
    private func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        
        userNotificationCenter.requestAuthorization(options: authOptions) { granted, error in
            if let error = error {
                print("Error: \(error)")
            }
            if granted {
                UserDefaultsManager.shared.setPushAuthStatus(pushAuthStatus: granted)
                if !UserDefaultsManager.shared.getIsPushInitialized() {
                    let userExerciseTime = UserDefaultsManager.shared.getExerciseTime()
                    self.schedulePeriodicLocalNotification(hour: userExerciseTime.convertTo(region: Region.current).hour, minute: userExerciseTime.convertTo(region: Region.current).minute)
                    UserDefaultsManager.shared.setIsPushInitialized(isInitialized: true)
                }
            }
        }
    }
    
    func schedulePeriodicLocalNotification(hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "운동 준비 알림"
        content.body = "운동을 맛있게 즐길 수 있도록 준비할 시간입니다."
        content.sound = .default
        
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UserDefaultsManager.shared.getUserUid(), content: content, trigger: trigger)
        
        userNotificationCenter.add(request) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for \(hour):\(minute) and will repeat daily")
            }
        }
    }
    
    private func presentMyPageVC() {
        let myPageVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: VC.myPageVC) as! MyPageVC
        
        myPageVC.viewModel.currentMonthCount = viewModel.currentMonthCount
        myPageVC.viewModel.totalExerciseCount = viewModel.exerciseJournalArray.count
        myPageVC.viewModel.mainVC = self
        myPageVC.modalPresentationStyle = .fullScreen
        myPageVC.modalTransitionStyle = .crossDissolve
        
        self.present(myPageVC, animated: true)
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
            cell.editButton.rx.tap
                .subscribe(onNext: { _ in
                    self.presentMyPageVC()
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

extension MainVC: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert, .badge, .sound])
    }
}
