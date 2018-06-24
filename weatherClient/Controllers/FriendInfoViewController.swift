//
//  FriendInfoViewController.swift
//  weatherClient
//
//  Created by Inpu on 24.06.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FriendInfoViewController: UICollectionViewController {
    
    var friend: (avatar: String, name: String) = ("","")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = friend.name
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendInfo", for: indexPath) as! FriendInfoViewCell
    
        // Configure the cell
        cell.friendName.text = friend.name
        cell.friendImage.image = UIImage(named: friend.avatar)
    
        return cell
    }
}
