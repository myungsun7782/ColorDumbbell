//
//  ExerciseContentCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/13.
//

import UIKit
import RxSwift

class ExerciseContentCell: UITableViewCell {
    // UIStackView
    @IBOutlet weak var containerStackView: UIStackView!
    
    // UIButton
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    // UILabel
    @IBOutlet weak var exerciseNameLabel: UILabel!
    
    // NSLayoutConstraint
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    
    // RxSwift
    var disposeBag = DisposeBag()
    
    // Variables
    var isEditorModeOn: Bool?
    var index: Int?
    var exerciseArray: [Exercise]?
    
    // Constants
    let BUTTON_BORDER_WIDTH: CGFloat = 1
    let STACK_VIEW_CORNER_RADIUS: CGFloat = 7
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func setNeedsLayout() {
        if let isEditorModeOn = isEditorModeOn, let index = index, let exerciseArray = exerciseArray {
            containerStackView.layer.cornerRadius = 0
            if !isEditorModeOn && index == exerciseArray.count {
                containerStackView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: STACK_VIEW_CORNER_RADIUS)
                bottomConst.constant = 11
            } else if !isEditorModeOn && index != exerciseArray.count {
                containerStackView.roundCorners(corners: [.allCorners], radius: 0)
                bottomConst.constant = 0
            } else if isEditorModeOn {
                containerStackView.roundCorners(corners: [.allCorners], radius: 0)
                bottomConst.constant = 0
            }
            self.layoutIfNeeded()
        }        
    }
    
    private func initUI() {
        // UIButton
        configureButton()
        containerStackView.layer.cornerRadius = 0
    }
    
    private func configureButton() {
        checkButton.layer.borderWidth = BUTTON_BORDER_WIDTH
        checkButton.layer.borderColor = ColorManager.shared.getArgent().cgColor
        checkButton.layer.cornerRadius = checkButton.bounds.width / 2
    }
    
    func setData(exerciseName: String, isEditorModeOn: Bool, index: Int, exerciseArray: [Exercise]) {
        self.isEditorModeOn = isEditorModeOn
        self.index = index
        self.exerciseArray = exerciseArray
        exerciseNameLabel.text = exerciseName
        deleteButton.isHidden = isEditorModeOn ? false : true
        exerciseNameLabel.textColor = isEditorModeOn ? ColorManager.shared.getBleuDeFrance() : ColorManager.shared.getBlack()
        
    }
    
    func setCheckButtonConfiguration(isClicked: Bool) {
        checkButton.layer.borderWidth = isClicked ? 0 : BUTTON_BORDER_WIDTH
        checkButton.layer.borderColor = isClicked ? ColorManager.shared.getWhite().cgColor : ColorManager.shared.getArgent().cgColor
        checkButton.backgroundColor = isClicked ? ColorManager.shared.getBlack() : ColorManager.shared.getWhite()
    }
}
