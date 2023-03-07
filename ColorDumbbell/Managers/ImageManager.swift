//
//  ImageManager.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/07.
//

import UIKit

// Add ImageName
enum ImageName: String {
    case SPLASH_IMAGE = "SplashImage"
}

class ImageManager {
    static let shared = ImageManager()
    
    private init() {}
    
    func getImage(_ imageName: ImageName) -> UIImage {
        return UIImage(named: imageName.rawValue)!
    }
}
