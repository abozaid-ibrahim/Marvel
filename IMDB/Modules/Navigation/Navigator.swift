//
//  Navigator.swift
//  MusicPlayer
//
//  Created by abuzeid on 07.08.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

protocol Navigator {
    func push(_ dest: Destination)
}

/// once app navigator is intialized,
///  it have a root controller to do all navigation on till it recieve new root
final class AppNavigator: Navigator {
    private static var navigationController: UINavigationController!
    static let shared = AppNavigator(root: AppNavigator.navigationController)

    @discardableResult
    init(window: UIWindow) {
        AppNavigator.navigationController = UINavigationController(rootViewController: Destination.recipesList.controller)
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

enum NavigatorError: Error {
    case noRoot
}
