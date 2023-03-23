//
//  TitleCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/11.
//

import UIKit
import RxSwift

class TitleCell: UITableViewCell {
    // UITextField
    @IBOutlet weak var titleTextField: UITextField!
    
    // UIStackView
    @IBOutlet weak var containerStackView: UIStackView!
    
    // Variable
    var disposeBag = DisposeBag()
    
    // Constants
    let TEXT_FIELD_PLACE_HOLDER: String = "제목"
    let TEXT_FIELD_FONT_SIZE: CGFloat = 17
    let STACK_VIEW_CORNER_RADIUS: CGFloat = 7
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func initUI() {
        // UIStackView
        containerStackView.layer.cornerRadius = STACK_VIEW_CORNER_RADIUS
        
        // UITextField
        configureTextField()
    }
    
    private func configureTextField() {
        titleTextField.font = FontManager.shared.getPretendardRegular(fontSize: TEXT_FIELD_FONT_SIZE)
        titleTextField.attributedPlaceholder = NSAttributedString(string: TEXT_FIELD_PLACE_HOLDER, attributes: [NSAttributedString.Key.foregroundColor : ColorManager.shared.getSilverSand()])
        titleTextField.addLeftPadding()
    }
}
