//
//  FriendsViewCell.swift
//  weatherClient
//
//  Created by Inpu on 23.06.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import UIKit
import Kingfisher

class FriendsViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    func setupFriends(_ friends: Friends) {
        // аватар
        avatarImage.kf.setImage(with: URL(string: friends.avatarImage))
        // делаем закругленные углы
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width / 2
        avatarImage.clipsToBounds = true

        // имя
        titleLabel.text = "\(friends.firstName) \(friends.lastName)"
    }
}
