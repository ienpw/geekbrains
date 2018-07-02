//
//  Friends.swift
//  weatherClient
//
//  Created by Inpu on 02.07.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import Foundation
import SwiftyJSON

class Friends {
    var id: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var avatarImage: String = ""
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.avatarImage = json["photo_50"].stringValue
    }
}

extension Friends: CustomStringConvertible {
    var description: String {
        return "\(firstName) \(lastName)"
    }
}
