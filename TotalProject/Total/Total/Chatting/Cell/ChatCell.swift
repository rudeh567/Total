//
//  ChatCell.swift
//  Profile
//
//  Created by yeoboya on 2021/11/15.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var chatContent: UILabel!
    @IBOutlet weak var name: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = .clear
        self.chatView.layer.cornerRadius = 4
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
