//
//  ListViewModel.swift
//  Total
//
//  Created by yeoboya on 2021/11/30.
//

import Foundation

class ListViewModel {
    // 사연을 받을떄 파라미터를 설정합니다.
    let stroyContent = ["send_mem_gender" : "M",
                        "bj_id" : "kkd",
                        "cmd" : "getProfile"]
    
    // List 모델 객체를 선언합니다.
    var detailInfo: [List] = []
    // Page 모델 객체를 선언합니다.
    var total: Page!
    
    var page: Int = 1
    // 내가 지금 페이징을 하고 있는지 안하고 있는지 알려줄 변수입니다.
    var isPaging: Bool = false
    // 다음 페이지가 있는지 없는지 알려줄 변수입니다.
    var hasNextPage: Bool = false
}
