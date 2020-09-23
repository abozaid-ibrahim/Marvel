//
//  HeroesAPI.swift
//  Marvel
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

enum HeroesAPI {
    case characters(offset: Int)
    case comics(characterId: Int, offset: Int)
}

extension HeroesAPI: RequestBuilder {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }

    var path: String {
        switch self {
        case .characters:
            return "v1/public/characters"
        case let .comics(id, _):
            return "v1/public/characters/\(id)/comics"
        }
    }

    private var endpoint: URL {
        return URL(string: "\(baseURL)\(path)")!
    }

    var method: HttpMethod {
        return .get
    }

    var parameters: [String: Any] {
        let request = RequestAuth().api
        switch self {
        case let .comics(_, offset):
            return [
                "apikey": APIConstants.publicKey,
                "ts": request.ts,
                "hash": request.hash,
                "offset": offset]
        case let .characters(offset):
            return ["apikey": APIConstants.publicKey,
                    "ts": request.ts,
                    "hash": request.hash,
                    "offset": offset]
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
