//
//  NewsTableViewController.swift
//  weatherClient
//
//  Created by Inpu on 03.08.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import UIKit
import RealmSwift

class NewsViewController: UITableViewController {
    
    let realm = try! Realm()
    var notificationToken: NotificationToken?
    
    var news: [News] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 155
        
        loadData()
    }
    
    func loadData() {
        let service = VKService()
        service.getNewsFeed() { (news, error) in
            // TODO: обработка ошибок
            if let error = error {
                print(error)
                return
            }
            // получили массив новостей
            if let news = news {
                self.news = news
                // обновить tableView
                self.tableView?.reloadData()
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // получаем новость
        let newsItem = news[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsTextCell", for: indexPath) as! NewsTextViewCell
        
        // выводим
        cell.setupNews(news: newsItem)
        
        return cell
    }
}
