//
//  File.swift
//  Total
//
//  Created by yeoboya on 2021/11/29.
//

import Foundation
import UIKit

extension UIView {
    //MARK: Animate 함수
    //자주쓰는 animate 함수를 extension으로 확장해줘서 어디서나 재사용 할 수 있게 했습니다.
    func showAni(_ duration: TimeInterval = 0.5, delay: Double = 0, y: CGFloat) {
        self.frame.origin.y = self.bounds.height
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn) {
            self.frame.origin.y = 0 - y
        }
    }
    
    func dimissAni(_ duration: TimeInterval = 0.5, delay: Double = 0, y: CGFloat) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveLinear) {
            self.frame.origin.y = self.bounds.height + y
        }
        
    }
}
