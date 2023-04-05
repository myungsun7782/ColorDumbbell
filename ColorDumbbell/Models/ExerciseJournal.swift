//
//  ExerciseJournal.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/11.
//

import UIKit

class ExerciseJournal {
    var id: String
    var title: String
    var registerDate: Date
    var startTime: Date
    var endTime: Date
    var totalExerciseTime: Int
    var photoIdArray: [String]?
    var exerciseArray: [Exercise]
    var groupedExerciseArray: [[Exercise]]
    var registeredDateString: String
    
    init(id: String, title: String, registerDate: Date, startTime: Date, endTime: Date, totalExerciseTime: Int, photoIdArray: [String]? = nil, exerciseArray: [Exercise]) {
        self.id = id
        self.title = title
        self.registerDate = registerDate
        self.startTime = startTime
        self.endTime = endTime
        self.totalExerciseTime = totalExerciseTime
        self.photoIdArray = photoIdArray
        self.exerciseArray = exerciseArray
        self.groupedExerciseArray = []
        self.registeredDateString = TimeManager.shared.dateToString(date: startTime, options: [.year, .month, .day])
        
        exerciseArray.forEach { exercise in
            if isDivisionConstains(area: exercise.area) {
                addExerciseToDivision(exercise: exercise)
            } else {
                groupedExerciseArray.append([exercise])
            }
        }
    }
    
    func divisionExerciseArray(exerciseArray: [Exercise]) {
        self.groupedExerciseArray = []
        exerciseArray.forEach { exercise in
            if isDivisionConstains(area: exercise.area) {
                addExerciseToDivision(exercise: exercise)
            } else {
                groupedExerciseArray.append([exercise])
            }
        }
    }
    
    private func isDivisionConstains(area: ExerciseArea.RawValue) -> Bool {
        for division in groupedExerciseArray {
            if division[0].area == area {
                return true
            }
        }
        
        return false
    }
    
    private func addExerciseToDivision(exercise: Exercise) {
        for (idx, groupedExercise) in groupedExerciseArray.enumerated() {
            if groupedExercise[0].area == exercise.area {
                groupedExerciseArray[idx].append(exercise)
            }
        }
    }
}
