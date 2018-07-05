//
//  Photos.swift
//  weatherClient
//
//  Created by Inpu on 02.07.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Photos: Object {
    @objc dynamic var url: String = ""
    @objc dynamic var width: String = ""
    @objc dynamic var height: String = ""
    @objc dynamic var type: String = ""
    
    convenience init(json: JSON) {
        self.init()
        
        self.url = json["sizes"][4]["url"].stringValue
        self.width = json["sizes"][4]["width"].stringValue
        self.height = json["sizes"][4]["height"].stringValue
        self.type = json["sizes"][4]["type"].stringValue
    }
}
