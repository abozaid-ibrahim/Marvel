//
//  RemoteFeedLoader.swift
//  Marvel
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

final class RemoteFeedLoader: FeedDataSource {
    
    let apiClient: ApiClient
    init(apiClient: ApiClient = HTTPClient()) {
        self.apiClient = apiClient
    }

    func loadHeroesFeed(id: Int,offset: Int, compeletion: @escaping (Result<FeedResponse, Error>) -> Void) {
        let apiEndpoint = HeroesAPI.comics(characterId: id, offset: offset)
        apiClient.getData(of: apiEndpoint) { [weak self] result in
            switch result {
            case let .success(data):
                if let response: FeedJsonResponse = data.parse(),
                    let feed = response.data?.results {
                    compeletion(.success((feed, totalPages: response.data?.total ?? 0)))
                    self?.cachData(feed)
                } else {
                    compeletion(.failure(.failedToParseData))
                }
            case let .failure(error):
                compeletion(.failure(error))
            }
        }
    }

    private func cachData(_ data: [Feed]) {
        DispatchQueue.global().async {
            UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.feedApiLastUpdated.rawValue)
            UserDefaults.standard.synchronize()
            CoreDataHelper.shared.save(data: data, entity: .feed)
        }
    }
}
