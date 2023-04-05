//
//  ExerciseTimeVC.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/08.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class ExerciseTimeVC: UIViewController {
    // UIStatusBarStyle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // UIStackView
    @IBOutlet weak var stepStackView: UIStackView!
    
    // UITextField
    @IBOutlet weak var exerciseTimeTextField: UITextField!
    
    // UIButton
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    // UIDatePicker
    @IBOutlet weak var timePickerView: UIDatePicker!
    
    // ViewModel
    let viewModel = ExerciseTimeVM()
    
    // Constants
    let BUTTON_CORNER_RADIUS: CGFloat = 10
    let BUTTON_FONT_SIZE: CGFloat = 16
    let TEXT_FIELD_PLACE_HOLDER: String = "운동 시간을 선택해주세요 :)"
    let TEXT_FIELD_FONT_SIZE: CGFloat = 20
    let PICKER_KEY_PATH: String = "textColor"
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        action()
        bind()
    }
    
    private func initUI() {
        // UITextField
        configureTextField()
        
        // UIButton
        configureButton()
        
        // UIDatePicker
        configureDatePicker()
    }
    
    private func action() {
        // UIButton
        backButton.rx.tap
            .subscribe(onNext: { _ in
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        startButton.rx.tap
            .subscribe(onNext: { _ in
                if self.viewModel.editorMode == .new {
                    self.presentMainVC()
                }
            })
            .disposed(by: disposeBag)
        
        // UIDatePicker
        timePickerView.rx.controlEvent([.valueChanged])
            .asObservable()
            .subscribe(onNext: { _ in
                self.viewModel.exerciseTime = self.timePickerView.date
                self.exerciseTimeTextField.text = TimeManager.shared.dateToString(date: self.timePickerView.date, options: [.time])
            })
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        // Input
        
        // Output
    }
    
    private func configureTextField() {
        exerciseTimeTextField.font = FontManager.shared.getPretendardRegular(fontSize: TEXT_FIELD_FONT_SIZE)
        exerciseTimeTextField.attributedPlaceholder = NSAttributedString(string: TEXT_FIELD_PLACE_HOLDER, attributes: [NSAttributedString.Key.foregroundColor : ColorManager.shared.getSilverFoil()])
        exerciseTimeTextField.inputView = timePickerView
        exerciseTimeTextField.text = TimeManager.shared.dateToString(date: Date(), options: [.time])
    }
    
    private func configureButton() {
        backButton.layer.cornerRadius = BUTTON_CORNER_RADIUS
        backButton.backgroundColor = ColorManager.shared.getLightSilver()
        backButton.titleLabel?.font = FontManager.shared.getPretendardMedium(fontSize: BUTTON_FONT_SIZE)
        backButton.setTitleColor(ColorManager.shared.getWhite(), for: .normal)
       
        startButton.layer.cornerRadius = BUTTON_CORNER_RADIUS
        startButton.backgroundColor = ColorManager.shared.getBlack()
        startButton.titleLabel?.font = FontManager.shared.getPretendardMedium(fontSize: BUTTON_FONT_SIZE)
        startButton.setTitleColor(ColorManager.shared.getWhite(), for: .normal)
    }
    
    private func configureDatePicker() {
        timePickerView.backgroundColor = ColorManager.shared.getWhite()
        timePickerView.setValue(UIColor.black, forKeyPath: PICKER_KEY_PATH)
    }
    
    private func presentMainVC() {
        let mainVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: VC.mainTabBarController) as! MainTabBarController
        
        mainVC.modalPresentationStyle = .overFullScreen
        mainVC.modalTransitionStyle = .crossDissolve
        
        guard let name = viewModel.userName else { return }
        guard let exerciseTime = viewModel.exerciseTime else { return }
        let user = User(name: name, exerciseTime: exerciseTime)
        
        // UserDefaults에 필요한 정보 저장
        UserDefaultsManager.shared.finishIntialization(uid: user.uid, userName: user.name, exerciseTime: user.exerciseTime, totalExerciseCount: user.totalExerciseCount)

        // CloudFirestore에 필요한 정보 저장
        viewModel.saveUserData(userObj: user)
        
        present(mainVC, animated: true)
    }
}
