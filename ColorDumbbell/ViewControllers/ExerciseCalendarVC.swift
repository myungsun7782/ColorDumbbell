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

class ExerciseCalendarVC: UIViewController {
    // FSCalendar
    @IBOutlet weak var calendarView: FSCalendar!
    
    // UIButton
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    // UILabel
    @IBOutlet weak var dateLabel: UILabel!
    
    // UITableView
    @IBOutlet weak var exerciseTableView: UITableView!
    
    // UIStackView
    @IBOutlet weak var emptyJournalStackView: UIStackView!
    
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
    let CALENDAR_EVENT_OFFSET_Y: Double = -11
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
    }
    
    private func action() {
        // UIButton
        addButton.rx.tap
            .subscribe(onNext: { _ in
                self.presentJournalRegisterVC()
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
        calendarView.appearance.eventSelectionColor = ColorManager.shared.getCyclamen()
        calendarView.appearance.headerTitleAlignment = .left
        calendarView.appearance.borderRadius = CALENDAR_BORDER_RADIUS
        calendarView.appearance.eventOffset = .init(x: CALENDAR_EVENT_OFFSET_X, y: CALENDAR_EVENT_OFFSET_Y)
        calendarView.appearance.headerTitleOffset = .init(x: CALENDAR_HEADER_TITLE_OFFSET_X, y: CALENDAR_HEADER_TITLE_OFFSET_Y)
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
        
        present(journalRegisterVC, animated: true)
    }
}

extension ExerciseCalendarVC: FSCalendarDataSource, FSCalendarDelegate {
    // 캘린더에서 날짜가 선택되었을 때 호출되는 메서드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        dateLabel.text = TimeManager.shared.dateToString(date: date, options: [.month, .day, .weekday])
    }
    
    // 캘린더에 표시되는 이벤트 갯수를 반환해주는 메서드
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
}
