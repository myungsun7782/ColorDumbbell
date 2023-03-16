//
//  ExerciseUtilityCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/16.
//

import UIKit

class ExerciseUtilityCell: UITableViewCell {
    // UIStackView
    @IBOutlet weak var containerStackView: UIStackView!
    
    // UIButton
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var timerButton: UIButton!
    
    // Constants
    let STACK_VIEW_BORDER_RADIUS: CGFloat = 7
    let BUTTON_CORNER_RADIUS: CGFloat = 5
    let BUTTON_BORDER_WIDTH: CGFloat = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerStackView.layer.cornerRadius = .zero
        containerStackView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: STACK_VIEW_BORDER_RADIUS)
    }
    
    private func configureButton() {
        addButton.layer.cornerRadius = BUTTON_CORNER_RADIUS
        addButton.layer.borderWidth = BUTTON_BORDER_WIDTH
        addButton.layer.borderColor = ColorManager.shared.getBrightGray().cgColor
        
        deleteButton.layer.cornerRadius = BUTTON_CORNER_RADIUS
        deleteButton.layer.borderWidth = BUTTON_BORDER_WIDTH
        deleteButton.layer.borderColor = ColorManager.shared.getBrightGray().cgColor
        
        timerButton.layer.cornerRadius = BUTTON_CORNER_RADIUS
        timerButton.layer.borderWidth = BUTTON_BORDER_WIDTH
        timerButton.layer.borderColor = ColorManager.shared.getBrightGray().cgColor
    }
}
