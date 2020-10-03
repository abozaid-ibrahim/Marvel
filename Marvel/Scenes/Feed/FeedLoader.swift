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
        let loader = shouldLoadRemotely(for: .feedApiLastUpdated) ? remoteLoader : localLoader
        loader.loadHeroesFeed(id: id, offset: offset, compeletion: compeletion)
    }
}
