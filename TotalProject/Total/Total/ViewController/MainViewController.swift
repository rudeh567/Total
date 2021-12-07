//
//  ViewController.swift
//  Total
//
//  Created by yeoboya on 2021/11/27.
//

import UIKit

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: 프로필 띄우기
    //ProfileViewController의 인스턴스를 생성하여 프레젠트합니다.
    @IBAction func showProfile(_ sender: Any) {
        guard let profileVc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "Profile") as? ProfileViewController else { return }
        
        profileVc.modalPresentationStyle = .overFullScreen
        self.present(profileVc, animated: true, completion: nil)
    }
    
    //MARK: 사연 리스트
    @IBAction func showList(_ sender: Any) {
        let view = StoryList()
        view.frame = UIScreen.main.bounds
        view.showAni(y: 0)
        view.dataReceive(page: 1)
        
        self.view.addSubview(view)
    }
    
}

