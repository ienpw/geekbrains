//
//  NewsPhotoViewCell.swift
//  weatherClient
//
//  Created by Inpu on 06.08.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import UIKit

class NewsPhotoViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTextLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var repostsLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    func setupNews(news: News, cell: NewsPhotoViewCell, indexPath: IndexPath, tableView: UITableView) {
        // аватар
        avatarImage.kf.setImage(with: URL(string: news.avatarImage))
        
        // делаем закругленные углы
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width / 2
        avatarImage.clipsToBounds = true
        
        // имя
        titleLabel.numberOfLines = 0
        titleLabel.text = news.profileName
        
        // картинка
        let getCacheImage = GetCacheImage(url: news.attachments!.url)
        getCacheImage.completionBlock = {
            OperationQueue.main.addOperation {
                self.newsImage.image = getCacheImage.outputImage
            }
        }
    
        let setImageToRow = SetImageToRow(cell: cell, indexPath: indexPath, tableView: tableView)
        setImageToRow.addDependency(getCacheImage)
        queue.addOperation(getCacheImage)
        OperationQueue.main.addOperation(setImageToRow)
        
        //newsImage.kf.setImage(with: URL(string: news.attachments!.url))
        
        // текст
        newsTextLabel.text = news.text
        
        // лайки
        likesLabel.text = news.likes
        
        //комментарии
        commentsLabel.text = news.comments
        
        // репосты
        repostsLabel.text = news.reposts
        
        //просмотры
        viewsLabel.text = news.views
    }
}
