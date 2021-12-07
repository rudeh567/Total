//
//  Socket + tableView.swift
//  Total
//
//  Created by yeoboya on 2021/11/30.
//

import Foundation
import UIKit

extension SocketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //시스템 메세지를 받을 경우와 채팅을 받았을 경우를 나눠서 다른 셀이 나오도록 나눠주었습니다.
        if self.chat[indexPath.row].cmd == "rcvSystemMsg" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "joincell", for: indexPath) as? JoinCell
            
            cell?.joinMessage.text = self.chat[indexPath.row].msg
            
            tableView.transform = CGAffineTransform(rotationAngle: (-.pi))
            cell?.transform = CGAffineTransform(rotationAngle: (-.pi))
            
            return cell ?? UITableViewCell()
        } else {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "chat", for: indexPath) as? ChatCell
            let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(openProfile(_:)))
            
            cell2?.chatContent.text = self.chat[indexPath.row].msg
            cell2?.name.text = self.chat[indexPath.row].chat_name
            cell2?.profileImage.kf.setImage(with: URL(string: self.chat[indexPath.row].mem_photo!), placeholder: UIImage(named: "img_default_s"))
            
            cell2?.profileImage.isUserInteractionEnabled = true
            cell2?.profileImage.tag = indexPath.row
            cell2?.profileImage.addGestureRecognizer(tapGestureReconizer)
            
            tableView.transform = CGAffineTransform(rotationAngle: (-.pi))
            cell2?.transform = CGAffineTransform(rotationAngle: (-.pi))
            
            return cell2 ?? UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat.count
    }
}
