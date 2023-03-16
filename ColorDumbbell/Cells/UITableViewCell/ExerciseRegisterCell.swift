//
//  ExerciseRegisterCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/13.
//

import UIKit
import RxSwift

class ExerciseRegisterCell: UITableViewCell {
    // UIStackView
    @IBOutlet weak var containerStackView: UIStackView!
    
    // RxSwift
    var disposeBag = DisposeBag()

    // Variables
    var isEditorModeOn: Bool?
    
    // Constants
    let STACK_VIEW_CORNER_RADIUS: CGFloat = 7
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
        
    override func setNeedsLayout() {
        if isEditorModeOn != nil {
            containerStackView.layer.cornerRadius = 0
            containerStackView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: STACK_VIEW_CORNER_RADIUS)
            self.layoutIfNeeded()
        }
    }
    func setData(isEditorModeOn: Bool) {
        self.isEditorModeOn = isEditorModeOn
    }
}
