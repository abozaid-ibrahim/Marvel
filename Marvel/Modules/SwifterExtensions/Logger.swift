//
//  Logger.swift
//  Marvel
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
enum LoggingLevels {
    var isEnabled: Bool { return false }
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
        if level.isEnabled { print("\(level.value) \(value)") }
    #endif
}
