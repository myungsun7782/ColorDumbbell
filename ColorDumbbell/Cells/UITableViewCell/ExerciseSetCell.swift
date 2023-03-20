//
//  ExerciseSetCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/16.
//

import UIKit
import RxSwift

class ExerciseSetCell: UITableViewCell {
    // UIStackView
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var dataStackView: UIStackView!
    
    // UILabel
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var weightDescriptionLabel: UILabel!
    @IBOutlet weak var repsDescriptionLabel: UILabel!
    
    // RxSwift
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func setData(set: Int, weight: Double, reps: Int, isFocused: Bool) {
        setLabel.text = "\(set)세트"
        weightLabel.text = "\(weight)"
        repsLabel.text = "\(reps)"
        setLabel.textColor = isFocused ? ColorManager.shared.getBleuDeFrance() : ColorManager.shared.getBlack()
        weightLabel.textColor = isFocused ? ColorManager.shared.getBleuDeFrance() : ColorManager.shared.getBlack()
        weightDescriptionLabel.textColor = isFocused ? ColorManager.shared.getBleuDeFrance() : ColorManager.shared.getBlack()
        repsLabel.textColor = isFocused ? ColorManager.shared.getBleuDeFrance() : ColorManager.shared.getBlack()
        repsDescriptionLabel.textColor = isFocused ? ColorManager.shared.getBleuDeFrance() : ColorManager.shared.getBlack()
    }
}
