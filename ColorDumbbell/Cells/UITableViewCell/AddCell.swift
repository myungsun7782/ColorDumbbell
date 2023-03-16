//
//  AddCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/11.
//

import UIKit
import RxSwift

class AddCell: UITableViewCell {
    // UIStackView
    @IBOutlet weak var containerStackView: UIStackView!
    
    // UILabel
    @IBOutlet weak var titleLabel: UILabel!
    
    // NSLayoutConstraint
    @IBOutlet weak var topConst: NSLayoutConstraint!

    // RxSwift
    var disposeBag = DisposeBag()
    
    // Variables
    var isEmpty: Bool?

    // Constants
    let STACK_VIEW_CORNER_RADIUS: CGFloat = 7
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let isEmpty = isEmpty {
            if isEmpty {
                containerStackView.layer.cornerRadius = 7
            } else {
                containerStackView.layer.cornerRadius = 0
                containerStackView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 7)
            }
        }
    }
    
    private func initUI() {
        // UIStackView
        containerStackView.layer.cornerRadius = STACK_VIEW_CORNER_RADIUS
    }
    
    func setData(title: String) {
        titleLabel.text = title
        
    }
    
    func setTopConstarint(isEmpty: Bool) {
        self.isEmpty = isEmpty
        topConst.constant = isEmpty ? 18 : 0
    }
}
