//
//  RemoteHeroesLoader.swift
//  Marvel
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

final class RemoteHeroesLoader: HeroesDataSource {
    let apiClient: ApiClient
    init(apiClient: ApiClient = HTTPClient()) {
        self.apiClient = apiClient
    }

    func loadHeroes(offset: Int, compeletion: @escaping (Result<HeroResponse, Error>) -> Void) {
        let apiEndpoint = HeroesAPI.characters(offset: offset)
        apiClient.getData(of: apiEndpoint) { [weak self] result in
            switch result {
            case let .success(data):
                if let response: HeroesResponse = data.parse(),
                    let heroes = response.data?.results {
                    compeletion(.success((heroes, totalPages: response.data?.total ?? 0)))
                    self?.cachData(heroes)
                } else {
                    compeletion(.failure(.failedToParseData))
                }
            case let .failure(error):
                compeletion(.failure(error))
            }
        }
    }

    private func cachData(_ data: [Hero]) {
        DispatchQueue.global().async {
            UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.heroesApiLastUpdated.rawValue)
            UserDefaults.standard.synchronize()
            CoreDataHelper.shared.save(data: data, entity: .heroes)
        }
    }
}
