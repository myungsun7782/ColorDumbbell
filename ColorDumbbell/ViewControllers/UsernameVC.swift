//
//  UsernameVC.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/07.
//

import UIKit
import RxSwift
import RxCocoa

class UsernameVC: UIViewController {
    // UIStatusBarStyle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return viewModel.editorMode == .new ? .darkContent : .lightContent
    }
    
    // UIStackView
    @IBOutlet weak var stepStackView: UIStackView!
    
    // UITextField
    @IBOutlet weak var nameTextField: UITextField!
    
    // UILabel
    @IBOutlet weak var validationLabel: UILabel!
    
    // UIButton
    @IBOutlet weak var nextButton: UIButton!
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    // ViewModel
    let viewModel = UsernameVM()
    
    // Constants
    let BUTTON_CORNER_RADIUS: CGFloat = 10
    let BUTTON_FONT_SIZE: CGFloat = 16
    let TEXT_FIELD_PLACE_HOLDER: String = "닉네임을 입력해주세요 :)"
    let TEXT_FIELD_FONT_SIZE: CGFloat = 20
    let ACTIVE_HINT: String = "사용하실 수 있는 닉네임입니다."
    let DUPLICATION_HINT: String = "이미 존재하는 닉네임입니다."
    let IN_ACTIVE_HINT: String = "2글자에서 6글자 이내로 설정해주세요."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        action()
        bind()
        turnOnEditMode()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        nameTextField.becomeFirstResponder()
    }
    
    private func initUI() {
        // UIStackView
        stepStackView.isHidden = viewModel.editorMode == .new ? false : true
        
        // UITextField
        configureTextField()
        
        // UIButton
        configureButton()
    }
    
    private func action() {
        // UIButton
        nextButton.rx.tap
            .subscribe(onNext: { _ in
                if self.viewModel.editorMode == .new {
                    self.presentExerciseTimeVC()
                } else if self.viewModel.editorMode == .edit {
                    guard let userName = self.nameTextField.text else { return }
                    self.viewModel.updateUserName(name: userName, userNameVC: self)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        // Input
        nameTextField.rx.text.orEmpty
            .bind(to: viewModel.input.nickname)
            .disposed(by: disposeBag)
        
        // Output
        viewModel.output.nextButtonValidation
            .subscribe(onNext: { isValidated in
                self.nextButton.isEnabled = isValidated
                self.nextButton.backgroundColor = self.nextButton.isEnabled ? .black : ColorManager.shared.getPhilippineSilver()
                self.validationLabel.text = isValidated ? self.ACTIVE_HINT : self.IN_ACTIVE_HINT
            })
            .disposed(by: disposeBag)
    }
    
    private func turnOnEditMode() {
        if viewModel.editorMode == .edit {
            guard let name = viewModel.passedName else { return }
            nameTextField.text = name
        }
    }
    
    private func configureTextField() {
        nameTextField.font = FontManager.shared.getPretendardRegular(fontSize: TEXT_FIELD_FONT_SIZE)
        nameTextField.attributedPlaceholder = NSAttributedString(string: TEXT_FIELD_PLACE_HOLDER, attributes: [NSAttributedString.Key.foregroundColor : ColorManager.shared.getSilverFoil()])
    }
    
    private func configureButton() {
        nextButton.isEnabled = viewModel.editorMode == .new ? false : true
        self.nextButton.backgroundColor = self.nextButton.isEnabled ? .black : ColorManager.shared.getPhilippineSilver()
        nextButton.layer.cornerRadius = BUTTON_CORNER_RADIUS
        nextButton.titleLabel?.font = FontManager.shared.getPretendardMedium(fontSize: BUTTON_FONT_SIZE)
        nextButton.setTitle(viewModel.editorMode == .new ? "다음으로" : "완료", for: .normal)
        nextButton.setTitleColor(ColorManager.shared.getWhite(), for: .normal)
    }
    
    private func presentExerciseTimeVC() {
        let exerciseTimeVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: VC.exerciseTimeVC) as! ExerciseTimeVC
    
        exerciseTimeVC.viewModel.userName = nameTextField.text
        exerciseTimeVC.modalPresentationStyle = .fullScreen
        exerciseTimeVC.modalTransitionStyle = .crossDissolve
        
        present(exerciseTimeVC, animated: true)
    }
}
