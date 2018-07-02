//
//  Photos.swift
//  weatherClient
//
//  Created by Inpu on 02.07.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import Foundation
import SwiftyJSON

class Photos {
    var url: String = ""
    var width: String = ""
    var height: String = ""
    var type: String = ""
    
    init(json: JSON) {
        self.url = json["sizes"][4]["url"].stringValue
        self.width = json["sizes"][4]["width"].stringValue
        self.height = json["sizes"][4]["height"].stringValue
        self.type = json["sizes"][4]["type"].stringValue
    }
}
