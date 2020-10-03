//
//  CoreData+Hero.swift
//  Marvel
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import CoreData
import Foundation

extension CoreDataHelper {
    func load(offset: Int, entity: TableName, predicate: NSPredicate? = nil) -> [NSManagedObject] {
        let managedContext = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity.rawValue)
        fetchRequest.fetchLimit = Page().pageSize
        fetchRequest.fetchOffset = offset
        fetchRequest.predicate = predicate

        do {
            return try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            log("Could not fetch. \(error), \(error.userInfo)", level: .error)
        }
        return []
    }

    func save<T: CoreDataCachable>(data: [T], entity: TableName, onComplete: ((Bool) -> Void)? = nil) {
        persistentContainer.performBackgroundTask { context in
            for obj in data {
                let object = NSEntityDescription.insertNewObject(forEntityName: entity.rawValue, into: context)
                object.setValuesForKeys(obj.keyValued)
            }

            do {
                try context.save()

                DispatchQueue.main.async {
                    self.persistentContainer.viewContext.performAndWait {
                        try? self.persistentContainer.viewContext.save()
                        onComplete?(false)
                    }
                }
            } catch {
                print(error)
                onComplete?(false)
            }
        }
    }
}

extension NSManagedObject {
    var toHero: Hero? {
        guard let id = value(forKeyPath: "id") as? Int,
            let name = value(forKeyPath: "name") as? String,
            let thumbnail = value(forKeyPath: "thumbnail") as? String
        else { return nil }
        return Hero(id: id,
                    name: name,
                    thumbnail: Thumbnail.instance(from: thumbnail))
    }
}

extension NSManagedObject {
    var toFeed: Feed? {
        guard let id = value(forKeyPath: "id") as? Int,
            let modified = value(forKeyPath: "modified") as? String,
            let pid = value(forKeyPath: "pid") as? Int,
            let title = value(forKeyPath: "title") as? String,
            let thumbnail = value(forKeyPath: "thumbnail") as? String
        else { return nil }
        return Feed(pid: pid,
                    id: id,
                    title: title,
                    modified: modified,
                    thumbnail: Thumbnail.instance(from: thumbnail))
    }
}
