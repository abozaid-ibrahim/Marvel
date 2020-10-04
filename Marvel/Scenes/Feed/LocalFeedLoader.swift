//
//  LocalFeedLoader.swift
//  Marvel
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import CoreData
import Foundation

class LocalFeedLoader: FeedDataSource {
    func loadHeroesFeed(id: Int, offset: Int, compeletion: @escaping (Result<FeedResponse, Error>) -> Void) {
        let feed = CoreDataHelper
            .shared
            .load(offset: offset, entity: .feed, predicate: .feed(pid: id))
            .compactMap { $0.toFeed }
        compeletion(.success((feed, feed.count)))
    }
}
