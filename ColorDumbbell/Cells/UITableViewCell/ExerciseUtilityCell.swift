//
//  ExerciseUtilityCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/16.
//

import UIKit
import RxSwift

class ExerciseUtilityCell: UITableViewCell {
    // UIStackView
    @IBOutlet weak var containerStackView: UIStackView!
    
    // UIButton
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    // RxSwift
    var disposeBag = DisposeBag()
    
    // Variables
    var index: Int?
    
    // Constants
    let STACK_VIEW_BORDER_RADIUS: CGFloat = 7
    let BUTTON_CORNER_RADIUS: CGFloat = 5
    let BUTTON_BORDER_WIDTH: CGFloat = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureButton()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func setNeedsLayout() {
        if index != nil {
            containerStackView.layer.cornerRadius = .zero
            containerStackView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: STACK_VIEW_BORDER_RADIUS)
            self.layoutIfNeeded()
        }
    }
    
    private func configureButton() {
        addButton.layer.cornerRadius = BUTTON_CORNER_RADIUS
        addButton.layer.borderWidth = BUTTON_BORDER_WIDTH
        addButton.layer.borderColor = ColorManager.shared.getBrightGray().cgColor
        
        deleteButton.layer.cornerRadius = BUTTON_CORNER_RADIUS
        deleteButton.layer.borderWidth = BUTTON_BORDER_WIDTH
        deleteButton.layer.borderColor = ColorManager.shared.getBrightGray().cgColor
    }
    
    func setData(index: Int) {
        self.index = index
    }
}
