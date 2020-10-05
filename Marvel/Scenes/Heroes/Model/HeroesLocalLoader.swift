//
//  HeroesLocalLoader.swift
//  Marvel
//
//  Created by abuzeid on 28.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import CoreData
import Foundation

final class HeroesLocalLoader: HeroesDataSource {
    func loadHeroes(offset: Int, compeletion: @escaping (Result<HeroResponse, APIError>) -> Void) {
        let heroes = CoreDataIO
            .shared
            .load(offset: offset, entity: .heroes)
            .compactMap { $0.toHero }
        compeletion(.success((heroes, heroes.count)))
    }
}
