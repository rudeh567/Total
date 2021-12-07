//
//  Web.swift
//  Total
//
//  Created by yeoboya on 2021/11/30.
//

import Foundation
import NaverThirdPartyLogin
import Alamofire
import SwiftyJSON

extension WebViewController: NaverThirdPartyLoginConnectionDelegate {
    
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("로그인 되었습니다. =====================")
        getInfo(completion : isMember)
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        self.loginInstance?.accessToken
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        print("로그아웃 되었습니다. =====================")
        self.loginInstance?.requestDeleteToken()
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("error = \(error.localizedDescription)")
    }
    
    func getInfo(completion: ((String) -> Void)? = nil) {
        guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        
        if !isValidAccessToken {
            return
        }
        
        guard let tokenType = loginInstance?.tokenType else { return }
        guard let accessToken = loginInstance?.accessToken else { return }
        
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        
        let authorization = "\(tokenType) \(accessToken)"
        
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        req.responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                guard let email = json["response"]["email"].string else { return }
                
                completion?(email)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
