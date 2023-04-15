//
//  MainTopCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/04/11.
//

import UIKit
import RxSwift

class MainTopCell: UITableViewCell {
    // UIButton
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var convenienceButton: UIButton!
    
    // UILabel
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currentCountLabel: UILabel!
    @IBOutlet weak var totalCountLabel: UILabel!
    
    // UIImageView
    @IBOutlet weak var dumbbellImageView: UIImageView!
    
    // UIProgressView
    @IBOutlet weak var mainProgressView: GradientProgressView!
    
    // Variables
    var index: Int?
    var disposeBag = DisposeBag()
    
    // Constant
    let BUTTON_RADIUS: CGFloat = 17
    let PROGRESS_VIEW_RADIUS: CGFloat = 10
    let MY_PAGE_BUTTON_IMAGE: UIImage? = UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
    
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
            mainProgressView.layer.cornerRadius = .zero
            mainProgressView.roundCorners(
                corners: [.allCorners], radius: PROGRESS_VIEW_RADIUS)
            self.layoutIfNeeded()
        }
    }
    
    private func initUI() {
        // UIButton
        configureButton()
    }
    
    private func configureProgressView() {
        let currentCount = UserDefaultsManager.shared.getExerciseTotalCount()
        let currentLevel = LevelManager.shared.getCurrentLevel(exerciseTotalCount: currentCount)
        let currentColorMax = LevelManager.shared.getLevelMaxValue(level: currentLevel)
        let gradientColorArray = LevelManager.shared.getCurrentGradientColor(exerciseTotalCount: currentCount)
        mainProgressView.progressViewStyle = .default
        mainProgressView.trackTintColor = ColorManager.shared.getPlatinum()
        mainProgressView.firstColor = gradientColorArray[0]
        mainProgressView.secondColor = gradientColorArray[1]
        self.mainProgressView.setProgress(Float(currentCount) / Float(currentColorMax), animated: true)
    }
    
    private func configureButton() {
        convenienceButton.layer.cornerRadius = BUTTON_RADIUS
        editButton.setImage(MY_PAGE_BUTTON_IMAGE, for: .normal)
    }
    
    func setData(name: String, index: Int) {
        self.index = index
        nameLabel.text = name + "님,"
        
        // TODO: 현재 레벨에 맞는 운동 횟수 값 넣어주기
        currentCountLabel.text = "(\(UserDefaultsManager.shared.getExerciseTotalCount())"
        totalCountLabel.text = "\(LevelManager.shared.getLevelMaxValue(level: .pink))" + ")"
        configureProgressView()
    }
}
