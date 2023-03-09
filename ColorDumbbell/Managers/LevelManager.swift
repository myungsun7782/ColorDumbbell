//
//  LevelManager.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/09.
//

import UIKit

class LevelManager {
    static let shared = LevelManager()
    private let PINK_INTERVAL = 0...4
    private let YELLOW_INTERVAL = 5...10
    private let ORANGE_INTERVAL = 11...18
    private let GREEN_INTERVAL = 19...28
    private let PURPLE_INTERVAL = 29...40
    private let BLUE_INTERVAL = 41...54
    private let BROWN_INTERVAL = 55...70
    private let RED_INTERVAL = 71...88
    private let GRAY_INTERVAL = 89...108
    
    private init() {}
    
    func getCurrentLevelColor(exerciseTotalCount: Int) -> UIColor {
        switch exerciseTotalCount {
        case PINK_INTERVAL:
            return ColorManager.shared.getCyclamen()
        case YELLOW_INTERVAL:
            return ColorManager.shared.getCorn()
        case ORANGE_INTERVAL:
            return ColorManager.shared.getMarigold()
        case GREEN_INTERVAL:
            return ColorManager.shared.getMalachiteGreen()
        case PURPLE_INTERVAL:
            return ColorManager.shared.getSteelPink()
        case BLUE_INTERVAL:
            return ColorManager.shared.getAero()
        case BROWN_INTERVAL:
            return ColorManager.shared.getPastelBrown()
        case RED_INTERVAL:
            return ColorManager.shared.getLightCarminePink()
        case GRAY_INTERVAL:
            return ColorManager.shared.getSilverChalice()
        default:
            return ColorManager.shared.getBlack()
        }
    }
}
