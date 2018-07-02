//
//  MyGroupsViewController.swift
//  weatherClient
//
//  Created by Inpu on 24.06.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import UIKit

class MyGroupsViewController: UITableViewController, TokenViewController {
    
    //var groups: [(avatar: String, name: String)] = []
    var token: String?
    var groups: [Groups] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let service = VKService(token: token)
        service.getMyGroups() { (groups, error) in
            // TODO: обработка ошибок
            if let error = error {
                print(error)
            }
            // получили массив групп
            if let groups = groups {
                self.groups = groups
                // обновить tableView
                self.tableView?.reloadData()
            }
        }
    }
    
    @IBAction func addGroup(_ segue: UIStoryboardSegue) {
        guard let allGroupsViewController = segue.source as? AllGroupsViewController else {
            return
        }
        
        // получаем индекс нажатой строки в AllGroupsViewController
        if let indexPath = allGroupsViewController.tableView.indexPathForSelectedRow {
            // получаем группу из массива в AllGroupsViewController
            // и удаляем ее, т.к. добавить группу можно только один раз,
            // но я не понял как обновить tableView, чтобы удаленная группа
            // перестала отображаться в таблице
//            let group = allGroupsViewController.groups.remove(at: indexPath.row)
            // добавляем полученную группу в массив в MyGroupsViewController
//            groups.append(group)
            // обновляем таблицу
            tableView.reloadData()
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
