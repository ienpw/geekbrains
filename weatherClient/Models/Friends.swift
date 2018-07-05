//
//  Friends.swift
//  weatherClient
//
//  Created by Inpu on 02.07.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Friends: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var avatarImage: String = ""
    
    convenience init(json: JSON) {
        self.init()
        
        self.id = json["id"].stringValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.avatarImage = json["photo_50"].stringValue
    }
}

//extension Friends: CustomStringConvertible {
//    var description: String {
//        return "\(firstName) \(lastName)"
//    }
//}

