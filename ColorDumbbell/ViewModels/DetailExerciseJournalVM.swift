//
//  DetailExerciseJournalVM.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/24.
//

import Foundation
import RxSwift

class DetailExerciseJournalVM {
    // Input
    var input = Input()
    
    // Output
    var output = Output()
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    // Variable
    var journalDate: String!
    var exerciseJournal: ExerciseJournal!
    
    // Constants

    struct Input {

    }
    
    struct Output {

    }
    
    init() {

    }
}
