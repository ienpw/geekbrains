//
//  Groups.swift
//  weatherClient
//
//  Created by Inpu on 02.07.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import Foundation
import SwiftyJSON

class Groups {
    var id: String = ""
    var name: String = ""
    var avatarImage: String = ""
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        self.avatarImage = json["photo_50"].stringValue
    }
}
