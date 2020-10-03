//
//  AppDelegate.swift
//  Marvel
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import CoreData
import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        AppNavigator.shared.set(window: window!)
        CoreDataHelper.shared.printDBPath()
        Reachability.shared.startInternetTracking()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataHelper.shared.save(context: CoreDataHelper.shared.persistentContainer.viewContext)
    }
}
