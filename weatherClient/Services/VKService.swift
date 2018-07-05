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

class VKService {
    let apiID = "6618897"
    let apiUrl = "https://api.vk.com/method/"
    let apiVersion = "5.80"
    var parameters: Parameters
    
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
    func getAllFriends(completion: (([Friends]?, Error?) -> Void)?) {
        parameters["fields"] = "photo_50"
        
        makeRequest(parameters: parameters, apiMethod: "friends.get") { (json, error) in
            if let error = error {
                completion?(nil, error)
            }
            if let json = json {
                let friends = json["response"]["items"].arrayValue.map { Friends(json: $0) }
                completion?(friends, nil)
            }
        }
    }
    
    // Получить фотографии друга
    func getFriendPhotos(userID: String, completion: (([Photos]?, Error?) -> Void)?) {
        parameters["owner_id"] = userID
        parameters["no_service_albums"] = "1"
        parameters["skip_hidden"] = "1"
        
        makeRequest(parameters: parameters, apiMethod: "photos.getAll") { (json, error) in
            if let error = error {
                completion?(nil, error)
            }
            if let json = json {
                let photos = json["response"]["items"].arrayValue.map { Photos(json: $0) }
                completion?(photos, nil)
            }
        }
    }
    
    // Получить мои группы
    func getMyGroups(completion: (([Groups]?, Error?) -> Void)?) {
        parameters["extended"] = "1"
        
        makeRequest(parameters: parameters, apiMethod: "groups.get") { (json, error) in
            if let error = error {
                completion?(nil, error)
            }
            if let json = json {
                let groups = json["response"]["items"].arrayValue.map { Groups(json: $0) }
                completion?(groups, nil)
            }
        }
    }
    
    // Найти группы
    func searchGroups(query: String) {
        parameters["q"] = query
        // makeRequest(parameters: parameters, apiMethod: "groups.search")
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
    
    // сохранение данных в Realm
    func saveData() {
        let realm = try! Realm()
        
    }
}
