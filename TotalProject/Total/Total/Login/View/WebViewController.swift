//
//  WebViewController.swift
//  Total
//
//  Created by yeoboya on 2021/11/27.
//

import UIKit
import WebKit
import SwiftyJSON
import XHQWebViewJavascriptBridge
import Alamofire
import NaverThirdPartyLogin
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var chatButton: UIButton!
    
    var bridge: WKWebViewJavascriptBridge!
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    let viewModel = WebViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUrl()
        bridgeSetting()
        self.chatButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loadUrl() {
        view.addSubview(webView)
        
        let url = URL(string: "http://babyhoney.kr/login")
        let request = URLRequest(url: url!)
        
        webView.load(request)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        loginInstance?.delegate = self
        self.loginInstance?.requestDeleteToken()
    }
    
    //MARK: 멤버인가?
    //login해서 정보를 가져오고 나서 그 이메일로 서버에 요청을 보내어 멤버인지 아닌지 확인합니다. 멤버라면 멤버리스트 뷰를 띄우고 멤버가 아니라면 회원가입 뷰를 띄우도록 합니다.
    func isMember(email: String) {
        let urlStr = "http://babyhoney.kr/api/member/\(email)"
        let url = URL(string: urlStr)!
        
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
        
        req.responseJSON { [weak self] response in
            guard let self = self else { return }
        
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                guard let check = json["is_member"].bool else { return }
                
                if check {
                    guard let email = json["mem_info"]["email"].string,
                          let name = json["mem_info"]["name"].string,
                          let photo = json["mem_info"]["profile_image"].string else { return }
            
                    guard let reUrl = json["redirect_url"].string else { return }
                    let url = URL(string: "http://babyhoney.kr\(reUrl)/\(email)")
                    let request = URLRequest(url: url!)
                        
                    self.viewModel.loginEmail = email
                    self.viewModel.userInfo.email = email
                    self.viewModel.userInfo.name = name
                    self.viewModel.userInfo.photo = photo
                    
                    self.webView.load(request)
                    self.chatButton.isHidden = false
                } else {
                    print("회원가입 화면으로 이동합니다 - - - - -")
                    guard let signUpVc = UIStoryboard(name: "Member", bundle: nil).instantiateViewController(withIdentifier: "SignView") as? SignViewController else { return }
                    
                    signUpVc.email = email
                    
                    signUpVc.modalPresentationStyle = .fullScreen
                    self.present(signUpVc, animated: true, completion: nil)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    //MARK: 브릿지 세팅
    //카카오 로그인이나 네이버 로그인 버튼을 눌렀을 시 api를 호출할 수 있도록 브릿지로 이벤트를 가져옵니다.
    func bridgeSetting() {
        bridge = WKWebViewJavascriptBridge.bridge(forWebView: webView!)
        bridge?.registerHandler(handlerName: "$.callFromWeb", handler: { [weak self] data, responseCallback in
            guard let self = self else { return }
            
            if String(describing: data).contains("loginNaver") {
                self.loginInstance?.requestThirdPartyLogin()
            } else if String(describing: data).contains("loginKakao") {
                if (UserApi.isKakaoTalkLoginAvailable()) {
                    UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                        if let error = error {
                            print("err ==== \(error)")
                        }
                        else {
                            print("loginWithKakaoTalk() success")
                            self.getKakaoInfo(completion: {hk in
                                self.isMember(email: hk)
                            })
                        }
                    }
                } else {
                    UserApi.shared.loginWithKakaoAccount(prompts: [.Login]) { oauthToken, error in
                        if let err = error {
                            print("login error === \(err.localizedDescription)")
                        } else {
                            print("login successed")
                            self.getKakaoInfo(completion: self.isMember)
                        }
                    }
                }
            } else {
                let json = JSON(data)
                guard let cmd = json["cmd"].string,
                      let userInfo = json["userInfo"].string else { return }
                if cmd == "open_profile" {
                    guard let profileVc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "Profile") as? ProfileViewController else { return }
                        
                    self.viewModel.userInfo.email = userInfo
                    profileVc.isMemberList = true
                        
                    profileVc.modalPresentationStyle = .overFullScreen
                    self.present(profileVc, animated: true, completion: nil)
                }
            }
        })
    }
    
    @IBAction func joinChat(_ sender: Any) {
        let chatVc = UIStoryboard(name: "Chatting", bundle: nil).instantiateViewController(withIdentifier: "chat") as! SocketViewController
        
        SocketIOManager.shared.establishConnection(cmd: "reqRoomEnter", mem_id: viewModel.loginEmail!, chat_name: viewModel.userInfo.name!, mem_photo: viewModel.userInfo.photo!)
        
        chatVc.modalPresentationStyle = .overFullScreen
        self.present(chatVc, animated: true, completion: nil)
    }
    
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
}
