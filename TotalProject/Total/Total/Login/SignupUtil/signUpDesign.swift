//
//  signUpDesign.swift
//  Profile
//
//  Created by yeoboya on 2021/11/04.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
extension SignViewController {
    func photoSetting() {
        photoLine.layer.cornerRadius = 10
        photoLine.layer.borderWidth = Size.w1
        photoLine.clipsToBounds = true
        photoLine.layer.borderColor = Color.white.cgColor
    }
    
    func textFieldBackSetting() {
        textFieldBack.layer.cornerRadius = 5
        textFieldBack.layer.borderWidth = Size.w1
        textFieldBack.clipsToBounds = true
        textFieldBack.layer.borderColor = Color.white.cgColor
    }
    
    func manBtnSetting() {
        manBtn.layer.cornerRadius = 5
        manBtn.layer.borderWidth = Size.w1
        manBtn.clipsToBounds = true
        manBtn.backgroundColor = .white
        manBtn.layer.borderColor = Color.white.cgColor
    }
    
    func womanBtnSetting() {
        womanBtn.layer.cornerRadius = 5
        womanBtn.layer.borderWidth = Size.w1
        womanBtn.clipsToBounds = true
        womanBtn.backgroundColor = .white
        womanBtn.layer.borderColor = Color.white.cgColor
    }
    
    func manBtnisClick() {
        manBtn.layer.cornerRadius = 5
        manBtn.layer.borderWidth = Size.w1
        manBtn.clipsToBounds = true
        manBtn.backgroundColor = Color.iceBlue
        manBtn.layer.borderColor = Color.softBlue.cgColor
    }
    
    func womanBtnisClick() {
        womanBtn.layer.cornerRadius = 5
        womanBtn.layer.borderWidth = Size.w1
        womanBtn.clipsToBounds = true
        womanBtn.backgroundColor = Color.lightPink
        womanBtn.layer.borderColor = Color.pink.cgColor
    }
    
    func birthdayBtnSetting() {
        yearBtn.layer.cornerRadius = 5
        yearBtn.layer.borderWidth = Size.w1
        yearBtn.clipsToBounds = true
        yearBtn.layer.borderColor = Color.white.cgColor
        monthBtn.layer.cornerRadius = 5
        monthBtn.layer.borderWidth = Size.w1
        monthBtn.clipsToBounds = true
        monthBtn.layer.borderColor = Color.white.cgColor
        dayBtn.layer.cornerRadius = 5
        dayBtn.layer.borderWidth = Size.w1
        dayBtn.clipsToBounds = true
        dayBtn.layer.borderColor = Color.white.cgColor
    }
    
    func textViewBackSetting() {
        textViewBack.layer.cornerRadius = 4
        textViewBack.layer.borderWidth = Size.w1
        textViewBack.clipsToBounds = true
        textViewBack.layer.borderColor = Color.white.cgColor
    }
    
    func finishBtnSetting() {
        finishBtn.tintColor = .white
        finishBtn.backgroundColor = .lightGray
        finishBtn.isEnabled = false
        finishBtn.layer.cornerRadius = 25
    }
}
