//
//  GradientProgressView.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/04/15.
//

import UIKit

class GradientProgressView: UIProgressView {
    @IBInspectable var firstColor: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.black {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let gradientImage = UIImage(bounds: self.bounds, colors: [firstColor, secondColor]) {
            self.progressImage = gradientImage
        }
    }
}
