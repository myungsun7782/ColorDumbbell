//
//  UIView.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/07.
//

import UIKit

extension UIView {
    func makeViewGradient(view: UIView, colorArray: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        let colors: [CGColor] = colorArray
        let START_POINT_X: CGFloat = 0.0
        let START_POINT_Y: CGFloat = 0.0
        let END_POINT_X: CGFloat = 1.0
        let END_POINT_Y: CGFloat = 1.0
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: START_POINT_X, y: START_POINT_Y)
        gradientLayer.endPoint = CGPoint(x: END_POINT_X, y: END_POINT_Y)
        gradientLayer.cornerRadius = view.frame.width / 2
        
        view.layer.addSublayer(gradientLayer)
        view.layer.cornerRadius = view.frame.height / 2
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

