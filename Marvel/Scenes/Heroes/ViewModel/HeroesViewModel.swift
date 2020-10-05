//
//  HeroesViewModel.swift
//  Marvel
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import RxSwift

enum DataChange: Equatable {
    case all
    case insertItems([IndexPath])
}

protocol HeroesViewModelType {
    var dataList: [Hero] { get }
    var error: PublishSubject<String> { get }
    var isDataLoading: PublishSubject<Bool> { get }
    var reloadFields: PublishSubject<DataChange> { get }
    var selectHero: PublishSubject<Int> { get }
    func loadData()
    var currentSelectedIndex: Int { get set }
    func selectHero(at index: Int)
    func prefetchItemsAt(prefetch: Bool, indexPaths: [IndexPath])
}

final class HeroesViewModel: HeroesViewModelType {
    let selectHero = PublishSubject<Int>()
    let error = PublishSubject<String>()
    let isDataLoading = PublishSubject<Bool>()
    private var page = Page()
    var currentSelectedIndex: Int = -1
    private let disposeBag = DisposeBag()
    private let heroesLoader: HeroesDataSource
    private(set) var dataList: [Hero] = []
    private(set) var reloadFields = PublishSubject<DataChange>()

    init(loader: HeroesDataSource = HeroesLoader()) {
        heroesLoader = loader
    }

    func loadData() {
        guard page.shouldLoadMore else {
            return
        }
        page.isFetchingData = true
        isDataLoading.onNext(true)
        heroesLoader.loadHeroes(offset: page.offset) { [weak self] data in
            guard let self = self else { return }
            switch data {
            case let .success(response):
                self.updateUI(with: response.heroes)
                self.page.updateNewPage(total: response.totalPages,
                                        fetched: self.dataList.count)
            case let .failure(error):
                self.error.onNext(error.localizedDescription)
            }
            self.isDataLoading.onNext(false)
        }
    }

    func selectHero(at index: Int) {
        currentSelectedIndex = index
        selectHero.onNext(dataList[index].id)
    }

    func prefetchItemsAt(prefetch: Bool, indexPaths: [IndexPath]) {
        guard let max = indexPaths.map({ $0.row }).max() else { return }
        if page.fetchedItemsCount <= (max + 1) {
            if prefetch { loadData() }
        }
    }
}

// MARK: private

private extension HeroesViewModel {
    func updateUI(with sessions: [Hero]) {
        isDataLoading.onNext(false)
        let startRange = dataList.count
        dataList.append(contentsOf: sessions)
        if page.currentPage == page.firstPageIndex {
            reloadFields.onNext(.all)
        } else if dataList.count > startRange {
            let rows = (startRange ... dataList.count - 1).map { IndexPath(row: $0, section: 0) }
            reloadFields.onNext(.insertItems(rows))
        }
    }
}
