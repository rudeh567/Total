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
import Lottie

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
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    var animation: [UIViewPropertyAnimator] = []
    var totalAnimation: [UIViewPropertyAnimator] = []
    var animationView: [AnimationView?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetting()
        keyboardSetting()
        webPSetting()
        
        SocketIOManager.shared.vc = self
        SocketIOManager.shared.socketOn()
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
    func heartBeat(cnt: Int) {
        guard let path = Bundle.main.path(forResource: "an_like_0\(Int.random(in: 1...5))", ofType: "webp") else { return }
        let url = NSURL(fileURLWithPath: path)
        let imageView = UIImageView()
        imageView.sd_setImage(with: url as URL)

        imageView.frame.size = CGSize(width: 50, height: 50)
        imageView.frame.origin = CGPoint(x: Int.random(in: 0...60), y: Int(self.view.frame.height) - Int.random(in: 0...80))
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        
        let startFrame = imageView.frame.size
        let startPoint = imageView.frame.origin
        let duration = Double.random(in: 5.5...6.0)
        
        self.view.addSubview(imageView)
        let damping = 0.7
        let distance = 30.0
        
        let spring = UIViewPropertyAnimator(duration: 9, dampingRatio: damping) {
            imageView.transform = CGAffineTransform(translationX: 0, y: self.calDelayFactory(delayFactor: 0, distance: distance, preDistance: distance, sec: 0.2, damping: 0))
        }
        spring.addAnimations({
            imageView.transform = CGAffineTransform(translationX: 0, y: self.calDelayFactory(delayFactor: 0.2, distance: distance, preDistance: -distance, sec: 0.2, damping: 0))
        }, delayFactor: 0.2)
        spring.addAnimations({
            imageView.transform = CGAffineTransform(translationX: 0, y: self.calDelayFactory(delayFactor: 0.4, distance: distance, preDistance: distance, sec: 0.2, damping: 0))
        }, delayFactor: 0.4)
        spring.addAnimations({
            imageView.transform = CGAffineTransform(translationX: 0, y: self.calDelayFactory(delayFactor: 0.6, distance: distance, preDistance: -distance, sec: 0.2, damping: damping))
        }, delayFactor: 0.6)
        spring.addCompletion { _ in
            UIView.animate(withDuration: 1, delay: 0, options: []) {
                imageView.alpha = 0.015
            } completion: { _ in
                imageView.removeFromSuperview()
            }
        }
        spring.isUserInteractionEnabled = false
        
        animationView.append(AnimationView(name: "ani_live_like_full"))
        animationView[cnt]?.contentMode = .scaleAspectFill
        animationView[cnt]?.loopMode = .repeat(3)
        animationView[cnt]?.frame.size = startFrame
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            let x = startPoint.x + CGFloat(Int.random(in: -75...75))
            let y = CGFloat(startPoint.y - CGFloat(Int.random(in: 100...150)))
                                                   
            imageView.frame.origin = CGPoint(x: x, y: y)

            imageView.alpha = 1
        }
        animator.addAnimations {
            let x = startPoint.x + CGFloat(Int.random(in: -75...75))
            let y = CGFloat(startPoint.y - CGFloat(Int.random(in: 250...300)))
            let width = startFrame.width + CGFloat(Int.random(in: 20...30))
            let height = startFrame.height + CGFloat(Int.random(in: 20...30))
                                                   
            imageView.frame = CGRect(x: x, y: y, width: width, height: height)
                                                   
            self.animationView[cnt]?.frame = CGRect(x: x, y: y, width: width, height: height)
        }
        animator.addAnimations {
            let x = startPoint.x + CGFloat(Int.random(in: -75...75))
            let y = CGFloat(Int.random(in: 0...80))
            let width = startFrame.width + CGFloat(Int.random(in: 20...30)) + 20
            let height = startFrame.height + CGFloat(Int.random(in: 20...30)) + 20
                                                   
            imageView.frame = CGRect(x: x, y: y, width: width, height: height)
        }
        animator.addAnimations {
            imageView.transform = CGAffineTransform(rotationAngle: .pi)
            imageView.transform = CGAffineTransform(rotationAngle: .pi * 2.0)
            imageView.transform = CGAffineTransform(rotationAngle: .pi)
            imageView.transform = CGAffineTransform(rotationAngle: .pi * 2.0)
            imageView.transform = CGAffineTransform(rotationAngle: .pi)
            imageView.transform = CGAffineTransform(rotationAngle: .pi * 2.0)
            imageView.transform = CGAffineTransform(rotationAngle: .pi)
            imageView.transform = CGAffineTransform(rotationAngle: .pi * 2.0)
        }
        animator.addCompletion { _ in
            spring.startAnimation()
        }
        
        let heartTapGesture = CustomTapGesture(target: self, action: #selector(touchImage(gesture:)))
        heartTapGesture.cnt = cnt
        heartTapGesture.image.append(imageView)
        imageView.addGestureRecognizer(heartTapGesture)
        
        animation.append(animator)
        animator.startAnimation()
    }
    
    func calDelayFactory(delayFactor: Double, distance: Double, preDistance: Double, sec: Double, damping: Double) -> Double {
        let perfectAnimate = (sec * 10) / (10 - delayFactor * 10) * distance * (damping + 1) + preDistance
        return perfectAnimate
    }
    
    @objc func touchImage(gesture: CustomTapGesture) {
        guard let cnt = gesture.cnt else {
            return
        }
        animation[cnt].pauseAnimation()
        gesture.image[0]?.addSubview(self.animationView[cnt]!)
        animationView[cnt]?.play(completion: { _ in
            UIView.animate(withDuration: 1, delay: 0, options: []) {
                gesture.image[0]?.alpha = 0.015
            } completion: { _ in
                gesture.image[0]?.removeFromSuperview()
            }
        })
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





