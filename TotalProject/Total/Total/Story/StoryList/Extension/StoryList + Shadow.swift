//
//  StoryList + Layout.swift
//  Total
//
//  Created by yeoboya on 2021/12/01.
//

import Foundation
import UIKit

extension StoryList {
    // 그림자를 설정합니다.
    func shadowSetting() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 6)
        self.layer.shadowRadius = 12
        self.layer.shadowOpacity = 0.5
    }
}
