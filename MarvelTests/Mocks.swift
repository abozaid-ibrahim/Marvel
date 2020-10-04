//
//  Mocks.swift
//  MarvelTests
//
//  Created by abuzeid on 03.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
@testable import Marvel

// MARK: Feed

final class MockedRemoteFeedLoader: FeedDataSource {
    func loadHeroesFeed(id: Int, offset: Int, compeletion: @escaping (Result<FeedResponse, Error>) -> Void) {
        let feed = Feed(pid: 1, id: 1, title: nil, modified: nil, thumbnail: nil)
        let feeds: [Feed] = .init(repeating: feed, count: 20)
        compeletion(.success((feeds, 20)))
    }
}

final class MockedLocalFeedLoader: FeedDataSource {
    func loadHeroesFeed(id: Int, offset: Int, compeletion: @escaping (Result<FeedResponse, Error>) -> Void) {
        let feed = Feed(pid: 1, id: 1, title: nil, modified: nil, thumbnail: nil)
        let feeds: [Feed] = .init(repeating: feed, count: 20)
        compeletion(.success((feeds, 20)))
    }
}



// MARK: Heroes

class MockedRemoteHeroesLoader: HeroesDataSource {
    func loadHeroes(offset: Int, compeletion: @escaping (Result<HeroResponse, Error>) -> Void) {
        let hero = Hero(id: 1, name: "test", thumbnail: nil)
        let heros: [Hero] = .init(repeating: hero, count: 20)
        compeletion(.success((heros, 20)))
    }
}

class MockedLocalHeroesLoader: HeroesDataSource {
    func loadHeroes(offset: Int, compeletion: @escaping (Result<HeroResponse, Error>) -> Void) {
    }
}

// MARK: D

struct APIInterval {
    static let moreThanDay = Calendar.current.date(byAdding: .hour, value: -25, to: Date())!
    static let lessThanDay = Calendar.current.date(byAdding: .minute, value: -23, to: Date())!
}

struct HasReachability: Reachable {
    func hasInternet() -> Bool {
        return true
    }
}
