//
//  AllGroupsViewController.swift
//  weatherClient
//
//  Created by Inpu on 24.06.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import UIKit

class AllGroupsViewController: UITableViewController {

    var groups: [(avatar: String, name: String)] = [
        (avatar: "groupAvatar", name: "Группа 1"),
        (avatar: "groupAvatar", name: "Группа 2"),
        (avatar: "groupAvatar", name: "Группа 3")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupsViewCell
        
        // получаем группу
        let group = groups[indexPath.row]
        cell.avatarImage.image = UIImage(named: group.avatar)
        cell.titleLabel.text = group.name
        
        return cell
    }
}
