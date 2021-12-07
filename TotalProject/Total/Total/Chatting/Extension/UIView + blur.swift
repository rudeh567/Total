//
//  UIView + blur.swift
//  Total
//
//  Created by yeoboya on 2021/11/30.
//

import Foundation
import UIKit

// MARK: 블러처리를 위한 그라데이션 설정
extension UIView {
    @discardableResult
    func applyGradient2(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }
    
    @discardableResult
    func applyGradient2(colours: [UIColor], locations: [NSNumber]?, width: CGFloat, height: CGFloat) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: width, height: height)
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.name = "grad"
        gradient.startPoint = CGPoint(x: 0, y: 0.2)
        gradient.endPoint = CGPoint(x: 0, y: 0)
        self.layer.mask = gradient
        return gradient
    }
    
}
