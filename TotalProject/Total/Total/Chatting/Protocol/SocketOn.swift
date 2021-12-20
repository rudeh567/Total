//
//  SocketOn.swift
//  Profile
//
//  Created by yeoboya on 2021/11/20.
//

import Foundation

// 서버에서 메시지를 수신받았을 때 해야할 일들을 프로토콜에서 함수를 정의해주었습니다.

protocol SocketOn {
    func showChat(chat: [Chat]?)
    func notiSetting(msg: String)
    func showAlert(msg: String)
    func showToastmsg(msg: String)
    func roomOut()
    func heartAnimation()
}
