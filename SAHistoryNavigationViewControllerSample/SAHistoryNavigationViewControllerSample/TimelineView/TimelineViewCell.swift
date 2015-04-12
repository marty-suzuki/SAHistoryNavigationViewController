//
//  TimelineViewCell.swift
//  SAHistoryNavigationViewControllerSample
//
//  Created by 鈴木大貴 on 2015/04/01.
//  Copyright (c) 2015年 &#37428;&#26408;&#22823;&#36020;. All rights reserved.
//

import UIKit
import QuartzCore

class TimelineViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var mainTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconImageView.layer.cornerRadius = 10
        iconImageView.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setIconImage(image: UIImage) {
        iconImageView.image = image
    }
    
    func setMainText(text: String) {
        mainTextLabel.text = text
    }
    
    func setUsername(name: String) {
        usernameLabel.text = name
    }
}
