//
//  GetCacheImage.swift
//  weatherClient
//
//  Created by Inpu on 10.08.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import Foundation
import UIKit

class GetCacheImage: Operation {
    // время жизни кэша
    private let cacheLifeTime: TimeInterval = 3600

    // путь к кэшу изображений
    private static let pathName: String = {
        let pathName = "images"
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName }
        
        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return pathName
    }()
    
    // путь к изображению
    private lazy var filePath: String? = {
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        let hashName = String(describing: url.hashValue)
        
        return cachesDirectory.appendingPathComponent(GetCacheImage.pathName + "/" + hashName).path
    }()
    
    private let url: String
    var outputImage: UIImage?
    
    init(url: String) {
        self.url = url
    }
    
    override func main() {
        // проверяем установлен ли путь к изображению и не отменена ли операция
        guard filePath != nil && !isCancelled else { return }
        
        // получить изображение из кэша
        if getImageFromChache() { return }
        guard !isCancelled else { return }
        
        // загружаем изображение
        if !downloadImage() { return }
        guard !isCancelled else { return }
        
        // сохраняем изображение в кэш
        saveImageToChache()
    }
    
    // Получить изображение из кэша
    private func getImageFromChache() -> Bool {
        guard let fileName = filePath,
            let info = try? FileManager.default.attributesOfItem(atPath: fileName),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date else { return false }
        
        let lifeTime = Date().timeIntervalSince(modificationDate)
        
        guard lifeTime <= cacheLifeTime,
            let image = UIImage(contentsOfFile: fileName) else { return false }
        
        self.outputImage = image
        
        return true
    }
    
    // Загрузить изображение
    private func downloadImage() -> Bool {
        guard let url = URL(string: url),
            let data = try? Data.init(contentsOf: url),
            let image = UIImage(data: data) else { return false }
        
        self.outputImage = image
        
        return true
    }
    
    // Сохранить изображение в кэш
    private func saveImageToChache() {
        guard let fileName = filePath, let image = outputImage else { return }
        
        let data = UIImagePNGRepresentation(image)
        
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
    }
}
