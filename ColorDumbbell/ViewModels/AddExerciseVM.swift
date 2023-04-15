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
    var exercise: Exercise?
    var exerciseDelegate: ExerciseDelegate?
    var section: Int!
    var row: Int!
    var totalExerciseArray: [[Exercise]] = ExerciseManager.shared.totalExerciseArray
    
    // Constants
    let MINIMUM_LENGTH: Int = 2
    let MAXIMUM_LENGTH: Int = 6
    let exerciseAreaArray: [ExerciseArea] = [.back, .chest, .shoulder, .leg, .arm, .abs]
    let DUPLICATION_TEXT: String = "해당 운동은 이미 존재하는 운동입니다."
    
    struct Input {
        var exerciseName = BehaviorSubject<String>(value: "")
    }
    
    struct Output {
        var saveButtonValidation = PublishSubject<Bool>()
        var isDuplicateExerciseName = PublishSubject<Bool>()
    }
    
    init() {
        input.exerciseName.subscribe(onNext: { exerciseName in
            self.output.saveButtonValidation.onNext(self.validateSaveButton(exerciseName: exerciseName))
            self.output.isDuplicateExerciseName.onNext(self.isDuplicateExerciseName(exerciseName: exerciseName))
        })
        .disposed(by: disposeBag)
    }
    
    private func validateSaveButton(exerciseName: String) -> Bool {
        if exerciseName.count >= 1 && !isDuplicateExerciseName(exerciseName: exerciseName){
            return true
        }
        return false
    }
    
    private func isDuplicateExerciseName(exerciseName: String) -> Bool {
        let trimmedArray = totalExerciseArray.map { $0.map { $0.name.replacingOccurrences(of: " ", with: "") } }
        let trimmedExerciseName = exerciseName.replacingOccurrences(of: " ", with: "")
        
        return trimmedArray.flatMap({ $0 }).contains(where: { $0 == trimmedExerciseName })
    }
}
