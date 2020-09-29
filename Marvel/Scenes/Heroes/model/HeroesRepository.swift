//
//  HeroesRepository.swift
//  Marvel
//
//  Created by abuzeid on 27.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
typealias HeroResponse = (heroes: [Hero], totalPages: Int)
protocol HeroesDataSource {
    func loadHeroes(offset: Int, compeletion: @escaping (Result<HeroResponse, Error>) -> Void)
}

final class HeroesLoader: HeroesDataSource {
    let localLoader: HeroesDataSource
    let remoteLoader: HeroesDataSource
    init(localLoader: HeroesDataSource = LocalHeroesLoader(),
         remoteLoader: HeroesDataSource = RemoteHeroesLoader()) {
        self.localLoader = localLoader
        self.remoteLoader = remoteLoader
    }

    var shouldLoadRemotely: Bool {
        // lastCall > 24, db has no data
        return true
    }

    func loadHeroes(offset: Int, compeletion: @escaping (Result<HeroResponse, Error>) -> Void) {
        let loader = shouldLoadRemotely ? remoteLoader : localLoader
        loader.loadHeroes(offset: offset, compeletion: compeletion)
    }
}

final class LocalHeroesLoader: HeroesDataSource {
    func loadHeroes(offset: Int, compeletion: @escaping (Result<HeroResponse, Error>) -> Void) {
    }
}

final class RemoteHeroesLoader: HeroesDataSource {
    let apiClient = HTTPClient()
    func loadHeroes(offset: Int, compeletion: @escaping (Result<HeroResponse, Error>) -> Void) {
        let apiEndpoint = HeroesAPI.characters(offset: offset)
        apiClient.getData(of: apiEndpoint) { result in
            switch result {
            case let .success(data):
                if let response: HeroesResponse = data.parse() {
                    compeletion(.success((response.data?.results ?? [], totalPages: response.data?.total ?? 0)))
                } else {
                    compeletion(.failure(.failedToParseData))
                }
            case let .failure(error):
                compeletion(.failure(error))
            }
        }
    }
}

/*

 switch result {
                   case let .success(data):
                       if let response: HeroesResponse = data.parse() {
                         comp
                           self.updateUI(with: response.data?.results ?? [])
                           self.page.updateNewPage(total: response.data?.total ?? 0,
                                                   fetched: self.dataList.count)
                       } else {
 //                          self.error.onNext(NetworkError.failedToParseData.localizedDescription)
 //                      }
                   case let .failure(error):
 //                      self.error.onNext(error.localizedDescription)
 //                      self.isDataLoading.onNext(false)
                   }
 */
