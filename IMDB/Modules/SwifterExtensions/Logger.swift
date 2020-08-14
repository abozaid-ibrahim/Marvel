//
//  Logger.swift
//  IMDB
//
//  Created by abuzeid on 13.08.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
enum LoggingLevels {
    case info, error
    var value: String {
        switch self {
        case .info:
            return ">INFO>"
        case .error:
            return ">>ERROR>"
        }
    }
}

func log(_ value: Any?..., level: LoggingLevels = .info) {
    #if DEBUG
        print("\(level.value) \(value)")
    #endif
}
