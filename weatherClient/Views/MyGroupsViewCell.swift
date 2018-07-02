//
//  MyGroupsViewCell.swift
//  weatherClient
//
//  Created by Inpu on 24.06.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import UIKit

class MyGroupsViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    func setupGroups(_ groups: Groups) {
        // аватар
        avatarImage.kf.setImage(with: URL(string: groups.avatarImage))
        // делаем закругленные углы
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width / 2
        //avatarImage.clipsToBounds = true
        
        // имя
        titleLabel.numberOfLines = 0
        titleLabel.text = groups.name
    }
}
