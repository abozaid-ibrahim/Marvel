//
//  FeedRemoteLoader.swift
//  Marvel
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

final class FeedRemoteLoader: FeedDataSource {
    let apiClient: ApiClient
    init(apiClient: ApiClient = HTTPClient()) {
        self.apiClient = apiClient
    }

    func loadHeroesFeed(id: Int, offset: Int, compeletion: @escaping (Result<FeedResponse, APIError>) -> Void) {
        let apiEndpoint = HeroesAPI.comics(characterId: id, offset: offset)
        apiClient.getData(of: apiEndpoint) { result in
            switch result {
            case let .success(data):
                if let response: FeedJsonResponse = data.parse(),
                    let data = response.data {
                    compeletion(.success((data.results ?? [], totalPages: data.total ?? 0)))
                } else {
                    compeletion(.failure(.failedToParseData))
                }
            case let .failure(error):
                compeletion(.failure(error))
            }
        }
    }
}
