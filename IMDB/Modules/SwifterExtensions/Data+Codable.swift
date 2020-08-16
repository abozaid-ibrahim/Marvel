//
//  Data+Codable.swift
//  IMDB
//
//  Created by abuzeid on 16.08.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
extension Data {
    func parse<T: Decodable>() -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: self)
        } catch let error {
            log(error)
        }
        return nil
    }
}
