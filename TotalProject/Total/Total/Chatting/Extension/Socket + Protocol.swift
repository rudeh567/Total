//
//  Socket + Protocol.swift
//  Total
//
//  Created by yeoboya on 2021/11/30.
//

import Foundation
import UIKit

extension SocketViewController: SocketOn {
    func showAlert(msg: String) {
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "예", style: .default, handler: nil)
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showToastmsg(msg: String) {
        showToast(message: msg)
    }
    
    func roomOut() {
        let alert = UIAlertController(title: "경고", message: "방에서 강퇴당했습니다.", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "예. 알겠습니다.", style: .default) { action in
            SocketIOManager.shared.socket.disconnect()
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //하트애니메이션 7번 출력
    func heartAnimation() {
        for _ in 1...7 {
            self.heartBeat()
        }
    }
}
