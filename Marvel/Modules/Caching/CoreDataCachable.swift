//
//  NSManagedObject+Dictionary.swift
//  Marvel
//
//  Created by abuzeid on 05.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import CoreData
import Foundation
protocol CoreDataCachable {
    var keyValued: [String: Any] { get }
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
