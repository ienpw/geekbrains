//
//  MyTabBarController.swift
//  weatherClient
//
//  Created by Inpu on 21.06.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // задаем фон таб-бара и цвет иконок
        self.tabBar.barTintColor = .black
        self.tabBar.tintColor = .white
    }
}
