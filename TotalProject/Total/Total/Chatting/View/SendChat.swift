//
//  SendChat.swift
//  Profile
//
//  Created by yeoboya on 2021/11/12.
//

import Foundation
import UIKit
import Lottie

class SendChat: UIView {
    
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var textViewContent: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var sendLike: UIButton!
    
    var animationView: AnimationView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
        textViewSetting()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
        textViewSetting()
       
    }
    
    private func loadView() {
        let nibs = Bundle.main.loadNibNamed("SendChat", owner: self, options: nil)
        
        guard let view = nibs?.first as? UIView else {
            print("error")
            return
        }
        
        view.frame = self.bounds
        
        if let image = UIImage(named: "btn_bt_send") {
            sendButton.setImage(image, for: .normal)
        }
        
        self.sendButton.isHidden = true
        self.addSubview(view)
        
        lottiAnimation()
        animationView?.play()
    }
    
    func lottiAnimation() {
        animationView = AnimationView(name: "ani_live_like_full") // AnimationView(name: "lottie json 파일 이름")으로 애니메이션 뷰 생성
        animationView?.frame = CGRect(x: self.sendLike.frame.origin.x, y: self.sendLike.frame.origin.y - 21, width: self.sendLike.frame.width, height: self.sendLike.frame.height)  // 애니메이션뷰의 크기 설정
        animationView?.contentMode = .scaleAspectFill // 애니메이션뷰의 콘텐트모드 설정
        animationView?.loopMode = .loop
        sendLike.addSubview(animationView!) // 애니메이션뷰를 메인뷰에 추가
            
        animationView?.isUserInteractionEnabled = false
    }
    
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.frame.size.width/2 - 75, y: self.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.addSubview(toastLabel)
        
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in toastLabel.removeFromSuperview() }) }
    
    @IBAction func clickLike(_ sender: Any) {
        SocketIOManager.shared.sendLike()
        
        self.sendLike.isEnabled = false
        animationView?.stop()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.sendLike.isEnabled = true
            self.animationView?.play()
        }
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        
        if textViewContent.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showToast(message: "내용이 없습니다.")
        } else {
            SocketIOManager.shared.sendMessage(message: self.textViewContent.text.trimmingCharacters(in: .whitespacesAndNewlines) , cmd: "sendChatMsg")
            textViewContent.text = nil
        }
    }
}

extension SendChat: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textViewContent.frame.size.width
        let newSize = textViewContent.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textViewContent.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
    }
    
    func newLineCounting(textView: UITextView) -> Int {
        return textView.text.count - textView.text.replacingOccurrences(of: "\n", with: "").count
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let str = textView.text else { return true }
        let newLength = str.count + text.count - range.length
        
        if newLength > 100 || newLineCounting(textView: textViewContent) >= 4 && text == "\n" {
            return false
        }
        
        return true
    }
    
    func textViewSetting() {
        textView.layer.cornerRadius = 18
        textViewContent.textContainerInset = .zero
        
        textViewContent.delegate = self
        textViewContent.text = nil
        textViewContent.text = "대화를 입력하세요"
        textViewContent.textColor = UIColor.lightGray
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textViewContent.textColor == UIColor.lightGray {
            textViewContent.text = nil
            textViewContent.textColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1)
        }
        
        sendButton.isHidden = false
        
        UIView.animate(withDuration: 0.2) {
            self.stackView.layoutIfNeeded()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textViewContent.text.isEmpty {
            textViewContent.text = "대화를 입력하세요"
            textViewContent.textColor = UIColor.lightGray
            
            UIView.animate(withDuration: 0.2) {
                self.sendButton.isHidden = true
                self.stackView.layoutIfNeeded()
            }
        }
    }
}
