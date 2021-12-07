//
//  SendStory + Layout.swift
//  Total
//
//  Created by yeoboya on 2021/12/01.
//

import Foundation
import UIKit

extension SendStory {
    // 뷰 레이아웃 세팅입니다.
    func viewSetting() {
        //radius
        costsView.clipsToBounds = true
        costsView.layer.cornerRadius = 5
        sendButton.clipsToBounds = true
        sendButton.isEnabled = false
        sendButton.layer.cornerRadius = 19
    }
    
    // 그림자 세팅입니다.
    func shadowSetting() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: -12)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.1
    }
}
