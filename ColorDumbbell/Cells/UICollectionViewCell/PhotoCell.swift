//
//  PhotoCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/24.
//

import UIKit
import RxSwift

class PhotoCell: UICollectionViewCell {
    // UIImageView
    @IBOutlet weak var photoImageView: UIImageView!
    
    // RxSwift
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
