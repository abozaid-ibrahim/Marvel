//
//  DataSource.swift
//  Marvel
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

protocol DataSource {
    func shouldLoadRemotely(for key: UserDefaultsKeys, reachable: Reachable) -> Bool
}

extension DataSource {
    func shouldLoadRemotely(for key: UserDefaultsKeys, reachable: Reachable = Reachability.shared) -> Bool {
        guard let updateDate = UserDefaults.standard.object(forKey: key.key) as? Date,
            let callTimePlusDay = Calendar.current.date(byAdding: .hour, value: 24, to: updateDate) else {
            return true
        }
        return callTimePlusDay <= Date() && reachable.hasInternet()
    }
}
