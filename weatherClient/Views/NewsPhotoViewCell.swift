//
//  NewsPhotoViewCell.swift
//  weatherClient
//
//  Created by Inpu on 16.08.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import UIKit

class NewsPhotoViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView! {
        didSet {
            avatarImage.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var newsImage: UIImageView! {
        didSet {
            newsImage.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    let margin: CGFloat = 16.0
    let avatarSize: CGFloat = 64.0
    let titleHeight: CGFloat = 21.0
    var imageSize: (width: Int, height: Int) = (0, 0)
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    // Установка аватара
    func avatarImageFrame() {
        avatarImage.frame = CGRect(origin: CGPoint(x: margin, y: margin), size: CGSize(width: avatarSize, height: avatarSize))
    }
    
    // Установка размеров и позиции автора новости
    func titleLabelFrame() {
        // получаем размер текста
        let size = CGSize(width: bounds.width - avatarSize - margin * 3, height: titleHeight)
        // рассчитываем координату по оси Х
        let x = avatarSize + margin * 2
        // рассчитываем координату по оси Y
        let y = ceil(margin + avatarSize / 2 - size.height / 2)
        // получаем координаты верхней левой точки
        let origin = CGPoint(x: x, y: y)
        // получаем фрейм и установливаем его UILabel
        titleLabel.frame = CGRect(origin: origin, size: size)
    }
    
    // Установка размеров и позиции изображения
    func imageViewFrame() {
        guard imageSize.width != 0, imageSize.height != 0 else {
            //newsImage.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0))
            return
        }
        
        let ratio = Double(imageSize.height) / Double(imageSize.width)
        let y = avatarImage.frame.size.height + margin * 2
        let width = Double(bounds.width - margin * 2)
        let height = width * ratio
        let size = CGSize(width: width, height: ceil(height))
        let origin = CGPoint(x: margin, y: y) // avatarSize + insets
        
        newsImage.frame = CGRect(origin: origin, size: size)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImageFrame()
        titleLabelFrame()
        imageViewFrame()
    }
    
    func setAvatar(avatar: String) {
        avatarImage.kf.setImage(with: URL(string: avatar))
        // закругленные углы
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width / 2
        avatarImage.clipsToBounds = true
        
        avatarImageFrame()
    }
    
    func getCellHeight() -> CGFloat {
        var height: CGFloat = 0.0
        height += avatarImage.frame.size.height + margin * 2
        if imageSize != (0, 0) { height += newsImage.frame.size.height + margin }
        
        return height
    }
    
    func setupNews(news: News, cell: NewsPhotoViewCell, indexPath: IndexPath, tableView: UITableView) {
        // аватар
        setAvatar(avatar: news.avatarImage)
        
        // имя
        titleLabel.text = news.profileName
        titleLabelFrame()
        
        // картинка
        if let photo = news.photos {
            imageSize = (photo.width, photo.height)
            imageViewFrame()
            
            let getCacheImage = GetCacheImage(url: photo.url)
            getCacheImage.completionBlock = {
                OperationQueue.main.addOperation {
                    self.newsImage.image = getCacheImage.outputImage
                }
            }
            
            let setImageToRow = SetPhotoToRow(cell: cell, indexPath: indexPath, tableView: tableView)
            setImageToRow.addDependency(getCacheImage)
            queue.addOperation(getCacheImage)
            OperationQueue.main.addOperation(setImageToRow)
        } else {
            imageSize = (0, 0)
        }
        
        // высота ячейки
        if news.cellHeight == 0.0 {
            news.cellHeight = getCellHeight()
        }
    }
}
