//
//  ExerciseSetCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/16.
//

import UIKit

class ExerciseSetCell: UITableViewCell {
    // UIStackView
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var dataStackView: UIStackView!
    
    // UILabel
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(set: Int) {
        setLabel.text = "\(set)세트"
    }
}
