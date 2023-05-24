//
//  MyPageVM.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/04/16.
//

import Foundation
import RxSwift
import SwiftDate

class MyPageVM {
    // Input
    var input = Input()
    
    // Output
    var output = Output()
    
    // Variable
    var currentMonthCount: Int?
    var totalExerciseCount: Int?
    var mainVC: MainVC?
    
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
