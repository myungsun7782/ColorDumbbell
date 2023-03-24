//
//  DetailJournalSetCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/24.
//

import UIKit
import SnapKit

class DetailJournalSetCell: UITableViewCell {
    // NSConstraintLayout
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    
    // UIView
    @IBOutlet weak var pointView: UIView!
    
    // UILabel
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    
    // Constants
    let TOP_CONSTRAINT: CGFloat = 16
    let BOTTOM_CONSTARINT: CGFloat = 30
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setData(index: Int, lastIndex: Int, currentLevelColor: UIColor, set: Int, weight: Double, reps: Int) {
        pointView.backgroundColor = currentLevelColor
        setLabel.text = "\(set)세트"
        weightLabel.text = "\(weight)"
        repsLabel.text = "\(reps)"
        pointView.layer.cornerRadius = 7.5
        if index == lastIndex {
            bottomConst.constant = BOTTOM_CONSTARINT
        }
        
        if index == 0 {
            topConst.constant = TOP_CONSTRAINT
        }
    }
}
