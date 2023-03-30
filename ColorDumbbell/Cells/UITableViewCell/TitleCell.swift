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
    
    // NSLayoutConstraint
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    
    // Variable
    var disposeBag = DisposeBag()
    var textFieldPlaceHolder = "제목"
    
    // Constants
    let ROUTINE_TEXT_FIELD_PLACE_HOLDER: String = "루틴 이름"
    let MEMO_TEXT_FIELD_PLACE_HOLDER: String = "메모"
    let TEXT_FIELD_FONT_SIZE: CGFloat = 17
    let STACK_VIEW_CORNER_RADIUS: CGFloat = 7
    let BOTTOM_CONSTRAINT: CGFloat = 36
    
    
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
    
    func configureTextField() {
        titleTextField.font = FontManager.shared.getPretendardRegular(fontSize: TEXT_FIELD_FONT_SIZE)
        titleTextField.attributedPlaceholder = NSAttributedString(string: textFieldPlaceHolder, attributes: [NSAttributedString.Key.foregroundColor : ColorManager.shared.getSilverSand()])
        titleTextField.addLeftPadding()
    }
    
    func setData(title: String) {
        titleTextField.text = title
    }
}
