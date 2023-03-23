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
    var selectedExerciseJournal: ExerciseJournal?
    var registeredDateStrArray: [String] = Array<String>()
    var totalExerciseArray: [[Exercise]] = [[], [], [], [], [], []]
    var exerciseDivisionArray: [[Exercise]] = Array<[Exercise]>()
    var currentMonth: Date?
    
    // Constants
    let EXERCISE_AREA_ARRAY: [ExerciseArea] = [.back, .chest, .shoulder, .leg, .arm, .abs]
    
    struct Input {
        
    }
    
    struct Output {

    }
    
    init() {

    }
    
    func getExerciseAreaCount(selectedJournal: ExerciseJournal) -> Int {
        var count = 0
        var exerciseAreaDictionary: [String: Int] = [ExerciseArea.back.rawValue: 0 , ExerciseArea.chest.rawValue: 0 , ExerciseArea.shoulder.rawValue: 0, ExerciseArea.leg.rawValue: 0, ExerciseArea.arm.rawValue: 0, ExerciseArea.abs.rawValue: 0]
        
        for exercise in selectedJournal.exerciseArray {
            exerciseAreaDictionary[exercise.area]! += 1
        }
        
        for (_, value) in exerciseAreaDictionary {
            if value != 0 {
                count += 1
            }
        }
        
        return count
    }
    
    func getSpecificJournal(date: Date) -> ExerciseJournal? {
        for journal in exerciseJournalArray {
            if TimeManager.shared.dateToString(date: journal.startTime, options: [.year, .month, .day]) == TimeManager.shared.dateToString(date: date, options: [.year, .month, .day]) {
                return journal
            }
        }
        return nil
    }
    
    private func setTotalExerciseArray(exerciseArray: [Exercise]) {
        totalExerciseArray = [[], [], [], [], [], []]
        for exercise in exerciseArray {
            switch exercise.area {
            case ExerciseArea.back.rawValue:
                totalExerciseArray[0].append(exercise)
            case ExerciseArea.chest.rawValue:
                totalExerciseArray[1].append(exercise)
            case ExerciseArea.shoulder.rawValue:
                totalExerciseArray[2].append(exercise)
            case ExerciseArea.leg.rawValue:
                totalExerciseArray[3].append(exercise)
            case ExerciseArea.arm.rawValue:
                totalExerciseArray[4].append(exercise)
            case ExerciseArea.abs.rawValue:
                totalExerciseArray[5].append(exercise)
            default:
                break
            }
        }
    }
    
    private func divideExercise() {
        exerciseDivisionArray = []
        for exerciseArray in totalExerciseArray {
            if !exerciseArray.isEmpty {
                exerciseDivisionArray.append(exerciseArray)
            }
        }
    }
    
    func setExerciseDivisionArray(exerciseArray: [Exercise]) {
        setTotalExerciseArray(exerciseArray: exerciseArray)
        divideExercise()
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
}
