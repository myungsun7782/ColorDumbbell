//
//  ExerciseCalendarVC.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/09.
//

import UIKit
import FSCalendar
import RxSwift
import RxCocoa
import SwiftDate

class ExerciseCalendarVC: UIViewController {
    // FSCalendar
    @IBOutlet weak var calendarView: FSCalendar!
    
    // UIButton
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    // UILabel
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var exerciseTimeLabel: UILabel!
    
    // UITableView
    @IBOutlet weak var exerciseTableView: UITableView!
    
    // UIStackView
    @IBOutlet weak var emptyJournalStackView: UIStackView!
    
    // ViewModel
    let viewModel = ExerciseCalendarVM()
    
    // Constants
    let LIST_BUTTON_IMAGE: UIImage? = UIImage(systemName: "list.bullet", withConfiguration: UIImage.SymbolConfiguration(pointSize: 23))
    let ADD_BUTTON_IMAGE: UIImage? = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 23))
    let CALENDAR_HEADER_DATE_FORMAT = "yyyy년 MMMM"
    let LOCALE_IDENTIFIER = "ko_KR"
    let CALENDAR_HEADER_MINIMUM_DISSOLVED_ALPHA: CGFloat = 0
    let CALENDAR_BORDER_RADIUS: CGFloat = 1
    let WEEKDAY_FONT_SIZE: CGFloat = 14.26
    let CALENDAR_TITLE_FONT_SIZE: CGFloat = 14.26
    let CALENDAR_HEADER_FONT_SIZE: CGFloat = 19.75
    let CALENDAR_EVENT_OFFSET_X: Double = -0.3
    let CALENDAR_EVENT_OFFSET_Y: Double = -8
    let CALENDAR_HEADER_TITLE_OFFSET_X: Double = -75
    let CALENDAR_HEADER_TITLE_OFFSET_Y: Double = 0
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        action()
        bind()
    }
    
    private func initUI() {
        // FSCalendar
        configureCalendarView()
        
        // UIButton
        configureButton()
        
        // UILabel
        configureLabel()
        
        // UITableView
        configureTableView()
        
        // Date
        viewModel.currentMonth = Date()
        viewModel.selectedDate = Date().convertTo(region: Region.current).date
        viewModel.selectedExerciseJournal = viewModel.getSpecificJournal(date: Date())
        if let selectedExerciseJournal = viewModel.selectedExerciseJournal {
            exerciseTimeLabel.text = "\(selectedExerciseJournal.totalExerciseTime)분"
            viewModel.setExerciseDivisionArray(exerciseArray: selectedExerciseJournal.exerciseArray)
        } else {
            exerciseTimeLabel.text = "0분"
        }
        
        // UINavigationController
        navigationController?.navigationBar.isHidden = true
    }
    
    private func action() {
        // UIButton
        addButton.rx.tap
            .subscribe(onNext: { _ in
                self.presentJournalRegisterVC()
            })
            .disposed(by: disposeBag)
        
        listButton.rx.tap
            .subscribe(onNext: { _ in
                self.presentMonthlyExerciseVC()
            })
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        
    }
    
    private func configureCalendarView() {
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.appearance.headerTitleColor = ColorManager.shared.getBlack()
        calendarView.appearance.weekdayTextColor = ColorManager.shared.getPhilippineSilver()
        calendarView.appearance.weekdayFont = FontManager.shared.getPretendardBold(fontSize: WEEKDAY_FONT_SIZE)
        calendarView.appearance.titlePlaceholderColor = ColorManager.shared.getGainsboro()
        calendarView.locale = Locale(identifier: LOCALE_IDENTIFIER)
        calendarView.appearance.headerDateFormat = CALENDAR_HEADER_DATE_FORMAT
        calendarView.appearance.headerMinimumDissolvedAlpha = CALENDAR_HEADER_MINIMUM_DISSOLVED_ALPHA
        calendarView.appearance.titleFont = FontManager.shared.getPretendardBold(fontSize: CALENDAR_TITLE_FONT_SIZE)
        calendarView.appearance.headerTitleFont = FontManager.shared.getPretendardBold(fontSize: CALENDAR_HEADER_FONT_SIZE)
        // MARK: - 현재 레벨 색깔로 바꾸기
        calendarView.appearance.titleTodayColor = ColorManager.shared.getCyclamen()
        calendarView.appearance.todayColor = ColorManager.shared.getWhite()
        calendarView.appearance.selectionColor = ColorManager.shared.getCyclamen()
        calendarView.appearance.eventDefaultColor = ColorManager.shared.getCyclamen()
        calendarView.appearance.eventSelectionColor = ColorManager.shared.getWhite()
        calendarView.appearance.headerTitleAlignment = .left
        calendarView.appearance.borderRadius = CALENDAR_BORDER_RADIUS
        calendarView.appearance.eventOffset = .init(x: CALENDAR_EVENT_OFFSET_X, y: CALENDAR_EVENT_OFFSET_Y)
        calendarView.appearance.headerTitleOffset = .init(x: CALENDAR_HEADER_TITLE_OFFSET_X, y: CALENDAR_HEADER_TITLE_OFFSET_Y)
    }
    
    private func configureTableView() {
        exerciseTableView.dataSource = self
        exerciseTableView.delegate = self
        registerTableViewCell()
    }
    
    private func registerTableViewCell() {
        exerciseTableView.register(UINib(nibName: Cell.exerciseCalendarCell, bundle: nil), forCellReuseIdentifier: Cell.exerciseCalendarCell)
    }
    
    private func configureButton() {
        listButton.setImage(LIST_BUTTON_IMAGE, for: .normal)
        addButton.setImage(ADD_BUTTON_IMAGE, for: .normal)
    }
    
    private func configureLabel() {
        dateLabel.text = TimeManager.shared.dateToString(date: Date(), options: [.month, .day, .weekday])
    }
    
    private func presentJournalRegisterVC() {
        let journalRegisterVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: VC.journalRegisterVC) as! JournalRegisterVC
        
        guard let selectedDate = viewModel.selectedDate else { return }
        journalRegisterVC.viewModel.startTime = selectedDate.convertTo(region: Region.current).date
        journalRegisterVC.viewModel.endTime = selectedDate.convertTo(region: Region.current).date
        journalRegisterVC.viewModel.delegate = self
        
        present(journalRegisterVC, animated: true)
    }
    
    private func presentMonthlyExerciseVC() {
        let monthlyExerciseVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: VC.monthlyExerciseVC) as! MonthlyExerciseVC
        
        monthlyExerciseVC.viewModel.month = TimeManager.shared.dateToString(date: viewModel.currentMonth!, options: [.month])
        monthlyExerciseVC.viewModel.exerciseJournalArray = viewModel.getSpecificExerciseJournal()
        
        self.navigationController?.pushViewController(monthlyExerciseVC, animated: true)
    }
}

