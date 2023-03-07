//
//  TimeManager.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/07.
//

import UIKit
import SwiftDate

enum TimeOption {
    case year
    case month
    case day
    case weekday
    case time
}

class TimeManager {
    static let shared = TimeManager()
    private init() {}
    
    let weekdayList = ["", "(일)", "(월)", "(화)", "(수)", "(목)", "(금)", "(토)"]
        
    func dateToString(date: Date, options: Array<TimeOption>) -> String {
        let rDate = date.convertTo(region: Region.current)
        
        var result = ""
        
        for option in options {
            switch option {
            case .year:
                result += "\(rDate.year)년 "
                
            case .month:
                result += "\(rDate.month)월 "
                
            case .day:
                result += "\(rDate.day)일"
                
            case .weekday:
                result += "\(weekdayList[rDate.weekday]) "
                
            case .time:
                let a = rDate.hour < 12 ? "오전" : "오후"
                let hourString = rDate.hour > 12 ? "\(rDate.hour-12)" : "\(rDate.hour)"
                let minString = rDate.minute < 10 ? "0\(rDate.minute)" : "\(rDate.minute)"
                
                result += "\(a) \(hourString):\(minString)"
            }
        }
        
        return result
    }
}
