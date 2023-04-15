//
//  ExerciseCalendarVM.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/21.
//

import Foundation
import RxSwift

class ExerciseCalendarVM {
    // Input
    var input = Input()
    
    // Output
    var output = Output()
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    // Variable
    var selectedDate: Date?
    var exerciseJournalArray: [ExerciseJournal] = Array<ExerciseJournal>()
    var currentMonth: Date?
    
    // Constants
    let EXERCISE_AREA_ARRAY: [ExerciseArea] = [.back, .chest, .shoulder, .leg, .arm, .abs]
    let ALERT_TITLE: String = "운동 일지를 등록할 수 없음"
    let ALERT_MESSAGE: String = "해당 날짜에는 이미 등록된 운동 일지가 있습니다."
    let BUTTON_TITLE: String = "확인"
    
    struct Input {
        
    }
    
    struct Output {
        var fetchDataDone = PublishSubject<Void>()
    }
    
    init() {

    }
    
    func getJournal() -> ExerciseJournal? {
        for journal in exerciseJournalArray {
            if TimeManager.shared.dateToString(date: journal.startTime, options: [.year, .month, .day]) == TimeManager.shared.dateToString(date: selectedDate!, options: [.year, .month, .day]) {
                return journal
            }
        }
        return nil
    }
    
    func getSpecificExerciseJournal() -> [ExerciseJournal] {
        var specificExerciseJournal: [ExerciseJournal] = Array<ExerciseJournal>()
        
        for journal in exerciseJournalArray {
            if TimeManager.shared.dateToString(date: journal.startTime, options: [.year, .month]) == TimeManager.shared.dateToString(date: currentMonth!, options: [.year, .month]) {
                specificExerciseJournal.append(journal)
            }
        }
        
        specificExerciseJournal.sort { $0.startTime < $1.startTime }
        
        return specificExerciseJournal
    }
    
    func fetchExerciseJournals() {
        LoadingManager.shared.showLoading()
        FirebaseManager.shared.fetchExerciseJournals { exerciseJournalArray, isSuccess in
            if isSuccess {
                self.exerciseJournalArray = exerciseJournalArray!
                self.output.fetchDataDone.onNext(())
            } else {
                LoadingManager.shared.hideLoading()
            }
        }
    }
    
    func isDuplicateExerciseJournal() -> Bool {
        return getJournal() == nil ? false : true
    }
    
    func presentDupJournalAlert(exerciseCalendarVC: ExerciseCalendarVC) {
        AlertManager.shared.presentOneButtonAlert(title: ALERT_TITLE, message: ALERT_MESSAGE) {
        } completionHandler: { alert in
            exerciseCalendarVC.present(alert, animated: true)
        }
    }
    
    func updateUserTotalCount(exerciseJournal: ExerciseJournal, editorMode: EditorMode) {
        if editorMode == .new {
            var currentTotalExerciseCount = UserDefaultsManager.shared.getExerciseTotalCount()
            UserDefaultsManager.shared.setExerciseTotalCount(totalExerciseCount: currentTotalExerciseCount + 1)
            FirebaseManager.shared.updateTotalCount(totalExerciseCount: currentTotalExerciseCount + 1) { isSuccess in
                if isSuccess {
                    print("Successfully update totalCount!!!")
                }
            }
        } else if editorMode == .delete {
            var currentTotalExerciseCount = UserDefaultsManager.shared.getExerciseTotalCount()
            UserDefaultsManager.shared.setExerciseTotalCount(totalExerciseCount: currentTotalExerciseCount - 1)
            FirebaseManager.shared.updateTotalCount(totalExerciseCount: currentTotalExerciseCount - 1) { isSuccess in
                if isSuccess {
                    print("Successfully update totalCount!!!")
                }
            }
        }
    }
}
