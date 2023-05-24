//
//  DumbbellCriteriaCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/04/18.
//

import UIKit

class DumbbellCriteriaCell: UITableViewCell {
    // UIImageView
    @IBOutlet weak var dumbbellImageView: UIImageView!
    
    // UILabel
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var criteriaLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(level: Level) {
        let levelTuple = LevelManager.shared.getLevelTuple(level: level)
        let imageString = "Image"
        
        dumbbellImageView.image = UIImage(named: level.rawValue + imageString)
        
        colorLabel.text = level.rawValue.uppercased()
        colorLabel.textColor = levelTuple.1
        
        criteriaLabel.text = "\(levelTuple.0.lowerBound) - \(levelTuple.0.upperBound)회 일지 작성"
    }
}
