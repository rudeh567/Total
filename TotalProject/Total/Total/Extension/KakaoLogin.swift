//
//  KakaoLogin.swift
//  Total
//
//  Created by yeoboya on 2021/11/30.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

extension WebViewController {
    func getKakaoInfo(completion: ((String) -> Void)? = nil) {
        print("카카오 사용자 정보")
        
    
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print("info err: \(error)")
            }
            else {
                print("me() success.")
                
                if let email = user?.kakaoAccount?.email {
                    completion?(email)
                }
            }
        }
    }
}
