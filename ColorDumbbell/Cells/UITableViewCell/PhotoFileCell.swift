//
//  PhotoFileCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/12.
//

import UIKit
import RxSwift

class PhotoFileCell: UITableViewCell {
    // UIStackView
    @IBOutlet weak var containerStackView: UIStackView!
    
    // UILabel
    @IBOutlet weak var photoIdLabel: UILabel!
    
    // NSLayoutConstarint
    @IBOutlet weak var topConst: NSLayoutConstraint!
    
    // Variables
    var index: Int?
    
    // RxSwift
    var disposeBag = DisposeBag()
    
    // Constants
    let CORNER_RADIUS: CGFloat = 7
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
  
    
    override func setNeedsLayout() {
        if let index = index {
            if index == 0 {
                containerStackView.layer.cornerRadius = 0
                containerStackView.roundCorners(corners: [.topLeft, .topRight], radius: CORNER_RADIUS)
            } else {
                containerStackView.roundCorners(corners: .allCorners, radius: 0)
            }
            self.layoutIfNeeded()
        }
    }
    
    func setData(index: Int, photoId: String) {
        self.index = index
        topConst.constant = index == 0 ? 18 : 0
        containerStackView.layer.cornerRadius = 0
        photoIdLabel.text = photoId
    }
}
