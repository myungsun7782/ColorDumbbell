//
//  ExerciseTitleCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/13.
//

import UIKit
import RxSwift

class ExerciseTitleCell: UITableViewCell {
    // UIStackView
    @IBOutlet weak var containerStackView: UIStackView!
    
    // UILabel
    @IBOutlet weak var titleLabel: UILabel!
    
    // UIButton
    @IBOutlet weak var editButton: UIButton!
    
    // NSLayoutConstraint
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var leadingConst: NSLayoutConstraint!
    @IBOutlet weak var trailingConst: NSLayoutConstraint!
    
    // RxSwift
    var disposeBag = DisposeBag()
    
    // Variable
    var index: Int?
    
    // Constants
    let STACK_VIEW_BORDER_RADIUS: CGFloat = 7
    let BUTTON_FONT_SIZE: CGFloat = 16
    let LABEL_FONT_SIZE: CGFloat = 17
    let TOP_CONST: CGFloat = 11
    let FINISH_TEXT = "완료"
    let EDIT_TEXT = "편집"
    let BACK_TEXT = "등 (Back)"
    let CHEST_TEXT = "가슴 (Chest)"
    let SHOULDER_TEXT = "어깨 (Shoulder)"
    let LEG_TEXT = "하체 (Leg)"
    let ARM_TEXT = "팔 (Arm)"
    let ABS_TEXT = "복근 (Abs)"
    let BUTTON_IMAGE: UIImage? = UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14))
    let LEADING_CONST: CGFloat = 8
    let TRAILING_CONST: CGFloat = 8
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func setNeedsLayout() {
        if index != nil {
            containerStackView.layer.cornerRadius = .zero
            containerStackView.roundCorners(corners: [.topLeft, .topRight], radius: STACK_VIEW_BORDER_RADIUS)
            self.layoutIfNeeded()
        }
    }
    
    private func initUI() {
        // UIButton
        configureButton()
    }
    
    private func configureButton() {
        editButton.titleLabel?.font = FontManager.shared.getPretendardRegular(fontSize: BUTTON_FONT_SIZE)
    
    }
    
    func setData(index: Int, isEditorModeOn: Bool) {
        self.index = index
        editButton.titleLabel?.text = isEditorModeOn ? FINISH_TEXT : EDIT_TEXT
        if isEditorModeOn {
            editButton.setTitle(FINISH_TEXT, for: .normal)
        } else {
            editButton.setTitle(EDIT_TEXT, for: .normal)
        }
        
        if index != 0 {
            topConst.constant = TOP_CONST
        } else {
            topConst.constant = .zero
        }
        
        switch index {
        case 0:
            titleLabel.text = BACK_TEXT
        case 1:
            titleLabel.text = CHEST_TEXT
        case 2:
            titleLabel.text = SHOULDER_TEXT
        case 3:
            titleLabel.text = LEG_TEXT
        case 4:
            titleLabel.text = ARM_TEXT
        case 5:
            titleLabel.text = ABS_TEXT
        default:
            break
        }
    }
    
    func setData(index: Int, exercise: Exercise) {
        self.index = index
        if index != 0 {
            topConst.constant = TOP_CONST
        } else {
            topConst.constant = 18
        }
        
        titleLabel.font = FontManager.shared.getPretendardBold(fontSize: BUTTON_FONT_SIZE)
        titleLabel.text = exercise.name + " (\(exercise.area))"
        editButton.setTitle("", for: .normal)
        editButton.setImage(BUTTON_IMAGE, for: .normal)
    }
    
    func setData(isHidden: Bool, exercise: Exercise) {
        editButton.isHidden = isHidden
        titleLabel.font = FontManager.shared.getPretendardBold(fontSize: LABEL_FONT_SIZE)
        titleLabel.text = exercise.name + " (\(exercise.area))"
        leadingConst.constant = LEADING_CONST
        trailingConst.constant = TRAILING_CONST
    }
}
