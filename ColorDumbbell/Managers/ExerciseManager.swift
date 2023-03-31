//
//  ExerciseManager.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/31.
//

import Foundation

class ExerciseManager {
    static let shared = ExerciseManager()
    var exerciseArray: [Exercise] = Array<Exercise>()
    var totalExerciseArray: [[Exercise]] = [[], [], [], [], [], []]
    let EXERCISE_AREA_ARRAY: [ExerciseArea] = [.back, .chest, .shoulder, .leg, .arm, .abs]
    
    
    private init() {}
    
    func getDefaultExercise() {
        FirebaseManager.shared.getDefaultExercises { exerciseArray in
            self.exerciseArray = exerciseArray
            self.setSpecificExercise()
        }
    }
    
    private func getSpecificExercise(exerciseArea: ExerciseArea, exericseArray: [Exercise]) -> [Exercise] {
        var specificExerciseArray = Array<Exercise>()
        
        for exercise in exericseArray {
            if exercise.area == exerciseArea.rawValue {
                specificExerciseArray.append(exercise)
            }
        }
        
        return specificExerciseArray
    }
    
    private func setSpecificExercise() {
        totalExerciseArray[0].append(contentsOf: getSpecificExercise(exerciseArea: EXERCISE_AREA_ARRAY[0], exericseArray: exerciseArray))
        totalExerciseArray[1].append(contentsOf: getSpecificExercise(exerciseArea: EXERCISE_AREA_ARRAY[1], exericseArray: exerciseArray))
        totalExerciseArray[2].append(contentsOf: getSpecificExercise(exerciseArea: EXERCISE_AREA_ARRAY[2], exericseArray: exerciseArray))
        totalExerciseArray[3].append(contentsOf: getSpecificExercise(exerciseArea: EXERCISE_AREA_ARRAY[3], exericseArray: exerciseArray))
        totalExerciseArray[4].append(contentsOf: getSpecificExercise(exerciseArea: EXERCISE_AREA_ARRAY[4], exericseArray: exerciseArray))
        totalExerciseArray[5].append(contentsOf: getSpecificExercise(exerciseArea: EXERCISE_AREA_ARRAY[5], exericseArray: exerciseArray))
    }
}
