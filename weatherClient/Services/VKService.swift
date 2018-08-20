//
//  VKService.swift
//  weatherClient
//
//  Created by Inpu on 28.06.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift
import FirebaseDatabase

class VKService {
    let apiID = "6618897"
    let apiUrl = "https://api.vk.com/method/"
    let apiVersion = "5.80"
    var parameters: Parameters
    let realm = try! Realm()
    
    init(token: String? = nil) {
        // получаем токен
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            fatalError()
        }
        // задаем параметры по-умолчанию для запросов
        parameters = [
            "access_token": token,
            "v": apiVersion
        ]
    }
    
    // Получить всех друзей
    func getAllFriends(completion: ((Error?) -> Void)?) {
        parameters["fields"] = "photo_50"
        makeRequest(parameters: parameters, apiMethod: "friends.get") { (json, error) in
            if let error = error {
                completion?(error)
            }
            if let json = json {
                // удалить старые данные из Realm
                let oldFriends = self.realm.objects(Friends.self)
                do {
                    try self.realm.write {
                        self.realm.delete(oldFriends)
                    }
                } catch {
                    completion?(error)
                }
                
                DispatchQueue.global().async {
                    let friends = json["response"]["items"].arrayValue.map { Friends(json: $0) }
                    
                    DispatchQueue.main.async {
                        // сохранить новые данные в Realm
                        self.saveData(friends)
                        
                        completion?(nil)
                    }
                }
            }
        }
    }
    
    // Получить фотографии друга
    func getFriendPhotos(userID: String, completion: ((Error?) -> Void)?) {
        parameters["owner_id"] = userID
        parameters["no_service_albums"] = "1"
        parameters["skip_hidden"] = "1"
        makeRequest(parameters: parameters, apiMethod: "photos.getAll") { (json, error) in
            if let error = error {
                completion?(error)
            }
            if let json = json {
                // удалить старые данные из Realm
                let oldPhotos = self.realm.objects(Photos.self).filter("userID = '" + userID + "'")
                do {
                    try self.realm.write {
                        self.realm.delete(oldPhotos)
                    }
                } catch {
                    completion?(error)
                }
                
                DispatchQueue.global().async {
                    let photos = json["response"]["items"].arrayValue.map { Photos(json: $0) }
                    for photo in photos { photo.userID = userID }

                    DispatchQueue.main.async {
                        // сохранить новые данные в Realm
                        self.saveData(photos)
                        
                        completion?(nil)
                    }
                }
            }
        }
    }
    
    // Получить ленту новостей
    func getNewsFeed(completion: (([News]?, Error?) -> Void)?) {
        parameters["filters"] = "post,photo"
        parameters["return_banned"] = "0"
        makeRequest(parameters: parameters, apiMethod: "newsfeed.get") { (json, error) in
            if let error = error {
                completion?(nil, error)
            }
            if let json = json {
                DispatchQueue.global().async {
                    let news = json["response"]["items"].arrayValue.map { News(json: $0) }
                    let newsProfiles = json["response"]["profiles"].arrayValue
                    let newsGroups = json["response"]["groups"].arrayValue
                    
                    // добавляем в news аватар и имя автора
                    for item in news {
                        if item.sourceId > 0 {
                            // берем данные из профиля пользователя (секция profiles)
                            let profile = newsProfiles.filter({ $0["id"].intValue == item.sourceId })
                            
                            item.avatarImage = profile[0]["photo_50"].stringValue
                            item.profileName = profile[0]["first_name"].stringValue + " " + profile[0]["last_name"].stringValue
                        } else {
                            // или берем данные из профиля группы (секция groups)
                            let group = newsGroups.filter({ $0["id"].intValue == abs(item.sourceId) })
                            
                            item.avatarImage = group[0]["photo_50"].stringValue
                            item.profileName = group[0]["name"].stringValue
                        }
                    }
                    
                    DispatchQueue.main.async {
                        completion?(news, nil)
                    }
                }
            }
        }
    }
    
    // Получить мои группы
    func getMyGroups(completion: (([Groups]?, Error?) -> Void)?) {
        let groups = Array(realm.objects(Groups.self))
        if groups.count > 0 {
            completion?(groups, nil)
        } else {
            parameters["extended"] = "1"
            makeRequest(parameters: parameters, apiMethod: "groups.get") { (json, error) in
                if let error = error {
                    completion?(nil, error)
                }
                if let json = json {
                    DispatchQueue.global().async {
                        let groups = json["response"]["items"].arrayValue.map { Groups(json: $0) }
                        
                        DispatchQueue.main.async {
                            // сохранить группы в Realm
                            self.saveData(groups)
                            
                            completion?(groups, nil)
                        }
                    }
                }
            }
        }
    }
    
    // Найти группы
    func searchGroups(query: String, completion: (([Groups]?, Error?) -> Void)?) {
        parameters["q"] = query
        makeRequest(parameters: parameters, apiMethod: "groups.search") { (json, error) in
            if let error = error {
                completion?(nil, error)
            }
            if let json = json {
                DispatchQueue.global().async {
                    let groups = json["response"]["items"].arrayValue.map { Groups(json: $0) }
                    
                    DispatchQueue.main.async {
                        completion?(groups, nil)
                    }
                }
            }
        }
    }
    
    // Сохранить новую группу
    func saveGroup(_ group: Groups) {
        // сохраняем группу в realm
        saveData(group)
        
        // сохраняем группу пользователя в firebase
        if let userId = UserDefaults.standard.string(forKey: "userId") {
            let db = Database.database().reference()
            let data = ["id": group.id,
                        "name": group.name] as [String : Any]
            // сохраняем в Users/userId/groups, в качестве ключа внутри groups используем Id группы
            let updates = ["/Users/\(userId)/groups/\(group.id)": data]
            db.updateChildValues(updates)
        }
    }
    
    // Запрос к api
    func makeRequest(parameters: Parameters, apiMethod: String, completion: ((JSON?, Error?) -> Void)?) {
        Alamofire.request(apiUrl + apiMethod, parameters: parameters).responseData(queue: DispatchQueue.global()) { response in
            if let error = response.error {
                DispatchQueue.main.async {
                    completion?(nil, error)
                }
                return
            }
            if let value = response.value {
                // преобразовать value в JSON
                let json = try? JSON(data: value)
                DispatchQueue.main.async {
                    completion?(json, nil)
                }
            }
        }
    }
    
    // сохранение массива объектов в Realm
    func saveData(_ data: [Object]) {
        do {
            try realm.write {
                realm.add(data)
                //print(realm.configuration.fileURL)
            }
        } catch {
            print(error)
        }
    }
    
    // сохранение объекта в Realm
    func saveData(_ data: Object) {
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print(error)
        }
    }
    
    // удаление массива объектов из Realm
    func deleteData(_ data: Results<Object>) {
        do {
            try realm.write {
                realm.delete(data)
            }
        } catch {
            print(error)
        }
    }
    
    // удаление объекта из Realm
    func deleteData(_ data: Object) {
        do {
            try realm.write {
                realm.delete(data)
            }
        } catch {
            print(error)
        }
    }
}
