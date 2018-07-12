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
                // сохранить новые данные в Realm
                let friends = json["response"]["items"].arrayValue.map { Friends(json: $0) }
                self.saveData(friends)
                
                completion?(nil)
            }
        }
    }

    
    // Получить фотографии друга
//    func getFriendPhotos(userID: String, completion: (([Photos]?, Error?) -> Void)?) {
//        let photos = Array(realm.objects(Photos.self).filter("userID = '" + userID + "'"))
//        if photos.count > 0 {
//            completion?(photos, nil)
//        } else {
//            parameters["owner_id"] = userID
//            parameters["no_service_albums"] = "1"
//            parameters["skip_hidden"] = "1"
//            makeRequest(parameters: parameters, apiMethod: "photos.getAll") { (json, error) in
//                if let error = error {
//                    completion?(nil, error)
//                }
//                if let json = json {
//                    let photos = json["response"]["items"].arrayValue.map { Photos(json: $0) }
//                    for photo in photos { photo.userID = userID }
//                    self.saveData(photos)
//                    completion?(photos, nil)
//                }
//            }
//        }
//    }
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
                // сохранить новые данные в Realm
                let photos = json["response"]["items"].arrayValue.map { Photos(json: $0) }
                for photo in photos { photo.userID = userID }
                self.saveData(photos)
                
                completion?(nil)
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
                    let groups = json["response"]["items"].arrayValue.map { Groups(json: $0) }
                    self.saveData(groups)
                    completion?(groups, nil)
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
                let groups = json["response"]["items"].arrayValue.map { Groups(json: $0) }
                completion?(groups, nil)
            }
        }
    }
    
    // Сохранить новую группу
    func saveGroup(_ group: Groups) {
        saveData(group)
    }
    
    // Запрос к api
    func makeRequest(parameters: Parameters, apiMethod: String, completion: ((JSON?, Error?) -> Void)?) {
        Alamofire.request(apiUrl + apiMethod, parameters: parameters).responseData { response in
            if let error = response.error {
                completion?(nil, error)
                return
            }
            if let value = response.value {
                // преобразовать value в JSON
                let json = try? JSON(data: value)
                completion?(json, nil)
            }
        }
    }
    
    // сохранение массива объектов в Realm
    func saveData(_ data: [Object]) {
        do {
            try realm.write {
                //realm.deleteAll()
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
