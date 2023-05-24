//
//  DumbbellCriteriaVM.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/04/18.
//

import Foundation
import RxSwift

class DumbbellCriteriaVM {
    // Input
    var input = Input()
    
    // Output
    var output = Output()
    
    // Variable
    
    // Constants
    let levelArray: [Level] = [.pink, .yellow, .orange, .green, .purple, .blue, .brown, .red, .gray, .black]
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    init() {

    }
}
