//
//  UserInfo.swift
//  Total
//
//  Created by yeoboya on 2021/11/30.
//

import Foundation
import UIKit

class UserInfo {
    static let shared = UserInfo()
    
    var email: String?
    var name: String?
    var photo: String?
    var gender: String?
    var isSignUp: Bool = false
    
    private init() { }
}

struct Email {
    var email: String
    var name: String
    var porfile_image: UIImage
    var age: String
    var costs: String
    var gender: String
}
