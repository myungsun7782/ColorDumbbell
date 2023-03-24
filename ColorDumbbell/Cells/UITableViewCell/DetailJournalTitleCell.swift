//
//  DetailJournalTitleCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/24.
//

import UIKit
import RxSwift

class DetailJournalTitleCell: UITableViewCell {
    // UILabel
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var exerciseDateLabel: UILabel!
    @IBOutlet weak var exerciseTimeLabel: UILabel!
    
    // RxSwift
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func setData(exerciseJournal: ExerciseJournal) {
        titleLabel.text = exerciseJournal.title
        exerciseDateLabel.text = TimeManager.shared.dateToString(date: exerciseJournal.startTime.date, options: [.year, .month, .day, .weekday])
        exerciseTimeLabel.text = TimeManager.shared.dateToString(date: exerciseJournal.startTime.date, options: [.time]) + " - " + TimeManager.shared.dateToString(date: exerciseJournal.endTime.date, options: [.time])
    }
}
