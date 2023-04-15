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
    var routineArray: [Routine] = Array<Routine>()
    
    
    private init() {}
    
    func getDefaultExercise() {
        FirebaseManager.shared.getUserDefaultExercises { exerciseArray in
            self.exerciseArray = exerciseArray
            FirebaseManager.shared.getUserCustomExercise { exerciseArray, isSuccess in
                if isSuccess {
                    exerciseArray.forEach { exercise in
                        self.exerciseArray.append(exercise)
                    }
                }
                self.setSpecificExercise()
            }
        }
    }
    
    func getRountineArray() {
        FirebaseManager.shared.fetchRotines { routineArray, isSuccess in
            if isSuccess {
                self.routineArray = routineArray!
            }
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
    
    func figureExercise(exerciseObj: Exercise, editorMode: EditorMode) {
        switch editorMode {
        case .new:
            for (i, exerciseArray) in totalExerciseArray.enumerated() {
                for (_, exercise) in exerciseArray.enumerated() {
                    if exercise.area == exerciseObj.area {
                        totalExerciseArray[i].append(exerciseObj)
                        break
                    }
                }
            }
        case .edit:
            for (i, exerciseArray) in totalExerciseArray.enumerated() {
                for (j, exercise) in exerciseArray.enumerated() {
                    if exercise.id == exerciseObj.id {
                        totalExerciseArray[i][j] = exerciseObj
                        break
                    }
                }
            }
        case .delete:
            for (i, exerciseArray) in totalExerciseArray.enumerated() {
                for (j, exercise) in exerciseArray.enumerated() {
                    if exercise.id == exerciseObj.id {
                        totalExerciseArray[i].remove(at: j)
                        break
                    }
                }
            }
        default:
            break
        }
    }
    
    func figureRoutine(routineObj: Routine, editorMode: EditorMode) {
        switch editorMode {
        case .new:
            routineArray.append(routineObj)
        case .edit:
            for (idx, routine) in routineArray.enumerated() {
                if routine.id == routineObj.id {
                    routineArray[idx] = routine
                    break
                }
            }
        case .delete:
            for (idx, routine) in routineArray.enumerated() {
                if routine.id == routineObj.id {
                    routineArray.remove(at: idx)
                    break
                }
            }
        default:
            break
        }
    }
}
