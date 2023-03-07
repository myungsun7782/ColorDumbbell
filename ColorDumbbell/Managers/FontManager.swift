//
//  FontManager.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/07.
//

import UIKit

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func getPretendardBold(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Bold", size: fontSize)!
    }
    
    func getPretendardExtraBold(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-ExtraBold", size: fontSize)!
    }
    
    func getPretendardExtraLight(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-ExtraLight", size: fontSize)!
    }
    
    func getPretendardLight(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Light", size: fontSize)!
    }
    
    func getPretendardMedium(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Medium", size: fontSize)!
    }
    
    func getPretendardRegular(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Regular", size: fontSize)!
    }
    
    func getPretendardSemiBold(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-SemiBold", size: fontSize)!
    }
    
    func getPretendardThin(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Thin", size: fontSize)!
    }
}
