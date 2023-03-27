//
//  ExerciseJournalProtocol.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/22.
//

import Foundation

protocol ExerciseJournalDelegate: AnyObject {
    func transferData(exerciseJournal: ExerciseJournal, editorMode: EditorMode)
}
