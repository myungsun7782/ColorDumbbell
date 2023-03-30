//
//  AlertManager.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/15.
//

import UIKit

class AlertManager {
    static let shared = AlertManager()
    let CONFIRM_BUTTON_TITLE: String = "확인"
    let CANCEL_BUTTON_TITLE: String = "취소"
    
    private init() {}
    
    func presentOneButtonAlert(title: String, message: String, buttonHandler: @escaping () -> (), completionHandler: @escaping (_ alert: UIAlertController) -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: CONFIRM_BUTTON_TITLE, style: .default) { _ in
            buttonHandler()
        }
        alert.addAction(button)
        completionHandler(alert)
    }
    
    func presentTwoButtonAlert(title: String, message: String, buttonTitle: String, style: UIAlertController.Style, buttonHandler: @escaping () -> (), completionHandler: @escaping (_ alert: UIAlertController) -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let rightButton = UIAlertAction(title: buttonTitle, style: .destructive) { _ in
            buttonHandler()
        }
        let cancelButton = UIAlertAction(title: CANCEL_BUTTON_TITLE, style: .cancel)
        
        alert.addAction(rightButton)
        alert.addAction(cancelButton)
        completionHandler(alert)
    }
    
    func presentActionSheetAlert(title: String?, message: String, firstButtonTitle: String, secondButtonTitle: String, buttonHandler: @escaping () -> (), completionHandler: @escaping (_ alert: UIAlertController) ->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let discardAction = UIAlertAction(title: firstButtonTitle, style: .destructive) { _ in
            buttonHandler()
        }
        let cancelAction = UIAlertAction(title: secondButtonTitle, style: .cancel)
        alert.addAction(discardAction)
        alert.addAction(cancelAction)
        
        completionHandler(alert)
    }
}
