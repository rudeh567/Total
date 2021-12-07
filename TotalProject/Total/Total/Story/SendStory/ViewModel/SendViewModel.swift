//
//  SendViewModel.swift
//  Total
//
//  Created by yeoboya on 2021/11/29.
//

import Foundation
import Alamofire

class SendViewModel {

    // 사연을 보낼때 사용자 정보, 보낼 비제이의 정보를 파라미터 변수로 설정합니다.
    var parm = ["send_mem_gender" : "M",
                "send_mem_no" : 20030723,
                "send_chat_name" : "걍도",
                "send_mem_photo" : Image.defaultImage,
                "2" : "이것은 사연입니다",
                "bj_id" : "kkd"] as [String : Any]
    
    //MARK: 데이터 전송
    // 사연 보내기에 성공했을시 전송 정보를 출력합니다.
    func dataSend(storys: String) {
        parm.updateValue(storys, forKey: "story_conts")
        
        AF.request(URL(string: Host.host)!, method: .post, parameters: parm, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
                case.success(let response):
                    print("성공입니다")
                    print(response)
                case.failure(let err):
                    print(err.localizedDescription)
            }
        }
    }
}
