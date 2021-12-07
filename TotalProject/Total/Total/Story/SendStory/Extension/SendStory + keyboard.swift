//
//  SendStory + keyboard.swift
//  Total
//
//  Created by yeoboya on 2021/12/01.
//

import Foundation
import UIKit

extension SendStory {
    func keyboardSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(_sender: Notification) {
        self.contentViewBottom.constant = 0
        
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
                
            self.contentViewBottom.constant = -keyboardHeight + self.safeAreaInsets.bottom
            
            print(contentViewBottom.constant)
            
            UIView.animate(withDuration: 0.5) {
                self.layoutIfNeeded()
            }
        }
    }
}
