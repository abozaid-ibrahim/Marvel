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
    func load(offset: Int, entity: TableName, predicate:NSPredicate? = nil) -> [NSManagedObject] {
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

    func save<T: CoreDataCachable>(data: [T], entity: TableName) {
        let managedContext = persistentContainer.viewContext
        for obj in data {
            let object = NSEntityDescription.insertNewObject(forEntityName: entity.rawValue, into: managedContext)
            object.setValuesForKeys(obj.keyValued)
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            log("Could not save. \(error), \(error.userInfo)", level: .error)
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
                    resultDescription: nil,
                    thumbnail: Thumbnail.instance(from: thumbnail))
    }
}

extension NSManagedObject {
    var toFeed: Feed? {
        guard let id = value(forKeyPath: "id") as? Int,
            let modified = value(forKeyPath: "modified") as? String,
            let title = value(forKeyPath: "title") as? String,
            let thumbnail = value(forKeyPath: "thumbnail") as? String
        else { return nil }
        return Feed(id: id,
                    title: title,
                    modified: modified,
                    thumbnail: Thumbnail.instance(from: thumbnail))
    }
}
