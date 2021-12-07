//
//  Profile + Layout.swift
//  Total
//
//  Created by yeoboya on 2021/12/01.
//

import Foundation
import UIKit

extension ProfileViewController {
    func contentViewSetting() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 30
        contentView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
    
    func profileImageSetting() {
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }
    
    func genderViewSetting() {
        genderView.clipsToBounds = true
        genderView.layer.cornerRadius = 11
        genderView.layer.borderWidth = Size.w1
        genderView.layer.borderColor = Color.pinkTwo.cgColor
    }
    
    func likeViewSetting() {
        likeView.clipsToBounds = true
        likeView.layer.cornerRadius = 18
        likeView.layer.borderWidth = Size.w1
        likeView.layer.borderColor = Color.veryLightPinkTwo.cgColor
        likeView.backgroundColor = Color.veryLightPink
    }
    
    func locationViewSetting() {
        locationView.clipsToBounds = true
        locationView.layer.cornerRadius = 13.5
        locationView.layer.borderWidth = Size.w1
        locationView.layer.borderColor = Color.lightBlueGrey.cgColor
        locationView.backgroundColor = Color.iceBlue
        
        locationLabel.textColor = Color.fadedBlue
    }
    
    func costsViewSetting() {
        costsView.clipsToBounds = true
        costsView.layer.cornerRadius = 4
        costsView.layer.borderWidth = Size.w1
        costsView.layer.borderColor = Color.whiteFour.cgColor
        costsView.backgroundColor = Color.whiteTwo
    }
    
    func totalPhotoButtonSetting() {
        totalPhotoButton.clipsToBounds = true
        totalPhotoButton.layer.cornerRadius = 11
    }
}
