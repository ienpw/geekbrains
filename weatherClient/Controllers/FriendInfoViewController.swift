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
    
    var friend: Friends?
    var photos: [Photos] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title экрана
        self.title = "\(friend!.firstName) \(friend!.lastName)"
        
        let service = VKService()
        service.getFriendPhotos(userID: friend!.id) { (photos, error) in
            // TODO: обработка ошибок
            if let error = error {
                print(error)
            }
            // получили массив фотографий
            if let photos = photos {
                self.photos = photos
                // обновить tableView
                self.collectionView?.reloadData()
            }
        }
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendInfo", for: indexPath) as! FriendInfoViewCell
    
        // Configure the cell
        let photo = photos[indexPath.row]
        cell.setupPhoto(photo)
    
        return cell
    }
}
