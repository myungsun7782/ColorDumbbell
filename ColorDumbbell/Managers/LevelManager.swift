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
    private let BLACK_INTERVAL = 109...3652
    private let PINK_MAX = 4
    private let YELLOW_MAX = 10
    private let ORANGE_MAX = 18
    private let GREEN_MAX = 28
    private let PURPLE_MAX = 40
    private let BLUE_MAX = 54
    private let BROWN_MAX = 70
    private let RED_MAX = 88
    private let GRAY_MAX = 108
    private let BLACK_MAX = 3652
    
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
        case BLACK_INTERVAL:
            return ColorManager.shared.getBlack()
        default:
            return ColorManager.shared.getBlack()
        }
    }
    
    func getCurrentLevel(exerciseTotalCount: Int) -> Level {
        switch exerciseTotalCount {
        case PINK_INTERVAL:
            return Level.pink
        case YELLOW_INTERVAL:
            return Level.yellow
        case ORANGE_INTERVAL:
            return Level.orange
        case GREEN_INTERVAL:
            return Level.green
        case PURPLE_INTERVAL:
            return Level.purple
        case BLUE_INTERVAL:
            return Level.blue
        case BROWN_INTERVAL:
            return Level.brown
        case RED_INTERVAL:
            return Level.red
        case GRAY_INTERVAL:
            return Level.gray
        case BLACK_INTERVAL:
            return Level.black
        default:
            return Level.black
        }
    }
    
    func getLevelMaxValue(level: Level) -> Int {
        switch level {
        case .pink:
            return PINK_MAX
        case .yellow:
            return YELLOW_MAX
        case .orange:
            return ORANGE_MAX
        case .green:
            return GREEN_MAX
        case .purple:
            return PURPLE_MAX
        case .blue:
            return BLUE_MAX
        case .brown:
            return BROWN_MAX
        case .red:
            return RED_MAX
        case .gray:
            return GRAY_MAX
        case .black:
            return BLACK_MAX
        }
    }
    
    func getCurrentGradientColor(exerciseTotalCount: Int) -> [UIColor] {
        switch exerciseTotalCount {
        case PINK_INTERVAL:
            return [ColorManager.shared.getCottonCandy(), ColorManager.shared.getCyclamen()]
        case YELLOW_INTERVAL:
            return [ColorManager.shared.getCornSilk(), ColorManager.shared.getCorn()]
        case ORANGE_INTERVAL:
            return [ColorManager.shared.getPeachYellow(), ColorManager.shared.getMarigold()]
        case GREEN_INTERVAL:
            return [ColorManager.shared.getTeaGreen(), ColorManager.shared.getMalachiteGreen()]
        case PURPLE_INTERVAL:
            return [ColorManager.shared.getBrilliantLavender(), ColorManager.shared.getSteelPink()]
        case BLUE_INTERVAL:
            return [ColorManager.shared.getBlizzardBlue(), ColorManager.shared.getAero()]
        case BROWN_INTERVAL:
            return [ColorManager.shared.getPastelGray(), ColorManager.shared.getPastelBrown()]
        case RED_INTERVAL:
            return [ColorManager.shared.getLightRed(), ColorManager.shared.getLightCarminePink()]
        case GRAY_INTERVAL:
            return [ColorManager.shared.getGainsboro(), ColorManager.shared.getSilverChalice()]
        case BLACK_INTERVAL:
            return [ColorManager.shared.getSilverChalice(), ColorManager.shared.getBlack()]
        default:
            return [ColorManager.shared.getBlack(), ColorManager.shared.getGray()]
        }
    }
    
    func getCurrentDumbbellImage(exerciseTotalCount: Int) -> UIImage {
        let imageString: String = "Image"
        switch exerciseTotalCount {
        case PINK_INTERVAL:
            return UIImage(named: Level.pink.rawValue + imageString)!
        case YELLOW_INTERVAL:
            return UIImage(named: Level.yellow.rawValue + imageString)!
        case ORANGE_INTERVAL:
            return UIImage(named: Level.orange.rawValue + imageString)!
        case GREEN_INTERVAL:
            return UIImage(named: Level.green.rawValue + imageString)!
        case PURPLE_INTERVAL:
            return UIImage(named: Level.purple.rawValue + imageString)!
        case BLUE_INTERVAL:
            return UIImage(named: Level.blue.rawValue + imageString)!
        case BROWN_INTERVAL:
            return UIImage(named: Level.brown.rawValue + imageString)!
        case RED_INTERVAL:
            return UIImage(named: Level.red.rawValue + imageString)!
        case GRAY_INTERVAL:
            return UIImage(named: Level.gray.rawValue + imageString)!
        case BLACK_INTERVAL:
            return UIImage(named: Level.black.rawValue + imageString)!
        default:
            return UIImage(named: Level.black.rawValue + imageString)!
        }
    }
    
    func getLevelTuple(level: Level) -> (ClosedRange<Int>, UIColor) {
        switch level {
        case .pink:
            return (PINK_INTERVAL, ColorManager.shared.getCyclamen())
        case .yellow:
            return (YELLOW_INTERVAL, ColorManager.shared.getCorn())
        case .orange:
            return (ORANGE_INTERVAL, ColorManager.shared.getMarigold())
        case .green:
            return (GREEN_INTERVAL, ColorManager.shared.getMalachiteGreen())
        case .purple:
            return (PURPLE_INTERVAL, ColorManager.shared.getSteelPink())
        case .blue:
            return (BLUE_INTERVAL, ColorManager.shared.getAero())
        case .brown:
            return (BROWN_INTERVAL, ColorManager.shared.getPastelBrown())
        case .red:
            return (RED_INTERVAL, ColorManager.shared.getLightCarminePink())
        case .gray:
            return (GRAY_INTERVAL, ColorManager.shared.getSilverChalice())
        case .black:
            return (BLACK_INTERVAL, ColorManager.shared.getBlack())
        }
    }
}
