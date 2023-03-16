//
//  ExerciseAddCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/13.
//

import UIKit
import RxSwift

class ExerciseAddCell: UITableViewCell {
    // UIStackView
    @IBOutlet weak var containerStackView: UIStackView!
    
    // UILabel
    @IBOutlet weak var titleLabel: UILabel!
    
    // NSLayoutConstraint
    @IBOutlet weak var topConst: NSLayoutConstraint!
    
    // RxSwift
    var disposeBag = DisposeBag()
    
    // Constants
    let STACK_VIEW_CORNER_RADIUS: CGFloat = 7
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    private func initUI() {
        // UIStackView
        containerStackView.layer.cornerRadius = STACK_VIEW_CORNER_RADIUS
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    func setData(title: String) {
        titleLabel.text = title
    }
}
