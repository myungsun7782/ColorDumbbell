//
//  CustomNavigationController.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/04/05.
//

import UIKit

class CustomNavigationController: UINavigationController {
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
