//
//  DataSource.swift
//  Marvel
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

protocol DataSource {
    func shouldLoadRemotely(for key: UserDefaultsKeys) -> Bool
}

extension DataSource {
    func shouldLoadRemotely(for key: UserDefaultsKeys) -> Bool {
        guard let updateDate = UserDefaults.standard.object(forKey: key.rawValue) as? Date else {
            return true
        }
        let date = Date() - updateDate
        return (date.hours >= 24) && Reachability.shared.hasInternet()
    }
}
