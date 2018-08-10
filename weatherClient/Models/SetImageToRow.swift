//
//  SetImageToRow.swift
//  weatherClient
//
//  Created by Inpu on 10.08.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import Foundation
import UIKit

class SetImageToRow: Operation {
    private let indexPath: IndexPath
    private weak var tableView: UITableView?
    private var cell: NewsPhotoViewCell?
    
    init(cell: NewsPhotoViewCell, indexPath: IndexPath, tableView: UITableView) {
        self.indexPath = indexPath
        self.tableView = tableView
        self.cell = cell
    }
    
    override func main() {
        guard let tableView = tableView,
            let cell = cell,
            let getCacheImage = dependencies[0] as? GetCacheImage,
            let image = getCacheImage.outputImage else { return }
        
        if let newIndexPath = tableView.indexPath(for: cell), newIndexPath == indexPath {
            cell.newsImage.image = image
        } else if tableView.indexPath(for: cell) == nil {
            cell.newsImage.image = image
        }
    }
}
