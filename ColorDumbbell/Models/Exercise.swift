//
//  Exercise.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/11.
//

import Foundation

struct Exercise {
    var name: String
    var area: ExerciseArea.RawValue
    var quantity: [ExerciseQuantity]
    var id: String
    var type: ExerciseType.RawValue
    var isChecked: Bool = false
}
