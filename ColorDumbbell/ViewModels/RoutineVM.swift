//
//  RoutineVM.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/28.
//

import Foundation
import RxSwift

class RoutineVM {
    // Input
    var input = Input()
    
    // Output
    var output = Output()
    
    // Variable
    var routineArray: [Routine] = Array<Routine>()
    
    // Constants
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        var fetchDataDone = PublishSubject<Void>()
    }
    
    init() {

    }
    
    func fetchRoutines() {
        LoadingManager.shared.showLoading()
        FirebaseManager.shared.fetchRotines { routineArray, isSuccess in
            if isSuccess {
                self.routineArray = routineArray!
                self.output.fetchDataDone.onNext(())
            } else {
                LoadingManager.shared.hideLoading()
            }
        }
    }
}
