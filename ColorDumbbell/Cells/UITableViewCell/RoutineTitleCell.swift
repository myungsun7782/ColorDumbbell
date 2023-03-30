//
//  RoutineTitleCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/29.
//

import UIKit
import RxSwift

class RoutineTitleCell: UITableViewCell {
    // UILabel
    @IBOutlet weak var nameLabel: UILabel!
    
    // UIButton
    @IBOutlet weak var deleteButton: UIButton!
    
    // NSLayoutConstraint
    @IBOutlet weak var topConst: NSLayoutConstraint!
    
    // Variables
    var disposeBag = DisposeBag()
    
    // Constants
    let PARTIAL_TOP_CONST: CGFloat = 36
    let BUTTON_IMAGE: UIImage? = UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func initUI() {
        // UIButton
        deleteButton.setImage(BUTTON_IMAGE, for: .normal)
    }
    
    func setData(name: String, index: Int) {
        nameLabel.text = name
        if index == 0 {
            topConst.constant = PARTIAL_TOP_CONST
        }
    }
}
