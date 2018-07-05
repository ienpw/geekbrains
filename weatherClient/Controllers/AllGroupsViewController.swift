//
//  AllGroupsViewController.swift
//  weatherClient
//
//  Created by Inpu on 24.06.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import UIKit

class AllGroupsViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var groups: [Groups] = []
    let service = VKService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupsViewCell
        
        // получаем группу
        let group = groups[indexPath.row]
        // выводим
        cell.setupGroups(group)
        
        return cell
    }
    
    // Search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text, !text.isEmpty else {
            self.groups.removeAll()
            self.tableView?.reloadData()
            
            return
        }
        
        service.searchGroups(query: text) { (groups, error) in
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
}
