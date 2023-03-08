//
//  ExerciseTimeVM.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/08.
//

import Foundation
import RxSwift

class ExerciseTimeVM {
    // Input
    var input = Input()
    
    // Output
    var output = Output()
    
    // Variable
    var editorMode: EditorMode = .new
    var userName: String?
    var exerciseTime: Date?
    
    // Constants
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    init() {

    }
}
