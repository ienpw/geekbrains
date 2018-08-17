//
//  NewsTableViewController.swift
//  weatherClient
//
//  Created by Inpu on 03.08.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import UIKit
//import RealmSwift

class NewsViewController: UITableViewController {
    
    //let realm = try! Realm()
    //var notificationToken: NotificationToken?
    
    var news: [News] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        if newsItem.type == "post" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsTextCell", for: indexPath) as! NewsTextViewCell
            cell.setupNews(news: newsItem, cell: cell, indexPath: indexPath, tableView: tableView)
        
            tableView.rowHeight = newsItem.cellHeight
        
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsPhotoCell", for: indexPath) as! NewsPhotoViewCell
            cell.setupNews(news: newsItem, cell: cell, indexPath: indexPath, tableView: tableView)
            
            tableView.rowHeight = newsItem.cellHeight
            
            return cell
        }
        
//        if newsItem.attachments == nil {
//            //tableView.rowHeight = UITableViewAutomaticDimension
//            //tableView.estimatedRowHeight = 155
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "newsTextCell", for: indexPath) as! NewsTextViewCell
//            cell.setupNews(news: newsItem)
//            tableView.rowHeight = cell.cellHeight
//
//            return cell
//        }
//        else {
//            tableView.rowHeight = 350
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "newsPhotoCell", for: indexPath) as! NewsPhotoViewCell
//
//            cell.setupNews(news: newsItem, cell: cell, indexPath: indexPath, tableView: tableView)
//
//            return cell
//        }
    }
}
