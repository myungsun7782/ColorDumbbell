//
//  ExerciseProtocol.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/16.
//

import Foundation

protocol ExerciseDelegate: AnyObject {
    func manageExercise(section: Int, row: Int, exerciseName: String, editorMode: EditorMode)
    func selectExercises(exerciseArray: [Exercise])
}
