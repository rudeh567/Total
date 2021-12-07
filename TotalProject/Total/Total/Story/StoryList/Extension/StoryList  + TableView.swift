//
//  File.swift
//  Total
//
//  Created by yeoboya on 2021/11/30.
//

import Foundation
import UIKit

extension StoryList: UITableViewDelegate, UITableViewDataSource {
    
    // 테이블 리스트 셀을 내가 커스텀한 셀로 설정합니다.
    func tableViewSetting() {
        tableView.register(UINib(nibName: "StoryCell", bundle: nil), forCellReuseIdentifier: "StoryCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
    }
    
    // 스크롤이 됐을때 호출되는 함수입니다.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 스크롤이 마지막에 도달했을 때 호출합니다. 테이블뷰의 현재 y좌표와 테이블뷰 전체 사이즈와 현재 사이즈를 뺀 값을 비교하여 마지막인지 알아냅니다.
        if self.tableView.contentOffset.y > tableView.contentSize.height-tableView.bounds.size.height {
            paging()
        }
    }
    
    // 테이블뷰 셀의 갯수를 정의합니다.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.detailInfo.count
    }
    
    // 셀을 어떻게 표시할지 정의합니다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: StoryCell = tableView.dequeueReusableCell(withIdentifier: "StoryCell", for: indexPath) as? StoryCell else { return UITableViewCell() }
     
        cell.layoutSetting()
        let info = viewModel.detailInfo[indexPath.row]
        cell.story.text = info.story_conts
        cell.name.text = info.send_chat_name
        cell.profileImage.kf.setImage(with: URL(string: info.send_mem_photo), placeholder: UIImage(named: "img_default_s"))
        cell.genderImage.image = UIImage(named: info.send_mem_gender == "F" ? "badge_sex_fm" : "badge_sex_m")
        cell.date.text = info.ins_date.toDate()?.toString()
        
        return cell
    }
}
