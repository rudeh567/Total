//
//  JoinCell.swift
//  Profile
//
//  Created by yeoboya on 2021/11/15.
//

import UIKit

class JoinCell: UITableViewCell {

    
    @IBOutlet weak var joinMessage: UILabel!
    @IBOutlet weak var joinView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = .clear
        
        self.joinView.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
