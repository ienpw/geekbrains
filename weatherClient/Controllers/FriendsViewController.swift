//
//  FriendsViewController.swift
//  weatherClient
//
//  Created by Inpu on 23.06.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import UIKit

class FriendsViewController: UITableViewController {
    
//    let friends: [(avatar: String, name: String)] = [
//        (avatar: "friendAvatar", name: "Вася"),
//        (avatar: "friendAvatar", name: "Петя"),
//        (avatar: "girlAvatar", name: "Маша")
//    ]
    
    var friends: [Friends] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let service = VKService()
        service.getAllFriends() { (friends, error) in
            // TODO: обработка ошибок
            if let error = error {
                print(error)
            }
            // получили массив друзей
            if let friends = friends {
                self.friends = friends
                // обновить tableView
                self.tableView?.reloadData()
            }
        }
        
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentsDirectory = paths[0]
//        print(documentsDirectory)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendsViewCell
        
        // получаем друга
        let friend = friends[indexPath.row]
        // выводим
        cell.setupFriends(friend)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let friendInfoViewController = segue.destination as? FriendInfoViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                // передаем id друга в FriendInfoViewController
                friendInfoViewController.friend = friends[indexPath.row]
                //friendInfoViewController.token = token
            }
        }
    }
}
