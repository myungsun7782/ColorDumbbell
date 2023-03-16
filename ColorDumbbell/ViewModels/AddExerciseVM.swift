//
//  AddExerciseVM.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/16.
//

import Foundation
import RxSwift

class AddExerciseVM {
    // Input
    var input = Input()
    
    // Output
    var output = Output()
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    // Variable
    var editorMode: EditorMode = .new
    var exerciseName: String?
    var exerciseDelegate: ExerciseDelegate?
    var section: Int!
    var row: Int!
    
    // Constants
    let MINIMUM_LENGTH: Int = 2
    let MAXIMUM_LENGTH: Int = 6
    
    struct Input {
        var exerciseName = BehaviorSubject<String>(value: "")
    }
    
    struct Output {
        var saveButtonValidation = PublishSubject<Bool>()
    }
    
    init() {
        input.exerciseName.subscribe(onNext: { exerciseName in
            self.output.saveButtonValidation.onNext(self.validateSaveButton(exerciseName: exerciseName))
        })
        .disposed(by: disposeBag)
    }
    
    private func validateSaveButton(exerciseName: String) -> Bool {
        if exerciseName.count >= 1 {
            return true
        }
        return false
    }

}
