//
//  TextView.swift
//  Total
//
//  Created by yeoboya on 2021/11/29.
//

import Foundation
import UIKit

extension SendStory: UITextViewDelegate {
    // textView의 글자수를 제한하고 레이블로 출력해주는 함수입니다.
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let str = textView.text else { return true }
        let newLength = str.count + text.count - range.length
        
        costsCount.text = "(\(newLength)/300)"
        
        if newLength <= 10 {
            btnOff()
        } else {
            btnOn()
        }
        return newLength < 300
    }
    
    // textView에 없는 기능인 placeholder를 딜리게이트를 이용하여 구현해주었습니다.
    func textViewSetting() {
        costs.delegate = self
        costs.text = nil
        costs.text = "10자 이상 300자 이내로 작성해주세요"
        costs.textColor = UIColor.lightGray
    }
    
    // 텍스트 뷰에 커서가 올라가면 플레이스 홀더를 없애고 폰트 색을 검정색으로 바꿉니다.
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    // 텍스트 뷰에서 커서가 빠지면 다시 플레이스 홀더를 회색으로 출력합니다.
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.text = "10자 이상 300자 이내로 작성해주세요 "
        textView.textColor = UIColor.lightGray
    }
}
