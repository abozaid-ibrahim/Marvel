//
//  CoreData+Hero.swift
//  Marvel
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import CoreData
import Foundation

typealias Complation = ((Bool) -> Void)
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

    func save<T: CoreDataCachable>(data: [T], entity: TableName, onComplete: Complation? = nil) {
        for obj in data {
            let object = NSEntityDescription.insertNewObject(forEntityName: entity.rawValue, into: backgroundContext)
            object.setValuesForKeys(obj.keyValued)
        }
        do {
            try backgroundContext.save()
            onComplete?(false)
        } catch {
            print(error)
            onComplete?(false)
        }
    }
}
