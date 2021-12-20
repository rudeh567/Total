//
//  Socket + Notification.swift
//  Total
//
//  Created by yeoboya on 2021/12/08.
//

import Foundation
import UserNotifications

extension SocketViewController {
    //MARK: 사용자가 입장할때, 좋아요를 누를 떄 notification으로 푸쉬알림이 뜨게하였다.
    func notiSetting(msg: String) {
        requestNotificationAuthoriztion()
        sendNotification(seconds: 2, msg: msg)
    }
    
    // 사용자에게 알림 권한을 요쳥합니다.
    func requestNotificationAuthoriztion() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        
        userNotificationCenter.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    // 푸쉬알림의 내용을 설정하고 언제뜰 것인가 등을 설정한다.
    func sendNotification(seconds: Double, msg: String) {
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = "시스템 알림"
        notificationContent.body = msg
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification", content: notificationContent, trigger: trigger)
        
        userNotificationCenter.add(request) { error in
            if let error = error {
                print("Notification Error: \(error)")
            }
        }
    }
}
