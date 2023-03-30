//
//  RoutineSetCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/28.
//

import UIKit
import RxSwift

class RoutineSetCell: UITableViewCell {
    // UIStackView
    @IBOutlet weak var containerStackView: UIStackView!
    
    // UIButton
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    // UILabel
    @IBOutlet weak var setLabel: UILabel!
    
    // NSLayoutConstraint
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    
    // RxSwift
    var disposeBag = DisposeBag()
    
    // Variables
    var index: Int?
    
    // Constants
    let STACK_VIEW_CORNER_RADIUS: CGFloat = 7
    let PLUS_BUTTON_IMAGE: UIImage? = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
    let MINUS_BUTTON_IMAGE: UIImage? = UIImage(systemName: "minus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func setNeedsLayout() {
        if index != nil {
            containerStackView.layer.cornerRadius = .zero
            containerStackView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: STACK_VIEW_CORNER_RADIUS)
            self.layoutIfNeeded()
        }
    }
    
    private func initUI() {
        // UIButton
        configureButton()
    }
    
    private func configureButton() {
        plusButton.setImage(PLUS_BUTTON_IMAGE, for: .normal)
        plusButton.layer.cornerRadius = plusButton.bounds.height / 2
        
        minusButton.setImage(MINUS_BUTTON_IMAGE, for: .normal)
        minusButton.layer.cornerRadius = minusButton.bounds.height / 2
    }
    
    func setData(index: Int, exercise: Exercise) {
        self.index = index
        
        setLabel.text = "\(exercise.quantity.count)세트"
    }
}
