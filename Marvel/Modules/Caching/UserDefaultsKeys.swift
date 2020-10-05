//
//  CoreDataCachable.swift
//  Marvel
//
//  Created by abuzeid on 28.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

enum UserDefaultsKeys {
    case feedApiLastUpdated(id: Int, offset: Int)
    case heroesApiLastUpdated(offset: Int)
    var key: String {
        switch self {
        case let .heroesApiLastUpdated(offset):
            return "heroesApiLastUpdated\(offset)"
        case let .feedApiLastUpdated(id, offset):
            return "heroesApiLastUpdated_\(id)_\(offset)"
        }
    }
}
