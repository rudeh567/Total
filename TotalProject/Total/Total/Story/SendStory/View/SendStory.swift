//
//  SendStory.swift
//  Total
//
//  Created by yeoboya on 2021/11/29.
//

import Foundation
import UIKit

class SendStory: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var costsCount: UILabel!
    @IBOutlet weak var costsView: UIView!
    @IBOutlet weak var costs: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var contentViewBottom: NSLayoutConstraint!
    
    let viewModel = SendViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
        viewSetting()
        shadowSetting()
        textViewSetting()
        keyboardSetting()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
        viewSetting()
        shadowSetting()
        textViewSetting()
        keyboardSetting()
    }
    
    private func loadView() {
        let nibs = Bundle.main.loadNibNamed("SendStory", owner: self, options: nil)
        
        guard let view = nibs?.first as? UIView else {
            print("nib error *********")
            return
        }

        view.frame = self.bounds
        self.addSubview(view)
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        costs.resignFirstResponder()
    }
    
    // 텍스뷰에 들어가 있는 글자가 10글자가 넘었을때 호출되는 함수로 버튼에 색을 입히고 활성화한다.
    func btnOn() {
        self.sendButton.isEnabled = true
        self.sendButton.applyGradient(colours: [Color.periwinkle,Color.periwinkleTwo])
    }
    
    // 텍스트뷰에 들어가 있는 글자가 10글자가 넘지 않았을 때 호출되는 함수로 버튼이 비활성화되고 입혀져있는 그라데이션을 벗긴다.
    func btnOff() {
        self.sendButton.isEnabled = false
        if let sublayer = self.sendButton.layer.sublayers {
            for layer in sublayer {
                if layer.name == "grad" {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.dimissAni(y: 0)
    }
    
    // 전송 버튼을 눌렀을 시 텍스트 뷰를 초기화하고 사연 보내기 뷰를 내립니다.
    @IBAction func sendText(_ sender: Any) {
        viewModel.dataSend(storys: costs.text)
        costs.text = nil
        textViewSetting()
      
        self.costs.resignFirstResponder()
        self.dimissAni(y: 0)
        self.costsCount.text = "(0/300)"
        self.btnOff()
    }
}
