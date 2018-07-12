//
//  FriendInfoViewController.swift
//  weatherClient
//
//  Created by Inpu on 24.06.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "Cell"

class FriendInfoViewController: UICollectionViewController {
    
    let realm = try! Realm()
    var notificationToken: NotificationToken?
    var friend: Friends?
    var photos: Results<Photos>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title экрана
        self.title = "\(friend!.firstName) \(friend!.lastName)"
        
        getPhotos()
        refreshNetworkData()
    }
    
    // Получаем фотографии друга из Realm
    func getPhotos() {
        let userID = friend!.id
        self.photos = realm.objects(Photos.self).filter("userID = '" + userID + "'")
        
        notificationToken = photos.observe { (changes) in
            switch changes {
            case .initial:
                self.collectionView?.reloadData()
            case .update:
                self.collectionView?.reloadData()
            case .error(let error):
                print(error)
            }
        }
    }
    
    // Запрос к API VK
    func refreshNetworkData() {
        let service = VKService()
        let userID = friend!.id
        service.getFriendPhotos(userID: userID) { (error) in
            // TODO: обработка ошибок
            if let error = error {
                print(error)
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
