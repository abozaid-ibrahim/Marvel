//
//  CoreDataManager.swift
//  Marvel
//
//  Created by abuzeid on 28.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import CoreData
import Foundation

final class CoreDataHelper {
    enum TableName: String {
        case heroes = "HeroEntity"
        case feed = "FeedEntity"
        case images = "ImagesEntity"
    }

    let dataModelName = "Marvel"
    static let shared = CoreDataHelper()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataHelper.shared.dataModelName)
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                #if DEBUG
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                #endif
            }
        })
        return container
    }()

    func printDBPath() {
        log("DB Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!", level: .info)
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            // TODO: Replace this implementation with code to handle the error appropriately.
            #if DEBUG
                fatalError("Unresolved error \(error)")
            #endif
        }
    }

    func clearCache(for entity: TableName) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try persistentContainer.viewContext.execute(batchDeleteRequest)
        } catch {
            log("Detele all data in \(entity) error :", error, level: .error)
        }
    }
}
