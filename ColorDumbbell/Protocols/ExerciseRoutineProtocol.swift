//
//  ExerciseRoutineProtocol.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/28.
//

import Foundation

protocol ExerciseRoutineDelegate: AnyObject {
    func transferData(section: Int?, routine: Routine, editorMode: EditorMode)
}
