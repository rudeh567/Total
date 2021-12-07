//
//  Chat.swift
//  Profile
//
//  Created by yeoboya on 2021/11/16.
//

import Foundation

struct Chat: Codable {
    let cmd: String
    var msg: String?
    let mem_id: String?
    let chat_name: String?
    let mem_photo: String?
}
