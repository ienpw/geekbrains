//
//  FriendsViewController.swift
//  weatherClient
//
//  Created by Inpu on 23.06.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import UIKit
import RealmSwift

class FriendsViewController: UITableViewController {

    let realm = try! Realm()
    var notificationToken: NotificationToken?
    var friends: Results<Friends>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFriends()
        refreshNetworkData()
    }
    
    // Получаем друзей из Realm
    func getFriends() {
        self.friends = realm.objects(Friends.self).sorted(byKeyPath: "lastName")
        
        notificationToken = friends.observe { (changes) in
            switch changes {
            case .initial:
                self.tableView.reloadData()
            case .update:
                self.tableView.reloadData()
            case .error(let error):
                print(error)
            }
        }
    }
    
    // Запрос к API VK
    func refreshNetworkData() {
        let service = VKService()
        service.getAllFriends() { (error) in
            // TODO: обработка ошибок
            if let error = error {
                print(error)
            }
        }
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
            }
        }
    }
}
