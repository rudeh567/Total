//
//  DataString.swift
//  Total
//
//  Created by yeoboya on 2021/11/30.
//

import Foundation

// String을 날짜값으로 변환해줍니다. 우리는 이것으로 우리가 데이터를 보낸시간과 현재 시간의 시간차를 분석하여 출력해줄 수 있습니다.
extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        if let date = dateFormatter.date(from: self) {
            if date.timeIntervalSinceNow <= 600 {
                return date
            } else {
                return Date(timeIntervalSince1970: 0)
            }
        } else {
            return nil
        }
    }
}

// 변환된 날짜를 다시 String 값으로 변환하여 리턴합니다. 현재와의 시간차가 10분 이상이라면 "옛날옛적에"를 반환합니다.
extension Date {
    func toString() -> String? {
        if self.timeIntervalSinceNow >= -600 {
            if #available(iOS 13.0, *) {
                let formatter = RelativeDateTimeFormatter()
                
                formatter.locale = Locale(identifier: "ko_KR")
                let dateString = formatter.localizedString(for: self, relativeTo: Date())
                
                return dateString
            } else {
                let now = Date()
                
                guard let sinceDateSec = Calendar.current.dateComponents([.second], from: self, to: now).second else { return "error" }
                guard let sinceDateMin = Calendar.current.dateComponents([.minute], from: self, to: now).minute else { return "error" }
                if sinceDateSec < 60 {
                    let dateString = "\(sinceDateSec)초전"
                    
                    return dateString
                }
                else if sinceDateSec > 60 && sinceDateSec < 660 {
                    let dateString = "\(sinceDateMin)분전"
                    
                    return dateString
                }
                else { print("date error") }
            }
        } else {
            return "옛날옛적에"
        }
        return "제로"
    }
}
