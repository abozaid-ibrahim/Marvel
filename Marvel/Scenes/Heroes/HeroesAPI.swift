//
//  MovieApi.swift
//  Marvel
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

enum MovieApi {
    case nowPlaying(page: Int)
    case search(String)
}

extension MovieApi: RequestBuilder {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }

    var path: String {
        switch self {
        case .nowPlaying:
            return "v1/public/characters"
        case .search:
            return "search/movie"
        }
    }

    private var endpoint: URL {
        return URL(string: "\(baseURL)\(path)")!
    }

    var method: HttpMethod {
        return .get
    }

    var parameters: [String: Any] {
        switch self {
        case let .search(query):
            return ["api_key": APIConstants.apiToken,
                    "query": query]
        case let .nowPlaying(page):
            let value = APIConstants.api
            return ["apikey": APIConstants.publicKey,
                    "ts": value.ts,
                    "hash": value.hash]
        }
    }

    var request: URLRequest {
        var items = [URLQueryItem]()
        var urlComponents = URLComponents(string: endpoint.absoluteString)
        for (key, value) in parameters {
            items.append(URLQueryItem(name: key, value: "\(value)"))
        }
        urlComponents?.queryItems = items
        var request = URLRequest(url: urlComponents!.url!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
        request.httpMethod = method.rawValue
        log(request, level: .info)
        return request
    }
}
