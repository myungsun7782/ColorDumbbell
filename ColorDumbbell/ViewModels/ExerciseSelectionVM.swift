//
//  ExerciseSelectionVM.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/13.
//

import Foundation
import RxSwift

class ExerciseSelectionVM {
    // Input
    var input = Input()
    
    // Output
    var output = Output()
    
    // Variable
    var exerciseArray: [Exercise] = Array<Exercise>()
    var totalExerciseArray: [[Exercise]] = []
    var routineArray: [Routine] = []
    var isEditorModeOn: Bool = false
    var isClicked: Bool = false
    var exerciseDelegate: ExerciseDelegate?
    var routineDelegate: ExerciseRoutineDelegate?
    
    // Constants
    let EXERCISE_AREA_ARRAY: [ExerciseArea] = [.back, .chest, .shoulder, .leg, .arm, .abs]
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    init() {
        totalExerciseArray = ExerciseManager.shared.totalExerciseArray
        routineArray = ExerciseManager.shared.routineArray
    }
 
    func validateFinishButton() -> Bool {
        for exerciseArray in totalExerciseArray {
            for exercise in exerciseArray {
                if exercise.isChecked {
                    return true
                }
            }
        }
        return false
    }
    
    func getSelectedExercises(totalExerciseArray: [[Exercise]]) -> [Exercise] {
        var exerciseArray: [Exercise] = Array<Exercise>()
        
        for exerciseArr in totalExerciseArray {
            for exercise in exerciseArr {
                if exercise.isChecked == true {
                    exerciseArray.append(exercise)
                }
            }
        }
        
        return exerciseArray
    }
}
