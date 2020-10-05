//
//  FeedLocalLoader.swift
//  Marvel
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import CoreData
import Foundation

final class FeedLocalLoader: FeedDataSource {
    func loadHeroesFeed(id: Int, offset: Int, compeletion: @escaping (Result<FeedResponse, APIError>) -> Void) {
        let feed = CoreDataIO
            .shared
            .load(offset: offset, entity: .feed, predicate: .feed(pid: id))
            .compactMap { $0.toFeed }
        compeletion(.success((feed, feed.count)))
    }
}
