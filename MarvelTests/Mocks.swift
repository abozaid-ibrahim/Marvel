//
//  Mocks.swift
//  MarvelTests
//
//  Created by abuzeid on 03.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
@testable import Marvel

// MARK: API

final class MockedHeroesSuccessApi: ApiClient {
    func getData(of request: RequestBuilder, completion: @escaping (Result<Data, Error>) -> Void) {
        let hero = Hero(id: 1, name: "Hello", thumbnail: nil)
        let data = DataClass(offset: 0, limit: 20, total: 60, count: 0, results: .init(repeating: hero, count: 20))
        let response = HeroesResponse(data: data)

        completion(.success(try! JSONEncoder().encode(response)))
    }

    func cancel() {
        // todo
    }
}

final class HeroesMockedFailureApi: ApiClient {
    func getData(of request: RequestBuilder, completion: @escaping (Result<Data, Error>) -> Void) {
        let data = "{data:1}".data(using: .utf8)
        completion(.success(try! JSONEncoder().encode(data)))
    }

    func cancel() {
        // todo
    }
}

final class MockedFeedSuccessApi: ApiClient {
    func getData(of request: RequestBuilder, completion: @escaping (Result<Data, Error>) -> Void) {
        let feed = Feed(id: 1, title: nil, modified: nil, thumbnail: nil)
        let data = FeedDataClass(offset: 0, limit: 20, total: 60, count: 0, results: .init(repeating: feed, count: 20))
        let response = FeedJsonResponse(data: data)
        completion(.success(try! JSONEncoder().encode(response)))
    }

    func cancel() {
        // todo
    }
}

// MARK: APIInterval

struct APIInterval {
    static let moreThanDay = Calendar.current.date(byAdding: .hour, value: -25, to: Date())!
    static let lessThanDay = Calendar.current.date(byAdding: .minute, value: -23, to: Date())!
}

struct HasReachability: Reachable {
    func hasInternet() -> Bool {
        return true
    }
}
