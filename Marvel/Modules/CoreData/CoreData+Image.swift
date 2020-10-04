//
//  CoreData+Image.swift
//  Marvel
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

import CoreData
//
//extension CoreDataHelper {
//    func saveImage(url: String, data: Data, entity: TableName = .images) {
//        let managedContext = persistentContainer.viewContext
//        let object = NSEntityDescription.insertNewObject(forEntityName: entity.rawValue, into: managedContext)
//        object.setValue(data, forKey: "image")
//        object.setValue(url, forKey: "url")
//        object.setValue(Date(), forKey: "date")
//        do {
//            try managedContext.save()
//        } catch let error as NSError {
//            log("Could not save. \(error), \(error.userInfo)", level: .error)
//        }
//    }
//
//    func getImage(url: String) -> Data? {
//        let managedContext = persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TableName.images.rawValue)
//        fetchRequest.predicate = NSPredicate(format: "url = %@", url)
//
//        do {
//            let images = try managedContext.fetch(fetchRequest)
//            return images.first?.value(forKey: "image") as? Data
//        } catch let error as NSError {
//            log("Could not fetch. \(error), \(error.userInfo)", level: .error)
//        }
//        return nil
//    }
//}

struct Image: CoreDataCachable {
    let image: Data
    let url: String
    let date = Date()
    var keyValued: [String: Any] {
        return ["image": image,
                "url": url,
                "date": date]
    }
}

extension NSPredicate {
    static func image(of url: String) -> NSPredicate {
        NSPredicate(format: "url = %@", url)
    }
}
