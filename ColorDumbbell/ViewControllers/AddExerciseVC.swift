//
//  AddExerciseVC.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/15.
//

import UIKit
import RxSwift
import RxCocoa

class AddExerciseVC: UIViewController {
    // UIStatusBarStyle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // UIView
    @IBOutlet weak var containerView: UIView!
    
    // UIStackView
    @IBOutlet weak var popUpStackView: UIStackView!
    
    // UITextField
    @IBOutlet weak var exerciseTextField: UITextField!
    
    // UIButton
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    // UILabel
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // ViewModel
    let viewModel = AddExerciseVM()
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    // Constants
    let STACK_VIEW_BORDER_RADIUS: CGFloat = 7
    let TEXT_FIELD_CORNER_RADIUS: CGFloat = 5
    let TEXT_FIELD_FONT_SIZE: CGFloat = 16
    let TEXT_FIELD_BORDER_WIDTH: CGFloat = 1
    let TEXT_FIELD_PLACE_HODLER: String = "운동의 이름은 1글자 이상이어야 합니다!"
    let ADD_TITLE_TEXT: String = "새로운 운동 추가"
    let ADD_DESCRIPTION_TEXT: String = "추가할 운동을 입력해주세요 :)"
    let MODIFICATION_TITLE_TEXT: String = "기존 운동 수정"
    let MODIFICATION_DESCRIPTION_TEXT: String = "수정할 운동 이름을 입력해주세요 :)"
    let BUTTON_CORNER_RADIUS: CGFloat = 7
    let BUTTON_BORDER_WIDTH: CGFloat = 1
    let CONTAINER_VIEW_ALPHA: CGFloat = 0.65
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        action()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        exerciseTextField.becomeFirstResponder()
    }
    
    private func initUI() {
        // UIStackView
        popUpStackView.layer.cornerRadius = STACK_VIEW_BORDER_RADIUS
        
        // UIView
        containerView.backgroundColor = .black
        containerView.alpha = CONTAINER_VIEW_ALPHA
        
        // UITextField
        configureTextField()
        
        // UIButton
        configureButton()
        
        // UILabel
        configureLabel()
    }
    
    private func action() {
        // UIButton
        cancelButton.rx.tap
            .subscribe(onNext: { _ in
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .subscribe(onNext: { _ in
                if self.viewModel.editorMode == .edit {
                    guard var exercise = self.viewModel.exercise else { return }
                    guard let exerciseName = self.exerciseTextField.text else { return }
                    exercise.name = exerciseName
                    if exercise.type == ExerciseType.basis.rawValue {
                        FirebaseManager.shared.modifyDefaultExercise(exercise: exercise) { isSuccess in
                            if isSuccess {
                                self.viewModel.exerciseDelegate?.manageExercise(section: self.viewModel.section,
                                                                                row: self.viewModel.row,
                                                                                exerciseName: exerciseName,
                                                                                editorMode: self.viewModel.editorMode)
                                
                            }
                        }
                    } else if exercise.type == ExerciseType.custom.rawValue {
                        FirebaseManager.shared.modifyCustomExercise(exercise: exercise) { isSuccess in
                            if isSuccess {
                                self.viewModel.exerciseDelegate?.manageExercise(section: self.viewModel.section,
                                                                                row: self.viewModel.row,
                                                                                exerciseName: exerciseName,
                                                                                editorMode: self.viewModel.editorMode)
                            }
                        }
                    }
                } else if self.viewModel.editorMode == .new {
                    guard let exerciseName = self.exerciseTextField.text else { return }
                    let exerciseArea = self.viewModel.exerciseAreaArray[self.viewModel.section]
                    let exercise = Exercise(name: exerciseName,
                                            area: exerciseArea.rawValue,
                                            quantity: [],
                                            id: UUID().uuidString,
                                            type: ExerciseType.custom.rawValue)
                    FirebaseManager.shared.addCustomExercise(exercise: exercise) { isSuccess in
                        if isSuccess {
                            self.viewModel.exerciseDelegate?.manageExercise(section: self.viewModel.section,
                                                                            row: self.viewModel.row,
                                                                            exerciseName: exerciseName, editorMode: self.viewModel.editorMode)
                        }
                    }
                }
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        // Input
        exerciseTextField.rx.text.orEmpty
            .bind(to: viewModel.input.exerciseName)
            .disposed(by: disposeBag)
        
        // Output
        viewModel.output.saveButtonValidation
            .subscribe(onNext: { isValidated in
                self.saveButton.isEnabled = isValidated
                self.saveButton.setTitleColor(self.saveButton.isEnabled ? ColorManager.shared.getBleuDeFrance() : ColorManager.shared.getArgent(), for: .normal)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureLabel() {
        titleLabel.text = viewModel.editorMode == .new ? ADD_TITLE_TEXT : MODIFICATION_TITLE_TEXT
        descriptionLabel.text = viewModel.editorMode == .new ? ADD_DESCRIPTION_TEXT : MODIFICATION_DESCRIPTION_TEXT
    }
    
    
    private func configureButton() {
        cancelButton.layer.addBorder([.top,.right], color: ColorManager.shared.getGrayX11(), width: BUTTON_BORDER_WIDTH)
        cancelButton.roundCorners(corners: [.bottomLeft], radius: BUTTON_CORNER_RADIUS)
        
        saveButton.layer.addBorder([.top], color: ColorManager.shared.getGrayX11(), width: BUTTON_BORDER_WIDTH)
        saveButton.roundCorners(corners: [.bottomRight], radius: BUTTON_CORNER_RADIUS)
        saveButton.isEnabled = viewModel.editorMode == .new ? false : true
        self.saveButton.setTitleColor(self.saveButton.isEnabled ? ColorManager.shared.getBleuDeFrance() : ColorManager.shared.getArgent(), for: .normal)
    }
    
    private func configureTextField() {
        exerciseTextField.font = FontManager.shared.getPretendardRegular(fontSize: TEXT_FIELD_FONT_SIZE)
        exerciseTextField.layer.borderWidth = TEXT_FIELD_BORDER_WIDTH
        exerciseTextField.layer.borderColor = ColorManager.shared.getGrayX11().cgColor
        exerciseTextField.layer.cornerRadius = TEXT_FIELD_CORNER_RADIUS
        exerciseTextField.addLeftPadding()
        exerciseTextField.attributedPlaceholder = NSAttributedString(string: TEXT_FIELD_PLACE_HODLER, attributes: [NSAttributedString.Key.foregroundColor : ColorManager.shared.getLavenderGray()])
        
        if let exerciseName = viewModel.exercise?.name {
            exerciseTextField.text = exerciseName
            viewModel.input.exerciseName.onNext(exerciseName)
        }
    }
}

