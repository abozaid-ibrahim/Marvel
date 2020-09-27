//
//  SQLTableInfo.swift
//  OLXTrack
//
//  Created by abuzeid on 11/21/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
protocol SQLTable {
    static var createStatement: String { get }
}
