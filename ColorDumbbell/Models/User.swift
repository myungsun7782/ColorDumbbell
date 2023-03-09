//
//  User.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/07.
//

import Foundation

struct User: Codable {
    var uid: String
    var name: String
    var exerciseTime: Date
    var currentLevel: Level.RawValue
    var totalExerciseCount: Int
    
    init(name: String, exerciseTime: Date) {
        self.uid = UUID().uuidString
        self.name = name
        self.exerciseTime = exerciseTime
        self.currentLevel = Level.pink.rawValue
        self.totalExerciseCount = 0
    }
}
