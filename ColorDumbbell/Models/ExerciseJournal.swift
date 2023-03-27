//
//  ExerciseJournal.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/11.
//

import UIKit

struct ExerciseJournal {
    var id: String
    var title: String
    var registerDate: Date
    var startTime: Date
    var endTime: Date
    var totalExerciseTime: Int
    var photoIdArray: [String]?
    var exerciseArray: [Exercise]
    var groupedExerciseArray: [[Exercise]]?
}
