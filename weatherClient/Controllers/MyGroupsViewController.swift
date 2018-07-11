//
//  MyGroupsViewController.swift
//  weatherClient
//
//  Created by Inpu on 24.06.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import UIKit

class MyGroupsViewController: UITableViewController {
    
    var groups: [Groups] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    func loadData() {
        let service = VKService()
        service.getMyGroups() { (groups, error) in
            // TODO: обработка ошибок
            if let error = error {
                print(error)
                return
            }
            // получили массив групп
            if let groups = groups {
                self.groups = groups
                // обновить tableView
                self.tableView?.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! MyGroupsViewCell
        
        // получаем группу
        let group = groups[indexPath.row]
        // выводим
        cell.setupGroups(group)
        
        return cell
    }
    
    // Удаление группы
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
