//
//  MainVM.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/09.
//

import Foundation
import RxSwift
import SwiftDate

class MainVM {
    // Input
    var input = Input()
    
    // Output
    var output = Output()
    
    // Variable
    var userName: String?
    var exerciseTimeArray: [Int?] = Array<Int?>()
    var currentMonthCount: Int = 0
    var previousMonthCount: Int = 0
    var exerciseJournalArray: [ExerciseJournal] = Array<ExerciseJournal>()
    
    // Constants
    let WEEK_DAY_STRING: String = "요일"
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        var fetchTimeDataDone = PublishSubject<Void>()
        var fetchEntireJournalDataDone = PublishSubject<Void>()
    }
    
    init() {

    }
    
    func fetchCurrentMonthData() {
        let currentDate = Date()
        FirebaseManager.shared.fetchExerciseTimeInMonth(year: currentDate.year, month: currentDate.month) { previousCurrentMonthJournals, isSuccess in
            if isSuccess {
                self.getExerciseTimeDataForThisWeek(exerciseJournals: previousCurrentMonthJournals!, currentDate: Date())
                self.getCurrentPreviousCount(exerciseJournals: previousCurrentMonthJournals!)
                self.output.fetchTimeDataDone.onNext(())
            }
        }
    }
    
    private func getJournal(exerciseJournals: [ExerciseJournal], date: Date) -> ExerciseJournal? {
        for journal in exerciseJournals {
            if TimeManager.shared.dateToString(date: journal.startTime, options: [.year, .month, .day]) == TimeManager.shared.dateToString(date: date, options: [.year, .month, .day]) {
                return journal
            }
        }
        return nil
    }
    
    private func getCurrentPreviousCount(exerciseJournals: [ExerciseJournal]) {
        let currentDate = Date()
        let previousDate = currentDate - 1.months
        currentMonthCount = 0
        previousMonthCount = 0
        exerciseJournals.forEach { exerciseJournal in
            if TimeManager.shared.dateToString(date: exerciseJournal.startTime, options: [.year, .month]) == TimeManager.shared.dateToString(date: currentDate, options: [.year, .month]) {
                self.currentMonthCount += 1
            } else if TimeManager.shared.dateToString(date: exerciseJournal.startTime, options: [.year, .month]) == TimeManager.shared.dateToString(date: previousDate, options: [.year, .month]) {
                self.previousMonthCount += 1
            }
        }
    }
    
    private func getExerciseTimeDataForThisWeek(exerciseJournals: [ExerciseJournal], currentDate: Date) {
        let weekDates = datesOfCurrentWeek()
        exerciseTimeArray = []
        for dateValue in weekDates {
            let exerciseJournal = getJournal(exerciseJournals: exerciseJournals, date: dateValue)
            if let exerciseJournal = exerciseJournal {
                exerciseTimeArray.append(exerciseJournal.totalExerciseTime)
            } else {
                exerciseTimeArray.append(nil)
            }
        }
    }
    
    private func datesOfCurrentWeek() -> [Date] {
        let today = Date()
        let calendar = Calendar.current
        let startOfWeek = today.dateAtStartOf(.weekOfYear)
        var dates: [Date] = []
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                dates.append(date)
            }
        }
        return dates
    }
    
    func fetchExerciseJournals() {
        FirebaseManager.shared.fetchExerciseJournals { exerciseJournalArray, isSuccess in
            if isSuccess {
                self.exerciseJournalArray = exerciseJournalArray!
                self.output.fetchEntireJournalDataDone.onNext(())
            } else {
            }
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
