//
//  DataExtension.swift
//  IMDB
//
//  Created by abuzeid on 13.08.20.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
extension Data {
    func toModel<T: Decodable>() -> T? {
        return try? JSONDecoder().decode(T.self, from: self)
    }

    var toString: String {
        return String(data: self, encoding: .utf8) ?? ""
    }
}
