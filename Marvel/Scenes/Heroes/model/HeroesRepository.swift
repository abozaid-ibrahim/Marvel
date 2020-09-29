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

final class HeroesLoader: HeroesDataSource, DataSource {
    let localLoader: HeroesDataSource
    let remoteLoader: HeroesDataSource
    init(localLoader: HeroesDataSource = LocalHeroesLoader(),
         remoteLoader: HeroesDataSource = RemoteHeroesLoader()) {
        self.localLoader = localLoader
        self.remoteLoader = remoteLoader
    }

    func loadHeroes(offset: Int, compeletion: @escaping (Result<HeroResponse, Error>) -> Void) {
        let loader = shouldLoadRemotely(for: .heroesApiLastUpdated) ? remoteLoader : localLoader
        loader.loadHeroes(offset: offset, compeletion: compeletion)
    }
}
