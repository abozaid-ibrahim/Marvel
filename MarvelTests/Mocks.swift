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

final class MockedSuccessAPIClient: ApiClient {
    func getData(of request: RequestBuilder, completion: @escaping (Result<Data, APIError>) -> Void) {
        let data: Data?
        switch request {
        case HeroesAPI.characters:
            data = ResponseFactory().heroes
        case HeroesAPI.comics:
            data = ResponseFactory().feed
        default:
            data = nil
        }

        completion(.success(data!))
    }
}

final class MockedHeroesFailureApi: ApiClient {
    func getData(of request: RequestBuilder, completion: @escaping (Result<Data, APIError>) -> Void) {
        let data = "{data:1}".data(using: .utf8)
        completion(.success(try! JSONEncoder().encode(data)))
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

struct ResponseFactory {
    let heroes = """
       {
               "data": {
               "offset": 0,
               "limit": 3,
               "total": 60,
               "results": [{
               "id": 1011334,
               "name": "3-D Man",
               "modified": "2014-04-29T14:18:17-0400"
               },
               {
               "id": 1011334,
               "name": "3-D Man",
               "modified": "2014-04-29T14:18:17-0400",
               },
               {
               "id": 1011334,
               "name": "3-D Man",
               "modified": "2014-04-29T14:18:17-0400",
               }
               ]}}
    """.data(using: .utf8)

    let feed: Data = {
        let feed = Feed(id: 1, title: nil, modified: nil, thumbnail: nil)
        let data = FeedDataClass(offset: 0, limit: 20, total: 60, count: 0, results: .init(repeating: feed, count: 20))
        let response = FeedJsonResponse(data: data)
        return try! JSONEncoder().encode(response)
    }()
}
