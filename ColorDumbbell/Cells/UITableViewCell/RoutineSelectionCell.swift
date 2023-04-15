//
//  RoutineSelectionCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/04/06.
//

import UIKit
import RxSwift

class RoutineSelectionCell: UITableViewCell {
    // UIStackView
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var lineStackView: UIStackView!
    
    // UILabel
    @IBOutlet weak var nameLabel: UILabel!
    
    // NSLayoutConstraint
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    
    // RxSwift
    var disposeBag = DisposeBag()
    
    // Variables
    var isSingleData: Bool?
    var index: Int?
    var routineArray: [Routine]?
    
    // Constants
    let STACK_VIEW_CORNER_RADIUS: CGFloat = 7
    let NORMAL_CONSTARINT: CGFloat = 11
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func setNeedsLayout() {
        if let isSingleData = isSingleData, let index = index, let routineArray = routineArray {
            if isSingleData {
                containerStackView.layer.cornerRadius = STACK_VIEW_CORNER_RADIUS
            } else if !isSingleData && index != routineArray.count - 1 && index != .zero {
                containerStackView.layer.cornerRadius = .zero
            } else if !isSingleData && index == .zero {
                containerStackView.layer.cornerRadius = .zero
                containerStackView.roundCorners(corners: [.topLeft, .topRight], radius: STACK_VIEW_CORNER_RADIUS)
            }else {
                containerStackView.layer.cornerRadius = .zero
                containerStackView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: STACK_VIEW_CORNER_RADIUS)
            }
            self.layoutIfNeeded()
        }
    }
    
    func setData(index: Int, lastIndex: Int, isSingleData: Bool, name: String, routineArray: [Routine]) {
        self.isSingleData = isSingleData
        self.routineArray = routineArray
        self.index = index
        nameLabel.text = name
    
        if index == .zero && index == lastIndex {
            topConst.constant = NORMAL_CONSTARINT
            bottomConst.constant = NORMAL_CONSTARINT
            lineStackView.isHidden = true
        } else if index == .zero && index != lastIndex {
            topConst.constant = NORMAL_CONSTARINT
            bottomConst.constant = .zero
            lineStackView.isHidden = false
        } else if index != .zero && index == lastIndex {
            topConst.constant = .zero
            bottomConst.constant = NORMAL_CONSTARINT
            lineStackView.isHidden = true
        } else {
            topConst.constant = .zero
            bottomConst.constant = .zero
            lineStackView.isHidden = false
        }
    }
}
