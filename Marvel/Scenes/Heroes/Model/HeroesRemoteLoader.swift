//
//  HeroesRemoteLoader.swift
//  Marvel
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

 class HeroesRemoteLoader: HeroesDataSource {
    let apiClient: ApiClient
    init(apiClient: ApiClient = HTTPClient()) {
        self.apiClient = apiClient
    }

    func loadHeroes(offset: Int, compeletion: @escaping (Result<HeroResponse, APIError>) -> Void) {
        let apiEndpoint = HeroesAPI.characters(offset: offset)
        apiClient.getData(of: apiEndpoint) { result in
            switch result {
            case let .success(data):
                if let response: HeroesResponse = data.parse(),
                    let heroes = response.data?.results {
                    compeletion(.success((heroes, totalPages: response.data?.total ?? 0)))
                } else {
                    compeletion(.failure(.failedToParseData))
                }
            case let .failure(error):
                compeletion(.failure(error))
            }
        }
    }
}
