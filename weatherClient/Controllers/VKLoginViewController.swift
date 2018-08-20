//
//  VKLoginViewController.swift
//  weatherClient
//
//  Created by Inpu on 28.06.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import UIKit
import WebKit
import FirebaseDatabase

class VKLoginViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        if let request = vkAuthRequest() {
            webView.load(request)
        }
    }
    
    func vkAuthRequest() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "6618897"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "270342"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.80")
        ]
        
        if let url = urlComponents.url {
            return URLRequest(url: url)
        }
        
        return nil
    }
}

extension VKLoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment else {
                decisionHandler(.allow)
                return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        if let userId = params["user_id"] {
            // сохраняем id пользователя в firebase
            saveUserId(userId)
            // и в user defaults
            UserDefaults.standard.set(userId, forKey: "userId")
        }
        
        if let token = params["access_token"] {
            // сохраняем token
            UserDefaults.standard.set(token, forKey: "token")
            
            performSegue(withIdentifier: "myTabSegue", sender: nil)
        }
        
        decisionHandler(.cancel)
    }
    
    // Сохранение user id в firebase
    func saveUserId(_ userId: String) {
        // ссылка на базу
        let db = Database.database().reference()

        let timestamp = Date().timeIntervalSince1970
        let data = ["id": userId,
                    "loginTime": timestamp] as [String : Any]
        
        // сохраняем в Users, в качестве ключа используем userId
        db.child("Users").child(String(userId)).setValue(data)
    }
}
