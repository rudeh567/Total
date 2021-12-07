//
//  ProfileViewModel.swift
//  Total
//
//  Created by yeoboya on 2021/11/29.
//

import Foundation
import Alamofire
import SwiftyJSON

class ProfileViewModel {
    let defaultImage = Image.defaultImage // 이미지를 불러오지 못했을 때 기본 이미지를 따로 선언했습니다.
    var member: Member? // 멤버 모델 선언
    var photo: ProfilePhoto? // 포토 모델 선언
    let userInfo = UserInfo.shared // 이메일, 이름, 사진 등과 같이 자주쓰는 데이터를 편하게 쓰기 위해 싱글턴을 선언했습니다.
    
    //MARK: 기본 프로필 뷰 띄우기
    //서버에 요청을 보내고 서버에서 보내준 데이터로 기본 프로필을 띄웁니다. 따로 본인이 넘겨주는 데이터는 없습니다.
    func getProfileInfo(completion: ((Bool) -> Void)? = nil) {
        let parms = ["cmd": "getProfile", "gender": "F"]
        let urlString = "https://pida83.gabia.io/api/profile"
        let url = URL(string: urlString)
        
        AF.request(url!, method: .post, parameters: parms, encoding: JSONEncoding.default).responseJSON { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                    let result = try JSONDecoder().decode(ProfileResponse.self, from: data)

                    self.member = result.result.member
                    self.photo = result.result.photo

                    completion?(true)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print(key,context)
                }
                catch {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    //MARK: 내가 넘겨준 데이터로 프로필뷰 띄우기
    //MemberList나 채팅방에서 미니 프로필을 띄울 때 내가 넘겨준 데이터로 띄우기 위해 따로 만든 함수입니다. viewModel을 사용할 때 계속 데이터를 넘겨줘도 기본 프로필이 그 위를 덮어 내가 넘긴 데이터를 볼수가 없어서 이렇게 만들었습니다.
    func getProfileByMember(completion: ((Bool) -> Void)? = nil) {
        guard let email = userInfo.email else { return }

        let urlStr = "http://babyhoney.kr/api/member/\(email)"
        let url = URL(string: urlStr)!
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
        
        req.responseJSON { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                guard let name = json["mem_info"]["name"].string,
                      let sex = json["mem_info"]["gender"].string,
                      let age = json["mem_info"]["age"].string else { return }
                
                let conts = json["mem_info"]["contents"].stringValue
                
                guard let profilePhoto = json["mem_info"]["profile_image"].string else { return }

                let member = Member(name: name, l_code: nil, loc: nil, conts: conts, sex: sex, age: age, totLikeCnt: "100k")
                let photo = ProfilePhoto(profile: profilePhoto, photoList: [])

                self.userInfo.gender = member.sex
                self.member = member
                self.photo = photo
                
                completion?(true)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
