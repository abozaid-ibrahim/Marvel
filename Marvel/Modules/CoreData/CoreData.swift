//
//  CoreDataManager.swift
//  Marvel
//
//  Created by abuzeid on 28.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import CoreData
import Foundation

enum TableName: String {
    case heroes = "HeroEntity"
    case feed = "FeedEntity"
    case images = "ImagesEntity"
}

final class CoreDataHelper {
    let dataModelName = "Marvel"
    static let shared = CoreDataHelper()
    private init() {}

    lazy var backgroundContext: NSManagedObjectContext = {
        let contxt = self.persistentContainer.newBackgroundContext()
        contxt.automaticallyMergesChangesFromParent = true
        return contxt
    }()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataHelper.shared.dataModelName)
        container.loadPersistentStores(completionHandler: { [weak self] _, error in
            self?.handle(error: error)
        })
        return container
    }()

    func printDBPath() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        log("DB Directory: ", path, level: .info)
    }

    private func handle(error: Error?) {
        if let error = error as NSError? {
            #if DEBUG
                fatalError("Unresolved error \(error), \(error.userInfo)")
            #endif
        }
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            handle(error: error)
        }
    }

    func clearCache(for entity: TableName, where predicate: NSPredicate? = nil) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
        fetchRequest.predicate = predicate
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try backgroundContext.execute(batchDeleteRequest)
        } catch {
            log("Detele all data in \(entity) error :", error, level: .error)
        }
    }
}
