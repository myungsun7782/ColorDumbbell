//
//  ExerciseQuantity.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/11.
//

import Foundation

struct ExerciseQuantity {
    var weight: Double // 무게(kg)
    var reps: Int
    
    init() {
        self.weight = 0
        self.reps = 0
    }
    
    init(weight: Double, reps: Int) {
        self.weight = weight
        self.reps = reps
    }
}
