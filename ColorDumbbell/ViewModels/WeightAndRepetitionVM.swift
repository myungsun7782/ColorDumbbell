//
//  WeightAndRepetitionVM.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/17.
//

import Foundation
import RxSwift

class WeightAndRepetitionsVM {
    // Input
    var input = Input()
    
    // Output
    var output = Output()
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    // Variable
    var section: Int!
    var row: Int!
    var weight: Double!
    var reps: Int!
    var delegate: WeightAndRepetitionDelegate?
    
    // Constants
    let WEIGHT_DEFAULT_VALUE: String = "0"
    let REPS_DEFAULT_VALUE: String = "0"
    
    struct Input {

    }
    
    struct Output {

    }
    
    init() {

    }
}
