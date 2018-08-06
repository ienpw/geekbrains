//
//  FriendInfoViewCell.swift
//  weatherClient
//
//  Created by Inpu on 24.06.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import UIKit

class FriendInfoViewCell: UICollectionViewCell {
    @IBOutlet weak var friendImage: UIImageView!
    
    func setupPhoto(_ photos: Photos) {
        // фото
        friendImage.kf.setImage(with: URL(string: photos.url))        
    }
}
