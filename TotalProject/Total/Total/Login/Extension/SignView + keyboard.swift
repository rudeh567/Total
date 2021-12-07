//
//  SignView + keyboard.swift
//  Total
//
//  Created by yeoboya on 2021/12/01.
//

import Foundation
import UIKit

extension SignViewController {
    func keyboardSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(_sender: Notification) {
        self.view.frame.origin.y = 0
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if textViewContent.isFirstResponder {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                
                self.view.frame.origin.y = -keyboardHeight + self.view.frame.height - self.view.safeAreaLayoutGuide.layoutFrame.height
                
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}
