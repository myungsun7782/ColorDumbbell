//
//  UserInfoProtocol.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/04/18.
//

import Foundation

protocol UserInfoDelegate: AnyObject {
    func updateName(name: String)
    func updateExerciseTime(exerciseTime: Date)
}
