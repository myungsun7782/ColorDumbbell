//
//  ExerciseSelectionVM.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/13.
//

import Foundation
import RxSwift

class ExerciseSelectionVM {
    // Input
    var input = Input()
    
    // Output
    var output = Output()
    
    // Variable
    var exerciseArray: [Exercise] = Array<Exercise>()
    var totalExerciseArray: [[Exercise]] = [[], [], [], [], [], []]
    var isEditorModeOn: Bool = false
    var isClicked: Bool = false
    var exerciseDelegate: ExerciseDelegate?
    
    // Constants
    let EXERCISE_AREA_ARRAY: [ExerciseArea] = [.back, .chest, .shoulder, .leg, .arm, .abs]
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    init() {
        setDefaultExerciseData()
    }
    
    // MARK: - ExerciseManager 클래스 만들어서 사용자가 초기 설정 끝나면 기본 운동 값으로 넣어주기(Cloud Firestore에도 저장되어야 함)
    func setDefaultExerciseData() {
        // 등
        exerciseArray.append(Exercise(name: "데드 리프트", area: ExerciseArea.back.rawValue, quantity: [ExerciseQuantity]()))
        exerciseArray.append(Exercise(name: "덤벨 로우", area: ExerciseArea.back.rawValue, quantity: [ExerciseQuantity]()))
        exerciseArray.append(Exercise(name: "렛 풀 다운", area: ExerciseArea.back.rawValue, quantity: [ExerciseQuantity]()))
        
        // 가슴
        exerciseArray.append(Exercise(name: "벤치 프레스", area: ExerciseArea.chest.rawValue, quantity: [ExerciseQuantity]()))
        exerciseArray.append(Exercise(name: "인클라인 벤치 프레스", area: ExerciseArea.chest.rawValue, quantity: [ExerciseQuantity]()))
        exerciseArray.append(Exercise(name: "덤벨 플라이", area: ExerciseArea.chest.rawValue, quantity: [ExerciseQuantity]()))
        
        // 어깨
        exerciseArray.append(Exercise(name: "오버 헤드 프레스", area: ExerciseArea.shoulder.rawValue, quantity: [ExerciseQuantity]()))
        exerciseArray.append(Exercise(name: "사이드 레터럴 레이즈", area: ExerciseArea.shoulder.rawValue, quantity: [ExerciseQuantity]()))
        exerciseArray.append(Exercise(name: "밀리터리 프레스", area: ExerciseArea.shoulder.rawValue, quantity: [ExerciseQuantity]()))
        
        // 하체
        exerciseArray.append(Exercise(name: "스쿼트", area: ExerciseArea.leg.rawValue, quantity: [ExerciseQuantity]()))
        exerciseArray.append(Exercise(name: "레그 프레스", area: ExerciseArea.leg.rawValue, quantity: [ExerciseQuantity]()))
        exerciseArray.append(Exercise(name: "레그 익스텐션", area: ExerciseArea.leg.rawValue, quantity: [ExerciseQuantity]()))
        
        // 팔
        exerciseArray.append(Exercise(name: "덤벨 컬", area: ExerciseArea.arm.rawValue, quantity: [ExerciseQuantity]()))
        exerciseArray.append(Exercise(name: "케이블 푸쉬 다운", area: ExerciseArea.arm.rawValue, quantity: [ExerciseQuantity]()))
        exerciseArray.append(Exercise(name: "덤벨 킥백", area: ExerciseArea.arm.rawValue, quantity: [ExerciseQuantity]()))
        
        // 복근
        exerciseArray.append(Exercise(name: "크런치", area: ExerciseArea.abs.rawValue, quantity: [ExerciseQuantity]()))
        exerciseArray.append(Exercise(name: "행잉 레그레이즈", area: ExerciseArea.abs.rawValue, quantity: [ExerciseQuantity]()))
        exerciseArray.append(Exercise(name: "싯 업", area: ExerciseArea.abs.rawValue, quantity: [ExerciseQuantity]()))
        
        setSpecificExercise()
    }
    
    func getSpecificExercise(exerciseArea: ExerciseArea, exericseArray: [Exercise]) -> [Exercise] {
        var specificExerciseArray = Array<Exercise>()
        
        for exercise in exericseArray {
            if exercise.area == exerciseArea.rawValue {
                specificExerciseArray.append(exercise)
            }
        }
        
        return specificExerciseArray
    }
    
    func setSpecificExercise() {
        totalExerciseArray[0].append(contentsOf: getSpecificExercise(exerciseArea: EXERCISE_AREA_ARRAY[0], exericseArray: exerciseArray))
        totalExerciseArray[1].append(contentsOf: getSpecificExercise(exerciseArea: EXERCISE_AREA_ARRAY[1], exericseArray: exerciseArray))
        totalExerciseArray[2].append(contentsOf: getSpecificExercise(exerciseArea: EXERCISE_AREA_ARRAY[2], exericseArray: exerciseArray))
        totalExerciseArray[3].append(contentsOf: getSpecificExercise(exerciseArea: EXERCISE_AREA_ARRAY[3], exericseArray: exerciseArray))
        totalExerciseArray[4].append(contentsOf: getSpecificExercise(exerciseArea: EXERCISE_AREA_ARRAY[4], exericseArray: exerciseArray))
        totalExerciseArray[5].append(contentsOf: getSpecificExercise(exerciseArea: EXERCISE_AREA_ARRAY[5], exericseArray: exerciseArray))
    }
    
    func validateFinishButton() -> Bool {
        for exerciseArray in totalExerciseArray {
            for exercise in exerciseArray {
                if exercise.isChecked {
                    return true
                }
            }
        }
        return false
    }
    
    func getSelectedExercises(totalExerciseArray: [[Exercise]]) -> [Exercise] {
        var exerciseArray: [Exercise] = Array<Exercise>()
        
        for exerciseArr in totalExerciseArray {
            for exercise in exerciseArr {
                if exercise.isChecked == true {
                    exerciseArray.append(exercise)
                }
            }
        }
        
        return exerciseArray
    }
}
