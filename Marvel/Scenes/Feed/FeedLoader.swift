//
//  FeedLoader.swift
//  Marvel
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

typealias FeedResponse = (feed: [Feed], totalPages: Int)

protocol FeedDataSource {
    func loadHeroesFeed(id: Int, offset: Int, compeletion: @escaping (Result<FeedResponse, Error>) -> Void)
}

final class FeedLoader: FeedDataSource, DataSource {
    private let localLoader: FeedDataSource
    private let remoteLoader: FeedDataSource

    init(localLoader: FeedDataSource = LocalFeedLoader(),
         remoteLoader: FeedDataSource = RemoteFeedLoader()) {
        self.localLoader = localLoader
        self.remoteLoader = remoteLoader
    }

    func loadHeroesFeed(id: Int, offset: Int, compeletion: @escaping (Result<FeedResponse, Error>) -> Void) {
        let loadRemotely = shouldLoadRemotely(for: .feedApiLastUpdated(id: id))
        let loader = loadRemotely ? remoteLoader : localLoader
        loader.loadHeroesFeed(id: id, offset: offset) { result in
            if case let .success(data) = result, loadRemotely {
                self.removeOldCachedData(for: .feed, where: .feed(pid: id))
                self.cachData(id, data.feed)
            }
            compeletion(result)
        }
    }
}

private extension FeedLoader {
    func cachData(_ id: Int, _ data: [Feed]) {
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.feedApiLastUpdated(id: id).key)
        UserDefaults.standard.synchronize()
        let dataWithParendId = data.map { Feed($0, pid: id) }
        CoreDataHelper.shared.save(data: dataWithParendId, entity: .feed)
    }

    func removeOldCachedData(for entity: TableName, where predicate: NSPredicate) {
        CoreDataHelper.shared.clearCache(for: entity, where: predicate)
    }
}

extension NSPredicate {
    static func feed(pid: Int) -> NSPredicate {
        return NSPredicate(format: "pid = %i", pid)
    }
}
