//
//  RcvServer.swift
//  Profile
//
//  Created by yeoboya on 2021/11/15.
//

import Foundation

struct RcvServer: Codable {
    let cmd: String
    let msg: String?
    let from: From?
}

struct From: Codable {
    let mem_id: String?
    let chat_name: String?
    let mem_photo: String?
}
