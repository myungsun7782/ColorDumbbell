//
//  UsernameVM.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/07.
//

import Foundation
import RxSwift

class UsernameVM {
    // Input
    var input = Input()
    
    // Output
    var output = Output()
    
    // Variable
    var isEnabled: Bool = false
    var editorMode: EditorMode = .new
    var passedName: String?
    var delegate: UserInfoDelegate?
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    // Constants
    let MINIMUM_LENGTH: Int = 2
    let MAXIMUM_LENGTH: Int = 6
    
    struct Input {
        var nickname = BehaviorSubject<String>(value: "")
    }
    
    struct Output {
        var nextButtonValidation = PublishSubject<Bool>()
    }
    
    init() {
        input.nickname.subscribe(onNext: { name in
            self.output.nextButtonValidation.onNext(self.validateName(name: name))
        })
        .disposed(by: disposeBag)
        
    }
    
    private func validateName(name: String) -> Bool {
        if name.count >= MINIMUM_LENGTH && name.count <= MAXIMUM_LENGTH {
            return true
        }
        return false
    }
    
    func updateUserName(name: String, userNameVC: UsernameVC) {
        LoadingManager.shared.showLoading()
        UserDefaultsManager.shared.setUserName(userName: name)
        FirebaseManager.shared.updateUserName(userName: name) { isSuccess in
            if isSuccess {
                print("Successfully update user name!")
            }
            userNameVC.viewModel.delegate?.updateName(name: name)
            userNameVC.dismiss(animated: true)
            LoadingManager.shared.hideLoading()
        }
    }
}
