//
//  User.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/07.
//

import Foundation

struct User {
    var uid: String
    var name: String
    var exerciseTime: Date
    var currentLevel: Level
    var totalExerciseCount: Int
    
    init(name: String, exerciseTime: Date) {
        self.uid = UUID().uuidString
        self.name = name
        self.exerciseTime = exerciseTime
        self.currentLevel = .pink
        self.totalExerciseCount = 0
    }
}
