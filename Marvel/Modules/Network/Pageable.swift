//
//  APIClient.swift
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//
import Foundation

final class Page {
    let firstPageIndex = 0
    let pageSize = 20
    lazy var currentPage: Int = self.firstPageIndex
    var totalItemsCount: Int = 5
    var isFetchingData = false
    var fetchedItemsCount = 0
    var shouldLoadMore: Bool {
        (fetchedItemsCount < totalItemsCount) && (!isFetchingData)
    }

    var offset: Int { currentPage * pageSize }
    var isFirstPage: Bool {
        return currentPage == firstPageIndex
    }

    func updateNewPage(total: Int, fetched: Int) {
        currentPage += 1
        isFetchingData = false
        totalItemsCount = total
        fetchedItemsCount = fetched
    }
}
