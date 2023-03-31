//
//  ViewController.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/06.
//

import UIKit
import RxSwift
import RxCocoa

class MainVC: UIViewController {
    // ViewModel
    let viewModel = MainVM()
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

