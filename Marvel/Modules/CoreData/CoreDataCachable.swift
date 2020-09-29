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

enum UserDefaultsKeys: String {
    case feedApiLastUpdated
    case heroesApiLastUpdated
}
