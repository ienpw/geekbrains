//
//  News.swift
//  weatherClient
//
//  Created by Inpu on 03.08.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import Foundation
import SwiftyJSON
//import RealmSwift

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

class News {
    var avatarImage: String = ""
    var profileName: String = ""
    var sourceId: Int = 0
    var text: String = ""
    var comments: String = ""
    var likes: String = ""
    var reposts: String = ""
    var views: String = ""
    var attachments: Photo? = nil
    
    init(json: JSON) {
        self.sourceId = json["source_id"].intValue
        self.text = json["text"].stringValue
        self.comments = json["comments"]["count"].stringValue
        self.likes = json["likes"]["count"].stringValue
        self.reposts = json["reposts"]["count"].stringValue
        self.views = json["views"]["count"].stringValue
        
        if json["attachments"].count > 0, json["attachments"][0]["photo"]["sizes"].count > 0  {
            let attachment = json["attachments"][0]["photo"]["sizes"].arrayValue.filter({ $0["type"] == "x" })
            self.attachments = Photo(json: attachment[0])
        }
    }
}
