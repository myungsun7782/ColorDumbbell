//
//  ExerciseDateCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/23.
//

import UIKit

class ExerciseDateCell: UITableViewCell {
    // UILabel
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    // NSLayoutConstraint
    @IBOutlet weak var topConst: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(exerciseJournal: ExerciseJournal) {
        dateLabel.text = TimeManager.shared.dateToString(date: exerciseJournal.startTime.date, options: [.month, .day, .weekday])
        timeLabel.text = "\(exerciseJournal.totalExerciseTime)분"
    }
}
