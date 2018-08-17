//
//  Photo.swift
//  weatherClient
//
//  Created by Inpu on 16.08.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Photo {
    var url: String = ""
    var width: Int = 0
    var height: Int = 0
    
    init(json: JSON) {
        self.url = json["url"].stringValue
        self.width = json["width"].intValue
        self.height = json["height"].intValue
    }
}
