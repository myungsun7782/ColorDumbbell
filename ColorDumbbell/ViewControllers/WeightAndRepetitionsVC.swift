//
//  WeightAndRepetitionsVC.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/17.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import RxKeyboard
import SnapKit

class WeightAndRepetitionsVC: UIViewController {
    // UIButton
    @IBOutlet var weightButtonArray: [UIButton]!
    @IBOutlet var repsButtonArray: [UIButton]!
    @IBOutlet weak var confirmButton: UIButton!
    
    // UITextField
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    
    // UIStackView
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var weightStackView: UIStackView!
    @IBOutlet weak var repsStackView: UIStackView!
    
    // UIView
    @IBOutlet weak var containerView: UIView!
    
    // ViewModel
    let viewModel = WeightAndRepetitionsVM()
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    // Constants
    let BUTTON_CORNER_RADIUS: CGFloat = 6
    let TEXT_FIELD_FONT_SIZE: CGFloat = 16
    let STACK_VIEW_CORNER_RADIUS: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        action()
        bind()
        
    }
    
    private func initUI() {
        // UIButton
        configureButton()
        
        // UITextField
        configureTextField()
        
        // UIView
        configureView()
        
        // UIStackView
        containerStackView.layer.cornerRadius = 0
        containerStackView.roundCorners(corners: [.topLeft, .topRight], radius: STACK_VIEW_CORNER_RADIUS)
    }
    
    private func action() {
        // UIButton
        confirmButton.rx.tap
            .subscribe(onNext: { _ in
                guard let weight = Double(self.weightTextField.text!) else { return }
                guard let reps = Int(self.repsTextField.text!) else { return }
                
                self.viewModel.delegate?.transferData(section: self.viewModel.section,
                                                      row: self.viewModel.row,
                                                      weight: weight,
                                                      reps: reps)
                
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        // RxKeyboard
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] keyboardHeight in
                let height = keyboardHeight > 0 ? -keyboardHeight + view.safeAreaInsets.bottom - 10  : 0
                
                self.containerStackView.snp.updateConstraints { make in
                    make.bottom.equalTo(view.safeAreaLayoutGuide).offset(height)
                }
                view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
        
        // UITextField
        weightTextField.rx.text.orEmpty
            .map { String($0.prefix(4))}
            .bind(to: weightTextField.rx.text)
            .disposed(by: disposeBag)
        
        weightTextField.rx.text.orEmpty
            .subscribe(onNext: { weight in
                if weight.isEmpty {
                    self.weightTextField.text = "\(self.viewModel.WEIGHT_DEFAULT_VALUE)"
                } else if weight.count == 2 {
                    if weight[weight.startIndex] == "0" {
                        self.weightTextField.text!.remove(at: self.weightTextField.text!.startIndex)
                    }
                }
            })
            .disposed(by: disposeBag)
        

        repsTextField.rx.text.orEmpty
            .map { String($0.prefix(4))}
            .bind(to: repsTextField.rx.text)
            .disposed(by: disposeBag)

        repsTextField.rx.text.orEmpty
            .subscribe(onNext: { reps in
                if reps.isEmpty {
                    self.repsTextField.text = "\(self.viewModel.REPS_DEFAULT_VALUE)"
                } else if reps.count == 2 {
                    if reps[reps.startIndex] == "0" {
                        self.repsTextField.text!.remove(at: self.repsTextField.text!.startIndex)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        
    }
    
    private func configureView() {
        containerView.backgroundColor = .black
        containerView.alpha = .zero
    }
    
    private func configureButton() {
        weightButtonArray.forEach { button in
            button.layer.cornerRadius = BUTTON_CORNER_RADIUS
        }
        repsButtonArray.forEach { button in
            button.layer.cornerRadius = BUTTON_CORNER_RADIUS
        }
    }
    
    private func configureTextField() {
        weightTextField.font = FontManager.shared.getPretendardRegular(fontSize: TEXT_FIELD_FONT_SIZE)
        guard let weight = viewModel.weight else { return }
        guard let reps = viewModel.reps else { return }
        weightTextField.text = "\(weight)"
        repsTextField.text = "\(reps)"
        repsTextField.font = FontManager.shared.getPretendardRegular(fontSize: TEXT_FIELD_FONT_SIZE)
    }
    
    private func focusTextFieldAtBeginning(_ textField: UITextField) {
        let startPosition = textField.beginningOfDocument
        textField.selectedTextRange = textField.textRange(from: startPosition, to: startPosition)
    }
    
    // 유저가 화면을 터치했을 때 호출되는 메서드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 키보드를 내린다.
        self.view.endEditing(true)
    }
}
