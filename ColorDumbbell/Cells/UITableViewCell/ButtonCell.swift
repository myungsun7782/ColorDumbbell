//
//  ButtonCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/30.
//

import UIKit
import RxSwift

class ButtonCell: UITableViewCell {
    // UIButton
    @IBOutlet weak var deleteButton: UIButton!
    
    // RxSwift
    var disposeBag = DisposeBag()
    
    // Constants
    let BUTTON_CORNER_RADIUS: CGFloat = 4
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func initUI() {
        deleteButton.layer.cornerRadius = BUTTON_CORNER_RADIUS
    }
}
