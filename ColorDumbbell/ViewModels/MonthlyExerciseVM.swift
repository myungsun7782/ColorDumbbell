//
//  MonthlyExerciseVM.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/23.
//

import Foundation
import RxSwift

class MonthlyExerciseVM {
    // Input
    var input = Input()
    
    // Output
    var output = Output()
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    // Variable
    var month: String!
    var exerciseJournalArray: [ExerciseJournal] = Array<ExerciseJournal>()
    
    // Constants
    
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
    
    func makeGroupExerciseArray() {
        for (idx, journal) in exerciseJournalArray.enumerated() {
            var groupArray: [[Exercise]] = [[], [], [], [], [], []]
            var groupedExerciseArray: [[Exercise]] = []
            
            for exercise in journal.exerciseArray {
                switch exercise.area {
                case ExerciseArea.back.rawValue:
                    groupArray[0].append(exercise)
                case ExerciseArea.chest.rawValue:
                    groupArray[1].append(exercise)
                case ExerciseArea.shoulder.rawValue:
                    groupArray[2].append(exercise)
                case ExerciseArea.leg.rawValue:
                    groupArray[3].append(exercise)
                case ExerciseArea.arm.rawValue:
                    groupArray[4].append(exercise)
                case ExerciseArea.abs.rawValue:
                    groupArray[5].append(exercise)
                default:
                    break
                }
            }
            
            for group in groupArray {
                if !group.isEmpty {
                    groupedExerciseArray.append(group)
                }
            }
            exerciseJournalArray[idx].groupedExerciseArray = groupedExerciseArray
        }
    }
}
