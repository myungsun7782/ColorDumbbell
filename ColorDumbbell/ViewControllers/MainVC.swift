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
    // UIStatusBarStyle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent 
    }
    
    // ViewModel
    let viewModel = MainVM()
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

