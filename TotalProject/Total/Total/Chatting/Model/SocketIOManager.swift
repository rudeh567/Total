//
//  SocketIOManager.swift
//  Profile
//
//  Created by yeoboya on 2021/11/11.
//

import UIKit
import SocketIO
import Alamofire
import SwiftUI
import SDWebImageWebPCoder
import Lottie

class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    var manager = SocketManager(socketURL: URL(string: "https://devsol6.club5678.com:5555")!, config: [.log(false), .compress, .reconnects(false)])
    var socket: SocketIOClient!
    
    // 사용자가 보내는 채팅과 사용자 정보를 저장하는 배열 선언
    var chat: [Chat] = []
    // SocketOn을 채택하는 뷰컨트롤러를 선언
    var vc: SocketOn?
    
    override init() {
        super.init()
        socket = self.manager.socket(forNamespace: "/")
    }
    
    //MARK: - 메세지 수신 및 분기처리
    func socketOn() {
        socket.on("message") { [weak self] dataArray, ack in
            do {
                
                let data = try JSONSerialization.data(withJSONObject: dataArray[0], options: .prettyPrinted)
                let result = try JSONDecoder().decode(RcvServer.self, from: data)
                
                print("************************************")
                print("res === \(result)")
                print("************************************")
                
                if result.cmd == "rcvSystemMsg" || result.cmd == "rcvChatMsg" {
                    self?.chat.insert(Chat(cmd: result.cmd, msg: result.msg, mem_id: result.from?.mem_id, chat_name: result.from?.chat_name, mem_photo: result.from?.mem_photo), at: 0)
                    
                    self?.vc?.showChat(chat: self?.chat)
                } else if result.cmd == "rcvRoomOut" {
                    self?.vc?.roomOut()
                    self?.chat.removeAll()
                } else if result.cmd == "rcvAlertMsg" {
                    self?.vc?.showAlert(msg: result.msg ?? "유효하지않음")
                } else if result.cmd == "rcvToastMsg" {
                    self?.vc?.showToastmsg(msg: result.msg ?? "유효하지않음")
                } else if result.cmd == "rcvPlayLikeAni" {
                    self?.vc?.heartAnimation()
                } else {
                    print("유효하지 않은 입력입니다.")
                }
            } catch {
                print("err ==== \(error.localizedDescription)")
            }
            
        }
    }
    
    //MARK: 서버에 메세지 송신 (연결, 해지, 메세지, 좋아요)
    func establishConnection(cmd: String, mem_id: String, chat_name: String, mem_photo: String) {
        socket.connect()
        self.chat = []
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.socket.emitWithAck("message", ["cmd" : cmd, "mem_id" : mem_id, "chat_name" : chat_name, "mem_photo" : mem_photo]).timingOut(after: 0) { data in
                print("소켓 연결되었습니다. ****************************")
            }
        }
        
    }
    
    func closeConnection(cmd: String) {
        self.socket.emitWithAck("message", ["cmd": cmd]).timingOut(after: 0) { data in
            print("소켓 연결 해지되었습니다. ****************************")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.socket.disconnect()
            self.socket.removeAllHandlers()
        }
        
        chat.removeAll()
    }
    
    func sendLike() {
        socket.emit("message", ["cmd": "sendLike"])
    }
    
    func sendMessage(message: String, cmd: String) {
        socket.emit("message", ["cmd" : cmd, "msg" : message])
    }
}
