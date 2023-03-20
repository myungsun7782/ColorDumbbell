//
//  ExerciseTimeCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/11.
//

import UIKit
import RxSwift
import SwiftDate

class ExerciseTimeCell: UITableViewCell {
    // UIStackView
    @IBOutlet weak var containerStackView: UIStackView!
    
    // UIDatePicker
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    // UILabel
    @IBOutlet weak var totalExerciseTimeLabel: UILabel!
    
    // Constants
    let STACK_VIEW_CORNER_RADIUS: CGFloat = 7
    let PICKER_KEY_PATH: String = "textColor"
    
    // RxSwift
    var disposeBag = DisposeBag()
    
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
        
        // UIDatePicker
        configureDatePicker()
        
        // UILabel
        totalExerciseTimeLabel.text = "1분"
    }
    
    private func configureDatePicker() {
        if #available(iOS 13.4, *) {
            startTimePicker.overrideUserInterfaceStyle = .light
            endTimePicker.overrideUserInterfaceStyle = .light
        }
        startTimePicker.setValue(UIColor.black, forKeyPath: PICKER_KEY_PATH)
        endTimePicker.setValue(UIColor.black, forKeyPath: PICKER_KEY_PATH)
        endTimePicker.minimumDate = startTimePicker.date + 1.minutes
    }
}
