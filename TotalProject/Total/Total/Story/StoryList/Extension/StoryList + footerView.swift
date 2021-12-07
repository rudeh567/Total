//
//  StoryList + footerView.swift
//  Total
//
//  Created by yeoboya on 2021/12/01.
//

import Foundation
import UIKit

extension StoryList {
    // 테이블뷰를 스크롤 할떄 로딩 시간에 인디케이터가 보이도록 푸터뷰에 인디케이터를 설정합니다.
    func settingFooterView() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 60))
        let loadingBar = UIActivityIndicatorView()
        let safeArea = footerView.safeAreaLayoutGuide
        
        footerView.backgroundColor = UIColor.white
        footerView.addSubview(loadingBar)
        loadingBar.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        loadingBar.hidesWhenStopped = false
        loadingBar.translatesAutoresizingMaskIntoConstraints = false
        loadingBar.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        loadingBar.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
        loadingBar.startAnimating()
    
        tableView.tableFooterView = footerView
    }
}
