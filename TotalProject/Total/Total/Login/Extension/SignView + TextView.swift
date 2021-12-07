//
//  signupText.swift
//  Profile
//
//  Created by yeoboya on 2021/11/05.
//

import Foundation
import UIKit

extension SignViewController: UITextViewDelegate, UITextFieldDelegate {
    func textViewSetting() {
        textViewContent.delegate = self
        textViewContent.text = nil
        textViewContent.text = "소개글을 작성해 주세요."
        textViewContent.backgroundColor = UIColor.white
        textViewContent.textColor = UIColor.lightGray
    }
    
    // textView의 글자수를 제한하고 레이블로 출력해주는 함수입니다.
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let str = textViewContent.text else { return true }
        let newLength = str.count + text.count - range.length
        
        textCount.text = "(\(newLength)/200)"
        hasContents = textView.text.count >= 10
        btnCase()
        
        return newLength < 200
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textViewContent.textColor == UIColor.lightGray {
            textViewContent.text = nil
            textViewContent.textColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.btnCase()
    }
    
    func btnCase() {
        if hasContents, textField.text != nil, isManClick || isLadyClick, profileImageView != nil {
            btnOn()
        } else {
            btnOff()
        }
    }
}
