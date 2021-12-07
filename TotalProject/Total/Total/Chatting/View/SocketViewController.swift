//
//  SocketViewController.swift
//  Total
//
//  Created by yeoboya on 2021/11/30.
//

import UIKit
import SocketIO
import Kingfisher
import SDWebImageWebPCoder
import Alamofire

class SocketViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendChatConstant: NSLayoutConstraint!
    @IBOutlet weak var sendChat: SendChat!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var scrollButton: UIButton!
    
    var socket: SocketIOClient!
    var chat: [Chat] = []
    let userInfo = UserInfo.shared
    
    var cellHeights: [IndexPath : CGFloat] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetting()
        keyboardSetting()
        webPSetting()
        
        SocketIOManager.shared.vc = self
        SocketIOManager.shared.socketOn()
        
        print(SocketIOManager.shared.socket.handlers)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        blurSetting()
    }
    
    //MARK: 서버에서 수신받은 이벤트 실행
    func showChat(chat: [Chat]?) {
        guard let chat = chat else {
            return
        }
        self.chat = chat
        self.tableView.reloadData()
    }
    
    //MARK: 좋아요 누를 때 하트 애니메이션 설정
    func heartBeat() {
        guard let path = Bundle.main.path(forResource: "an_like_0\(Int.random(in: 1...5))", ofType: "webp") else { return }
        let url = NSURL(fileURLWithPath: path)
        let imageView = UIImageView()
        imageView.sd_setImage(with: url as URL)
        
        imageView.frame.size = CGSize(width: 50, height: 50)
        imageView.frame.origin = CGPoint(x: Int.random(in: 0...60), y: Int(self.view.frame.height) - Int.random(in: 0...80))
        imageView.alpha = 0
        
        let startFrame = imageView.frame.size
        let startPoint = imageView.frame.origin
        let duration = Double.random(in: 5.5...6.0)
        
        self.view.addSubview(imageView)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModePaced) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration * 0.15) {
                imageView.frame.origin = CGPoint(x: startPoint.x + CGFloat(Int.random(in: -75...75)), y: CGFloat(startPoint.y - CGFloat(Int.random(in: 100...150))))
                imageView.alpha = 1
            }
            
            UIView.addKeyframe(withRelativeStartTime: duration * 0.15, relativeDuration: duration * 0.55) {
                imageView.frame = CGRect(x: startPoint.x + CGFloat(Int.random(in: -75...75)), y: CGFloat(startPoint.y - CGFloat(Int.random(in: 250...300))), width: startFrame.width + CGFloat(Int.random(in: 20...30)), height: startFrame.height + CGFloat(Int.random(in: 20...30)))
            }
            
            UIView.addKeyframe(withRelativeStartTime: duration * 0.7, relativeDuration: duration * 0.3) {
                imageView.frame = CGRect(x: startPoint.x + CGFloat(Int.random(in: -75...75)), y: CGFloat(Int.random(in: 0...80)), width: startFrame.width + CGFloat(Int.random(in: 20...30)) + 20, height: startFrame.height + CGFloat(Int.random(in: 20...30)) + 20)
                imageView.alpha = 0
            }
        } completion: { res in
            imageView.removeFromSuperview()
        }
    }
    
    //스크롤 중일경우 내려가기 버튼 출력, 버튼 누를시 맨 아래로 내려감
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollButton.isHidden = scrollView.contentOffset.y == 0
    }
    
    @IBAction func clickDown(_ sender: Any) {
        tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    //MARK: TableView Setting
    func tableViewSetting() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        
        let nibName = UINib(nibName: "JoinCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "joincell")
        
        let nibName2 = UINib(nibName: "ChatCell", bundle: nil)
        tableView.register(nibName2, forCellReuseIdentifier: "chat")
    }
    
    //MARK: 미니프로필 프레젠트
    @objc func openProfile(_ sender: AnyObject) {
        let urlStr = "http://babyhoney.kr/api/member/\(self.chat[sender.view!.tag].mem_id!)"
        let url = URL(string: urlStr)
        
        let req = AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default)
        
        req.responseJSON { response in
            guard let profileVc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "Profile") as? ProfileViewController else { return }
            
            self.userInfo.email = self.chat[sender.view!.tag].mem_id!
            profileVc.isMemberList = true
            
            profileVc.modalPresentationStyle = .overFullScreen
            self.present(profileVc, animated: true, completion: nil)
        }
    }
    
    // 소켓 해제
    @IBAction func disconnectSocket(_ sender: Any) {
        SocketIOManager.shared.closeConnection(cmd: "reqRoomOut")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: 키보드 세팅
    @IBAction func dismissKeyboard(_ sender: Any) {
        sendChat.textViewContent.resignFirstResponder()
    }
    
    func keyboardSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(_sender: Notification) {
        sendChatConstant.constant = 0
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            self.sendChatConstant.constant = keyboardHeight - self.view.safeAreaInsets.bottom
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    //MARK: WebP 세팅
    func webPSetting() {
        let webp = SDImageWebPCoder.shared
        SDImageCodersManager.shared.addCoder(webp)
    }
    
    //MARK: 블러세팅
    func blurSetting() {
        blurView.applyGradient2(colours: [UIColor.black.withAlphaComponent(1), UIColor.black.withAlphaComponent(0)], locations: [0, 1], width: self.blurView.frame.width, height: self.blurView.frame.height)
    }
    
    //MARK: 토스트메시지 설정
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 0, height: 0))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        
        toastLabel.font = UIFont.systemFont(ofSize: 12)
        toastLabel.text = message
        toastLabel.sizeToFit()
        
        toastLabel.center.x = self.view.center.x
        toastLabel.center.y = self.view.frame.height - 100
        
        toastLabel.frame.size = CGSize(width: toastLabel.frame.width + 15, height: toastLabel.frame.height + 15)
        toastLabel.textAlignment = .center
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 15
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in toastLabel.removeFromSuperview() }) }
    
}



