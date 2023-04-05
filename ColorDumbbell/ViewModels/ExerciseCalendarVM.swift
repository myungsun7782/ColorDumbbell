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
}
