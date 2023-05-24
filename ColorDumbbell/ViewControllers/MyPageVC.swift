//
//  MyPageVC.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/04/16.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class MyPageVC: UIViewController {
    // UIStatusBarStyle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // UIStackView
    @IBOutlet weak var backButtonStackView: UIStackView!
    @IBOutlet weak var nameModificationStackView: UIStackView!
    @IBOutlet weak var timeModificationStackView: UIStackView!
    @IBOutlet weak var dumbbellCriteriaStackView: UIStackView!
    @IBOutlet weak var licenseStackView: UIStackView!
    
    // UIButton
    @IBOutlet weak var backButton: UIButton!
    
    // UILabel
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var currentMonthCountLabel: UILabel!
    @IBOutlet weak var totalExerciseCountLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    
    // UIImage
    @IBOutlet weak var dumbbellImageView: UIImageView!
    
    // ViewModel
    let viewModel = MyPageVM()
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    // Constants
    let BACK_BUTTON_IMAGE: UIImage? = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .medium))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        action()
    }
    
    private func initUI() {
        // UIButton
        configureButton()
        
        // UIImage
        configureImageView()
        
        // UILabel
        configureLabel()
    }
    
    private func action() {
        // UIStackView
        backButtonStackView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        dumbbellCriteriaStackView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.presentDumbbellCriteriaVC()
            })
            .disposed(by: disposeBag)
        nameModificationStackView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.presentUserNameVC()
            })
            .disposed(by: disposeBag)
        timeModificationStackView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.presentExerciseTimeVC()
            })
            .disposed(by: disposeBag)
        licenseStackView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.presentAppSettings()
            })
            .disposed(by: disposeBag)
    }
    
    private func configureButton() {
        backButton.setImage(BACK_BUTTON_IMAGE, for: .normal)
    }
    
    private func configureImageView() {
        dumbbellImageView.image = LevelManager.shared.getCurrentDumbbellImage(exerciseTotalCount: UserDefaultsManager.shared.getExerciseTotalCount())
    }
    
    private func configureLabel() {
        userNameLabel.text = UserDefaultsManager.shared.getUserName() + "님"
        if let currentCount = viewModel.currentMonthCount {
            currentMonthCountLabel.text = "이번 달 운동 횟수: \(currentCount)회"
        }
        if let totalCount = viewModel.totalExerciseCount {
            totalExerciseCountLabel.text = "총 운동 횟수: \(totalCount)회"
        }
    }
    
    private func presentDumbbellCriteriaVC() {
        let dumbbellCriteriaVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: VC.dumbbellCriteriaVC) as! DumbbellCriteriaVC
        
        dumbbellCriteriaVC.modalTransitionStyle = .crossDissolve
        dumbbellCriteriaVC.modalPresentationStyle = .fullScreen
        
        self.present(dumbbellCriteriaVC, animated: true)
    }
    
    private func presentUserNameVC() {
        let userNameVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: VC.usernameVC) as! UsernameVC
        
        userNameVC.viewModel.editorMode = .edit
        userNameVC.viewModel.passedName = UserDefaultsManager.shared.getUserName()
        userNameVC.viewModel.delegate = self
        
        self.present(userNameVC, animated: true)
    }
    
    private func presentExerciseTimeVC() {
        let exerciseTimeVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: VC.exerciseTimeVC) as! ExerciseTimeVC
    
        exerciseTimeVC.viewModel.editorMode = .edit
        exerciseTimeVC.viewModel.exerciseTime = UserDefaultsManager.shared.getExerciseTime()
    
        present(exerciseTimeVC, animated: true)
    }
    
    private func presentAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension MyPageVC: UserInfoDelegate {
    func updateName(name: String) {
        userNameLabel.text = name + "님"
    }
    
    func updateExerciseTime(exerciseTime: Date) {}
}
