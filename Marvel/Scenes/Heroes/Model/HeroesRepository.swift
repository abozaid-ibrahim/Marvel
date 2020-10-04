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
    let reachable: Reachable
    init(localLoader: HeroesDataSource = LocalHeroesLoader(),
         remoteLoader: HeroesDataSource = RemoteHeroesLoader(),
         reachable: Reachable = Reachability.shared) {
        self.localLoader = localLoader
        self.remoteLoader = remoteLoader
        self.reachable = reachable
    }

    func loadHeroes(offset: Int, compeletion: @escaping (Result<HeroResponse, Error>) -> Void) {
        let loadRemotely = shouldLoadRemotely(for: .heroesApiLastUpdated(offset: offset), reachable: reachable)
        let loader = loadRemotely ? remoteLoader : localLoader
        loader.loadHeroes(offset: offset) { result in
            if case let .success(data) = result, loadRemotely {
                self.removeOldCachedData()
                self.cachData(for: offset, data.heroes)
            }
            compeletion(result)
        }
    }
}

extension HeroesLoader {
    func cachData(for offset:Int,_ data: [Hero], onComplete: Complation? = nil) {
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.heroesApiLastUpdated(offset: offset).key)
        UserDefaults.standard.synchronize()
        CoreDataHelper.shared.save(data: data, entity: .heroes)
    }

    func removeOldCachedData() {
        CoreDataHelper.shared.clearCache(for: .heroes)
    }
}
