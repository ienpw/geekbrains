//
//  NewsTextViewCell.swift
//  weatherClient
//
//  Created by Inpu on 06.08.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import UIKit

class NewsTextViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var avatarImage: UIImageView! {
        didSet {
            avatarImage.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var newsImage: UIImageView! {
        didSet {
            newsImage.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var newsTextLabel: UILabel! {
        didSet {
            newsTextLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var statisticsBlock: UIView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var repostsLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    
    let margin: CGFloat = 16.0
    //var cellHeight: CGFloat = 0.0
    // TODO: получить размер аватара программно
    let avatarSize: CGFloat = 64.0
    let titleHeight: CGFloat = 21.0
    var imageSize: (width: Int, height: Int) = (0, 0)
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    func getLabelSize(text: String, font: UIFont) -> CGSize {
        // максимальная ширина текста
        let maxWidth = bounds.width - margin * 2
        // размеры блока (макс. ширина и макс. возможная высота)
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        // прямоугольник под текст
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        // ширина и высота блока
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        // размер, округленный до большего целого
        let size = CGSize(width: ceil(width), height: ceil(height))
        
        return size
    }
    
    // Установка аватара
    func avatarImageFrame() {
        avatarImage.frame = CGRect(origin: CGPoint(x: margin, y: margin), size: CGSize(width: avatarSize, height: avatarSize))
    }
    
    // Установка размеров и позиции автора новости
    func titleLabelFrame() {
        // получаем размер текста
        let labelSize = CGSize(width: bounds.width - avatarSize - margin * 3, height: titleHeight)
        // рассчитываем координату по оси Х
        let labelX = avatarSize + margin * 2
        // рассчитываем координату по оси Y
        let labelY = ceil(margin + avatarSize / 2 - labelSize.height / 2)
        // получаем координаты верхней левой точки
        let labelOrigin = CGPoint(x: labelX, y: labelY)
        // получаем фрейм и установливаем его UILabel
        titleLabel.frame = CGRect(origin: labelOrigin, size: labelSize)
    }
    
    // Установка размеров и позиции текста новости
    func newsTextLabelFrame() {
        // получаем размер текста
        let labelSize = newsTextLabel.text! == "" ? CGSize(width: 0, height: 0) : getLabelSize(text: newsTextLabel.text!, font: newsTextLabel.font)
        // рассчитываем координату по оси Y
        let labelY: CGFloat = avatarSize + margin * 2
        // получаем координаты верхней левой точки
        let labelOrigin = CGPoint(x: margin, y: labelY)
        // получаем фрейм и установливаем его UILabel
        newsTextLabel.frame = CGRect(origin: labelOrigin, size: labelSize)
    }
    
    // Установка размеров и позиции изображения
    func imageViewFrame() {
        guard imageSize.width != 0, imageSize.height != 0 else {
            newsImage.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0))
            //newsImage.isHidden = true
            return
        }
        
        let ratio = Double(imageSize.height) / Double(imageSize.width)
        let y = avatarImage.frame.size.height + newsTextLabel.frame.size.height + margin * 3
        let width = Double(bounds.width - margin * 2)
        let height = width * ratio
        let size = CGSize(width: width, height: ceil(height))
        let origin = CGPoint(x: margin, y: y) // avatarSize + insets
        
        newsImage.frame = CGRect(origin: origin, size: size)
    }
    
    // Блок со статистикой
    func statisticsViewFrame() {
        let statisticsSize = CGSize(width: bounds.width - margin * 2, height: 60.0)
        var statisticsY = avatarImage.frame.size.height + newsTextLabel.frame.size.height + margin * 2
        if newsImage.frame.size.height != 0.0 {
            statisticsY += newsImage.frame.size.height + margin
        }
        let statisticsOrigin = CGPoint(x: 0.0, y: statisticsY)
        statisticsBlock.frame = CGRect(origin: statisticsOrigin, size: statisticsSize)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImageFrame()
        titleLabelFrame()
        imageViewFrame()
        newsTextLabelFrame()
        statisticsViewFrame()
    }
    
    func setAvatar(avatar: String) {
        avatarImage.kf.setImage(with: URL(string: avatar))
        // закругленные углы
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width / 2
        avatarImage.clipsToBounds = true
        
        avatarImageFrame()
    }
    
    func setNewsText(text: String) {
        newsTextLabel.text = text
        newsTextLabelFrame()
    }
    
    func setStatistics(news: News) {
        // лайки
        likesLabel.text = news.likes
        
        //комментарии
        commentsLabel.text = news.comments
        
        // репосты
        repostsLabel.text = news.reposts
        
        //просмотры
        viewsLabel.text = news.views
        
        statisticsViewFrame()
    }
    
    func getCellHeight() -> CGFloat {
        var height: CGFloat = 0.0
        height += avatarImage.frame.size.height + margin * 2
        height += newsTextLabel.frame.size.height
        if imageSize != (0, 0) { height += newsImage.frame.size.height + margin }
        height += statisticsBlock.frame.size.height
        
        return height
    }
    
    func setupNews(news: News, cell: NewsTextViewCell, indexPath: IndexPath, tableView: UITableView) {
        //print(news.profileName)
        
        // аватар
        setAvatar(avatar: news.avatarImage)
        
        // имя
        titleLabel.text = news.profileName
        titleLabelFrame()
        
        // текст
        setNewsText(text: news.text)
        
        // картинка
        if let attachments = news.attachments {
            imageSize = (attachments.width, attachments.height)
            imageViewFrame()
            
            let getCacheImage = GetCacheImage(url: attachments.url)
            getCacheImage.completionBlock = {
                OperationQueue.main.addOperation {
                    self.newsImage.image = getCacheImage.outputImage
                }
            }
            
            let setImageToRow = SetImageToRow(cell: cell, indexPath: indexPath, tableView: tableView)
            setImageToRow.addDependency(getCacheImage)
            queue.addOperation(getCacheImage)
            OperationQueue.main.addOperation(setImageToRow)
        } else {
            imageSize = (0, 0)
        }
        
        // статистика
        setStatistics(news: news)
        
        // высота ячейки
        if news.cellHeight == 0.0 {
            news.cellHeight = getCellHeight()
        }
    }
}
