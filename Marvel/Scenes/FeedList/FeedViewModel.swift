//
//  FeedViewModel.swift
//  Marvel
//
//  Created by abuzeid on 23.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol FeedViewModelType {
    var dataList: [Feed] { get }
    var selectHeroById: PublishSubject<Int> { get }
    var error: PublishSubject<String> { get }
    var isDataLoading: PublishSubject<Bool> { get }
    var reloadFields: PublishSubject<DataChange> { get }
    func loadData()
    func prefetchItemsAt(prefetch: Bool, indexPaths: [IndexPath])
}

final class FeedViewModel: FeedViewModelType {
    var dataList: [Feed] = []
    let debounceTimeInMilliSeconde = 300
    let selectHeroById = PublishSubject<Int>()

    private var characterId: Int!
    let error = PublishSubject<String>()
    let isDataLoading = PublishSubject<Bool>()
    private let disposeBag = DisposeBag()
    private let feedLoader: FeedDataSource
    private var page = Page()

    private(set) var reloadFields = PublishSubject<DataChange>()

    init(loader: FeedDataSource = FeedLoader()) {
        feedLoader = loader
        bindForHeroSelection()
    }

    func loadData() {
        guard let characterId = self.characterId,
            page.shouldLoadMore else {
            return
        }
        page.isFetchingData = true
        isDataLoading.onNext(true)
        feedLoader.loadHeroesFeed(id: characterId, offset: page.offset) { [weak self] data in
            guard let self = self else { return }
            switch data {
            case let .success(response):
                self.updateUI(with: response.feed)
                self.page.updateNewPage(total: response.totalPages, fetched: self.dataList.count)
            case let .failure(error):
                self.error.onNext(error.localizedDescription)
            }
            self.isDataLoading.onNext(false)
        }
    }

    func prefetchItemsAt(prefetch: Bool, indexPaths: [IndexPath]) {
        guard let max = indexPaths.map({ $0.row }).max() else { return }
        if page.fetchedItemsCount <= (max + 1) {
            if prefetch { loadData() }
        }
    }
}

// MARK: private

private extension FeedViewModel {
    func updateUI(with sessions: [Feed]) {
        isDataLoading.onNext(false)
        let startRange = dataList.count
        if page.isFirstPage {
            dataList = sessions
            reloadFields.onNext(.all)
        } else if (dataList.count + sessions.count) > startRange {
            dataList.append(contentsOf: sessions)
            let rows = (startRange ... dataList.count - 1).map { IndexPath(row: $0, section: 0) }
            reloadFields.onNext(.insertItems(rows))
        }
    }

    func bindForHeroSelection() {
        selectHeroById.distinctUntilChanged()
            .debounce(.milliseconds(debounceTimeInMilliSeconde), scheduler: SharingScheduler.make())
            .subscribe(onNext: { [unowned self] id in
                self.characterId = id
                self.page = Page()
                self.dataList.removeAll()
                self.reloadFields.onNext(.all)
                self.loadData()
            }).disposed(by: disposeBag)
    }
}
