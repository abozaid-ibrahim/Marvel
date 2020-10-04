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
    case feedApiLastUpdated(id:Int)
    case heroesApiLastUpdated
    var key:String{
        switch self {
        case .heroesApiLastUpdated:
            return "heroesApiLastUpdated"
        case .feedApiLastUpdated(let id):
            return "heroesApiLastUpdated_\(id)"
        }
    }
}
