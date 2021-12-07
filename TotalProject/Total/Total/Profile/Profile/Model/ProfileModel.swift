//
//  ProfileModel.swift
//  Total
//
//  Created by yeoboya on 2021/11/29.
//

import Foundation

// 멤버와 포토를 둘다 가지고 있는 구조체입니다.
struct ProfileResult: Codable {
    let photo: ProfilePhoto
    let member: Member
}

//멤버와 포토를 감싸고 있는 데이터입니다.
struct ProfileResponse: Codable {
    let result: ProfileResult
    let status: String
}

//프로필을 띄울 때 회원 정보를 가져옵니다.
struct Member: Codable {
    var name: String?
    let l_code: String?
    var loc: String?
    var conts: String?
    var sex: String?
    var age: String?
    var totLikeCnt: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "chat_name"
        case l_code
        case loc
        case conts = "chat_conts"
        case sex = "mem_sex"
        case age = "mem_age"
        case totLikeCnt
    }
}

// 이미지를 url로 파싱할 수 있습니다.
struct Photo: Codable {
    let url: String
}

// 프로필 이미지와 컬렉션뷰에 들어갈 사진 목록을 가지고 있습니다.
struct ProfilePhoto: Codable {
    var profile: String
    var photoList: [Photo]?
    
    enum CodingKeys: String, CodingKey {
        case profile = "defPhoto"
        case photoList = "photoList"
    }
}
