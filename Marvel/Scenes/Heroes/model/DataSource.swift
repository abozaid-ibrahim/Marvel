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
        return false
        guard let updateDate = UserDefaults.standard.object(forKey: key.rawValue) as? Date,
            let callTimePlusDay = Calendar.current.date(byAdding: .hour, value: 24, to: updateDate) else {
            return false
        }
        let remote = callTimePlusDay > Date() && Reachability.shared.hasInternet()

        if remote {
            DispatchQueue.global().async {
                CoreDataHelper.shared.clearCache(for: .feed)
                CoreDataHelper.shared.clearCache(for: .heroes)
            }
        }
        return remote
    }
}
