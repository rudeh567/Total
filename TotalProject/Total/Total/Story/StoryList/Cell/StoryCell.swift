//
//  StoryCell.swift
//  Total
//
//  Created by yeoboya on 2021/11/30.
//

import UIKit

class StoryCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var genderImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var storyView: UIView!
    @IBOutlet weak var story: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layoutSetting()
    }

    func layoutSetting() {
        storyView.layer.cornerRadius = 5
    
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.layer.borderWidth = Size.w1
        profileImage.clipsToBounds = true
        profileImage.layer.borderColor = Color.whiteFive.cgColor
    }
    
}
