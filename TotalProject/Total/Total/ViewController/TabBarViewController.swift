//
//  TabBarViewController.swift
//  Total
//
//  Created by yeoboya on 2021/11/27.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        tabBarSetting()
    }
    
    //MARK: TabarSetting
    //탭바컨트롤러의 구성요소들을 정의했습니다.
    //스토리보드를 인스턴스화 하여 탭의 구성요소에 집어넣었습니다.
    func tabBarSetting() {
        guard let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as? MainViewController else { return }
        let mainBarItem = UITabBarItem(title: "MainView", image: UIImage(named: "user"), selectedImage: nil)
       
        mainView.tabBarItem = mainBarItem
        
        guard let webView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebView") as? WebViewController else { return }
        let webBarItem = UITabBarItem(title: "Login", image: UIImage(named: "login"), selectedImage: nil)
        
        webView.tabBarItem = webBarItem
        
        self.tabBar.tintColor = Color.periwinkleTwo
        self.viewControllers = [mainView, webView]
    }
    
    //MARK: TabBar Delegate
    //탭을 클릭할 시의 이벤트를 지정합니다.
    //탭을 클릭할 시 탭의 이름이 출력됨으로써 무슨 탭을 클릭했는지 알 수 있게 만들었습니다.
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("선택된 탭: \(viewController.title ?? "유효하지 않은 페이지")")
    }

}
