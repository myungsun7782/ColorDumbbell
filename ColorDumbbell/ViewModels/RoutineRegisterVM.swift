//
//  RoutineRegisterVM.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/28.
//

import Foundation
import RxSwift

class RoutineRegisterVM {
    // Input
    var input = Input()
    
    // Output
    var output = Output()
    
    // Variable
    var exerciseArray: [Exercise] = Array<Exercise>()
    var title: String?
    var memo: String?
    var section: Int?
    var editorMode: EditorMode = .new
    var delegate: ExerciseRoutineDelegate?
    var modifiableRoutine: Routine?
    
    // Constants
    let MAX_SET_COUNT: Int = 100
    let MIN_SET_COUNT: Int = 1
    let MAX_TITLE_LENGTH: Int = 15
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    init() {

    }
    
    func validateButton(routineRegisterVC: RoutineRegisterVC, title: String?, exerciseArray: [Exercise]) -> Bool {
        if title == nil || title!.isEmpty {
            AlertManager.shared.presentOneButtonAlert(title: "운동 루틴을 등록할 수 없음", message: "루틴 이름을 작성해주세요.") {
            } completionHandler: { alert in
                routineRegisterVC.present(alert, animated: true, completion: nil)
            }
            
            return false
        } else if exerciseArray.isEmpty {
            AlertManager.shared.presentOneButtonAlert(title: "운동 루틴을 등록할 수 없음", message: "운동을 추가한 뒤 등록해주세요.") {
            } completionHandler: { alert in
                routineRegisterVC.present(alert, animated: true, completion: nil)
            }
            
            return false
        } 
        return true
    }
}
