//
//  Navigator.swift
//  Marvel
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//
import UIKit

protocol Navigator {
    func push(_ dest: Destination)
}

final class AppNavigator: Navigator {
    private static var navigationController: UINavigationController!
    static let shared = AppNavigator(root: AppNavigator.navigationController)

    @discardableResult
    init(window: UIWindow) {
        AppNavigator.navigationController = UINavigationController(rootViewController: Destination.feedPage.controller)
        window.rootViewController = AppNavigator.navigationController
        window.makeKeyAndVisible()
    }

    private init(root: UINavigationController) {
        AppNavigator.navigationController = root
    }

    func present(_ dest: Destination) {
        AppNavigator.navigationController.present(dest.controller, animated: true, completion: nil)
    }

    func back() {
        AppNavigator.navigationController.popViewController(animated: true)
    }

    func push(_ dest: Destination) {
        AppNavigator.navigationController.pushViewController(dest.controller, animated: true)
    }

    func pushAsNewRoot(_ dest: Destination) {
        AppNavigator.navigationController.viewControllers = [dest.controller]
    }
}
