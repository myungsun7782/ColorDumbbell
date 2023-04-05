//
//  MonthlyExerciseVM.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/23.
//

import Foundation
import RxSwift

class MonthlyExerciseVM {
    // Input
    var input = Input()
    
    // Output
    var output = Output()
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    // Variable
    var month: String!
    var exerciseJournalArray: [ExerciseJournal] = Array<ExerciseJournal>()
    var modifiedExerciseJournal: ExerciseJournal?
    var deletedExerciseJournal: ExerciseJournal?
    var delegate: ExerciseJournalDelegate?
    
    // Constants
    
    struct Input {

    }
    
    struct Output {

    }
    
    init() {

    }
}
