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
    
    func setupNews(news: News) {
        // аватар
        avatarImage.kf.setImage(with: URL(string: news.avatarImage))
        
        // делаем закругленные углы
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width / 2
        avatarImage.clipsToBounds = true
        
        // имя
        titleLabel.numberOfLines = 0
        titleLabel.text = news.profileName
        
        // картинка
        newsImage.kf.setImage(with: URL(string: news.attachments!.url))
        
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
