//
//  UIImageView.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/07.
//

import Foundation
import FirebaseStorage
import FirebaseStorageUI

extension UIImageView {
    func fetchImage(photoId: String) {
        let ref = Storage.storage().reference().child(photoId)
        self.sd_setImage(with: ref)
    }
}