extension ExerciseCalendarVC: FSCalendarDataSource, FSCalendarDelegate {
    // 캘린더에서 날짜가 선택되었을 때 호출되는 메서드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        dateLabel.text = TimeManager.shared.dateToString(date: date, options: [.month, .day, .weekday])
        viewModel.selectedDate = date
        viewModel.selectedExerciseJournal = viewModel.getSpecificJournal(date: date)
        
        if viewModel.selectedExerciseJournal != nil {
            viewModel.setExerciseDivisionArray(exerciseArray: viewModel.selectedExerciseJournal!.exerciseArray)
            emptyJournalStackView.isHidden = true
            exerciseTimeLabel.text = "\(viewModel.selectedExerciseJournal!.totalExerciseTime)분"
        } else {
            emptyJournalStackView.isHidden = false
            exerciseTimeLabel.text = "0분"
        }
        exerciseTableView.reloadData()
    }
    
    // 캘린더에 표시되는 이벤트 갯수를 반환해주는 메서드
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let selectedDateStr = TimeManager.shared.dateToString(date: date, options: [.year, .month, .day])
        
        return viewModel.registeredDateStrArray.contains(selectedDateStr) ? 1 : 0
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        viewModel.currentMonth = calendar.currentPage
    }
}

extension ExerciseCalendarVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let selectedJournal = viewModel.selectedExerciseJournal {
            return viewModel.getExerciseAreaCount(selectedJournal: selectedJournal)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.exerciseCalendarCell) as! ExerciseCalendarCell
        
        // MARK: - User 현재 레벨에 맞는 색깔 넣어주기! (나중에 수정 필요!)
        if viewModel.selectedExerciseJournal != nil {
            cell.setData(currentLevelColor: ColorManager.shared.getCyclamen(), exerciseArray: viewModel.exerciseDivisionArray[indexPath.row])
        }
        
        return cell
    }
}

extension ExerciseCalendarVC: ExerciseJournalDelegate {
    func transferData(exerciseJournal: ExerciseJournal) {
        viewModel.exerciseJournalArray.append(exerciseJournal)
        viewModel.registeredDateStrArray.append(TimeManager.shared.dateToString(date: exerciseJournal.startTime, options: [.year, .month, .day]))
        viewModel.selectedExerciseJournal = exerciseJournal
        viewModel.setExerciseDivisionArray(exerciseArray: viewModel.selectedExerciseJournal!.exerciseArray)
        emptyJournalStackView.isHidden = true
        exerciseTimeLabel.text = "\(exerciseJournal.totalExerciseTime)분"
        calendarView.reloadData()
        exerciseTableView.reloadData()
    }
}
