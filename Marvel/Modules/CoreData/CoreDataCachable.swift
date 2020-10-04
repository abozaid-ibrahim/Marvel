//
//  CoreDataCachable.swift
//  Marvel
//
//  Created by abuzeid on 28.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
protocol CoreDataCachable {
    var keyValued: [String: Any] { get }
}

enum UserDefaultsKeys {
    case feedApiLastUpdated(id: Int,offset:Int)
    case heroesApiLastUpdated(offset:Int)
    var key: String {
        switch self {
        case .heroesApiLastUpdated(let offset):
            return "heroesApiLastUpdated\(offset)"
        case let .feedApiLastUpdated(id,offset):
            return "heroesApiLastUpdated_\(id)_\(offset)"
        }
    }
}
