//
//  MovieApi.swift
//  IMDB
//
//  Created by abuzeid on 13.08.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

import Foundation

enum MovieApi {
    case feed(page: Int, count: Int)
    case search(String)
}

extension MovieApi: RequestBuilder {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }

    var path: String {
        switch self {
        case .feed:
            return "movie/now_playing"
        case .search:
            return "search/movie"
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
        case .feed:
            let prmDic = [
                "api_key": APIConstants.apiToken,
            ] as [String: Any]

            var items = [URLQueryItem]()
            var myURL = URLComponents(string: endpoint.absoluteString)
            for (key, value) in prmDic {
                items.append(URLQueryItem(name: key, value: "\(value)"))
            }
            myURL?.queryItems = items
            var request = URLRequest(url: myURL!.url!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
            request.httpMethod = method.rawValue
            return request
        case let .search(value):

            let prmDic = [
                "api_key": APIConstants.apiToken,
                "query": value,
            ] as [String: Any]

            var items = [URLQueryItem]()
            var myURL = URLComponents(string: endpoint.absoluteString)
            for (key, value) in prmDic {
                items.append(URLQueryItem(name: key, value: "\(value)"))
            }
            myURL?.queryItems = items
            var request = URLRequest(url: myURL!.url!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
            request.httpMethod = method.rawValue
            return request
        }
    }

    var headers: [String: String]? {
          return ["Content-Type": "application/json;charset=utf-8"]
    }
}
