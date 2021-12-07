//
//  ListModel.swift
//  Total
//
//  Created by yeoboya on 2021/11/30.
//

import Foundation

struct Page: Codable {
    let status: String
    let list: [List]
    let total_page: Int
    let current_page: Int
}

struct List: Codable {
    let send_mem_gender: String
    let send_mem_no: String
    let send_chat_name: String
    let ins_date: String
    let send_mem_photo: String
    let story_conts: String
    let bj_id: String
}
