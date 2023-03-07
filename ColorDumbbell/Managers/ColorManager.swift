//
//  ColorManager.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/07.
//

import UIKit

class ColorManager {
    static let shared = ColorManager()
    
    private init() {}
    
    func getWhite() -> UIColor {
        return UIColor(named: "White")!
    }
    
    func getAntiFlashWhite() -> UIColor {
        return UIColor(named: "AntiFlashWhite")!
    }
    
    func getBleuDeFrance() -> UIColor {
        return UIColor(named: "BleuDeFrance")!
    }
    
    func getCarminePink() -> UIColor {
        return UIColor(named: "CarminePink")!
    }
    
    func getDarkGray() -> UIColor {
        return UIColor(named: "DarkGray")!
    }
    
    func getLightSilver() -> UIColor {
        return UIColor(named: "LightSilver")!
    }
    
    func getOldSilver() -> UIColor {
        return UIColor(named: "OldSilver")!
    }
    
    func getArgent() -> UIColor {
        return UIColor(named: "Argent")!
    }
}

