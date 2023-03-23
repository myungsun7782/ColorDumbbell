//
//  ExerciseCalendarCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/22.
//

import UIKit
import RxSwift

class ExerciseCalendarCell: UITableViewCell {
    // UIStackView
    @IBOutlet weak var containerStackView: UIStackView!
    
    // UIView
    @IBOutlet weak var pointView: UIView!
    
    // UILabel
    @IBOutlet weak var exerciseAreaLabel: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    
    // NSLayoutConstraint
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    
    // RxSwift
    var disposeBag = DisposeBag()
    
    // Constants
    let VIEW_CORNER_RADIUS: CGFloat = 2
    let LAST_CELL_BOTTOM_CONSTRAINT: CGFloat = 18
    
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
    }
    
    func setData(currentLevelColor: UIColor, exerciseArray: [Exercise]) {
        pointView.backgroundColor = currentLevelColor
        setExerciseAreaLabel(exerciseArray: exerciseArray)
        setExerciseLabel(exerciseArray: exerciseArray)
    }
    
    func setData(index: Int, lastIndex: Int, currentLevelColor: UIColor, exerciseArray: [Exercise]) {
        pointView.backgroundColor = currentLevelColor
        setExerciseAreaLabel(exerciseArray: exerciseArray)
        setExerciseLabel(exerciseArray: exerciseArray)
        if index == lastIndex {
            bottomConst.constant = LAST_CELL_BOTTOM_CONSTRAINT
        }
    }
    
    private func setExerciseAreaLabel(exerciseArray: [Exercise]) {
        switch exerciseArray[0].area {
        case ExerciseArea.back.rawValue:
            exerciseAreaLabel.text = "등"
        case ExerciseArea.chest.rawValue:
            exerciseAreaLabel.text = "가슴"
        case ExerciseArea.shoulder.rawValue:
            exerciseAreaLabel.text = "어깨"
        case ExerciseArea.leg.rawValue:
            exerciseAreaLabel.text = "하체"
        case ExerciseArea.arm.rawValue:
            exerciseAreaLabel.text = "팔"
        case ExerciseArea.abs.rawValue:
            exerciseAreaLabel.text = "복근"
        default:
            break
        }
    }
    
    private func setExerciseLabel(exerciseArray: [Exercise]) {
        var exerciseListString = ""
        for (idx, exercise) in exerciseArray.enumerated() {
            if idx == exerciseArray.count - 1 {
                exerciseListString += exercise.name
            } else {
                exerciseListString += exercise.name + ", "
            }
        }
        exerciseLabel.text = exerciseListString
    }
}
