//
//  APIClient.swift
//  IMDB
//
//  Created by abuzeid on 13.08.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//
import Foundation
import Foundation

final class Page {
    var currentPage: Int = 1
    var totalPages: Int = 5
    var countPerPage: Int = 10
    var isFetchingData = false
    var fetchedItemsCount = 0
    var shouldLoadMore: Bool {
        (currentPage <= totalPages) && (!isFetchingData)
    }
}
