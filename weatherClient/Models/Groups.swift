//
//  Groups.swift
//  weatherClient
//
//  Created by Inpu on 02.07.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Groups: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var avatarImage: String = ""
    
    convenience init(json: JSON) {
        self.init()
        
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        self.avatarImage = json["photo_50"].stringValue
    }
}
