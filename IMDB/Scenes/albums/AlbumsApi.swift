//
//  AlbumsApi.swift
//  IMDB
//
//  Created by abuzeid on 13.08.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

import Foundation

enum AlbumsApi {
    case feed(page: Int, count: Int)
    case search(String)
}

extension AlbumsApi: RequestBuilder {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }

    var path: String {
        switch self {
        case .feed:
            return "5df79b1f320000f4612e011e"
        case .search:
            return "5df79b1f320000f4612e011e"
        }
    }

    var endpoint: URL {
        return URL(string: "\(baseURL)\(path)")!
    }

    var method: HttpMethod {
        return .get
    }

    var request: URLRequest {
        switch self {
        case .feed, .search:
            return URLRequest(url: endpoint)
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/x-www-form-urlencoded"]
    }
}
