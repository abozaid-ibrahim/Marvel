//
//  RemoteFeedLoader.swift
//  Marvel
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

class RemoteFeedLoader: FeedDataSource {
    let apiClient: ApiClient
    init(apiClient: ApiClient = HTTPClient()) {
        self.apiClient = apiClient
    }

    func loadHeroesFeed(id: Int, offset: Int, compeletion: @escaping (Result<FeedResponse, Error>) -> Void) {
        let apiEndpoint = HeroesAPI.comics(characterId: id, offset: offset)
        apiClient.getData(of: apiEndpoint) { result in
            switch result {
            case let .success(data):
                if let response: FeedJsonResponse = data.parse(),
                    let feed = response.data?.results {
                    compeletion(.success((feed, totalPages: response.data?.total ?? 0)))
                } else {
                    compeletion(.failure(.failedToParseData))
                }
            case let .failure(error):
                compeletion(.failure(error))
            }
        }
    }
}
