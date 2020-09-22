//
//  APIClient.swift
//  Marvel
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//
import Foundation

final class Page {
    let defaultPageIndex = 1
    lazy var currentPage: Int = self.defaultPageIndex
    var totalPages: Int = 5
    var isFetchingData = false
    var fetchedItemsCount = 0
    var shouldLoadMore: Bool {
        (currentPage <= totalPages) && (!isFetchingData)
    }
}
