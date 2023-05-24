//
//  RoutineContentCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/29.
//

import UIKit
import RxSwift

class RoutineContentCell: UITableViewCell {
    // UIStackView
    @IBOutlet weak var containerStackView: UIStackView!
    
    // UIView
    @IBOutlet weak var pointView: UIView!
    
    // UILabel
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var exerciseSetLabel: UILabel!
    
    // NSLayoutConstraint
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    
    // RxSwift
    var disposeBag = DisposeBag()
    
    // Constants
    let VIEW_CORNER_RADIUS: CGFloat = 2
    let PARTIAL_TOP_CONST: CGFloat = 13
    let PARTIAL_BOTTOM_CONST: CGFloat = 36
    let ORIGINAL_CONST: CGFloat = 6
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func initUI() {
        // UIView
        pointView.layer.cornerRadius = VIEW_CORNER_RADIUS
        pointView.backgroundColor = LevelManager.shared.getCurrentLevelColor(exerciseTotalCount: UserDefaultsManager.shared.getExerciseTotalCount())
    }
    
    func setData(currentLevelColor: UIColor, exerciseName: String, exerciseSet: Int, index: Int, lastIndex: Int) {
        pointView.backgroundColor = currentLevelColor
        exerciseNameLabel.text = exerciseName
        exerciseSetLabel.text = "\(exerciseSet)세트"
        if index == .zero {
            topConst.constant = PARTIAL_TOP_CONST
            bottomConst.constant = ORIGINAL_CONST
        } else if index == lastIndex {
            topConst.constant = ORIGINAL_CONST
            bottomConst.constant = PARTIAL_BOTTOM_CONST
        } else {
            topConst.constant = ORIGINAL_CONST
            bottomConst.constant = ORIGINAL_CONST
        }
    }
}
