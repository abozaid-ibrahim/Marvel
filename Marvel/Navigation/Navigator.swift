//
//  Navigator.swift
//  Marvel
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//
import UIKit

final class AppNavigator {
    static let shared = AppNavigator()
    private init() {}
    func set(window: UIWindow) {
        let navigationController = UINavigationController(rootViewController: FeedTableController())
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
