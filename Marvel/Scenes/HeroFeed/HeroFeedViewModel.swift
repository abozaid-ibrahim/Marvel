//
//  HeroFeedViewModel.swift
//  Marvel
//
//  Created by abuzeid on 23.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import RxSwift

protocol HeroFeedViewModelType {
    var dataList: [FeedResult] { get }

    var selectHeroById: PublishSubject<Int> { get }
    var error: PublishSubject<String> { get }
    var searchFor: PublishSubject<String> { get }
    var isDataLoading: PublishSubject<Bool> { get }
    var isSearchLoading: PublishSubject<Bool> { get }
    var reloadFields: PublishSubject<CollectionReload> { get }
    func searchCanceled()
    func loadData()
    func prefetchItemsAt(prefetch: Bool, indexPaths: [IndexPath])
}

final class HeroFeedViewModel: HeroFeedViewModelType {
    var dataList: [FeedResult] = []
    
    let selectHeroById = PublishSubject<Int>()

    private var characterId: Int!
    let error = PublishSubject<String>()
    let searchFor = PublishSubject<String>()
    let isDataLoading = PublishSubject<Bool>()
    let isSearchLoading = PublishSubject<Bool>()
    private let disposeBag = DisposeBag()
    private let apiClient: ApiClient
    private var page = Page()
    private var isSearchingMode = false

    private(set) var reloadFields = PublishSubject<CollectionReload>()

    init(apiClient: ApiClient = HTTPClient()) {
        self.apiClient = apiClient
        bindForSearch()
    }

    func searchCanceled() {
        isSearchingMode = false
        reloadFields.onNext(.all)
    }

    func loadData() {
        guard let characterId = self.characterId,
            page.shouldLoadMore else {
            return
        }
        page.isFetchingData = true
        isDataLoading.onNext(true)

        let apiEndpoint = HeroesAPI.comics(characterId: characterId)
        apiClient.getData(of: apiEndpoint) { [weak self] result in
            switch result {
            case let .success(data):
                let response: FeedResponse? = data.parse()
                self?.updateUI(with: response?.data?.results ?? [])
                self?.updatePage(total: response?.data?.total ?? 0)
            case let .failure(error):
                self?.error.onNext(error.localizedDescription)
                self?.isDataLoading.onNext(false)
            }
        }
    }

    func prefetchItemsAt(prefetch: Bool, indexPaths: [IndexPath]) {
        guard let max = indexPaths.map({ $0.row }).max(), !isSearchingMode else { return }
        if page.fetchedItemsCount <= (max + 1) {
            prefetch ? loadData() : apiClient.cancel()
        }
    }
}

// MARK: private

private extension HeroFeedViewModel {
    func updatePage(total: Int) {
        page.currentPage += 1
        page.isFetchingData = false
        page.totalPages = total
        page.fetchedItemsCount = dataList.count
    }

    func updateUI(with sessions: [FeedResult]) {
        isDataLoading.onNext(false)
        let startRange = dataList.count
        dataList.append(contentsOf: sessions)
        if page.currentPage == 1 {
            reloadFields.onNext(.all)
        } else if dataList.count > startRange {
            let rows = (startRange ... dataList.count - 1).map { IndexPath(row: $0, section: 0) }
            reloadFields.onNext(.insertItems(rows))
        }
    }

    func bindForSearch() {
        selectHeroById.distinctUntilChanged()
            .debounce(.milliseconds(400), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] text in
                self.isSearchLoading.onNext(true)
                self.apiClient.getData(of: HeroesAPI.comics(characterId: text)) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case let .success(data):
                        let response: FeedResponse? = data.parse()
                        self.isSearchingMode = true
                        self.dataList = response?.data?.results ?? []
                        self.reloadFields.onNext(.all)
                        self.isSearchLoading.onNext(false)
                    case let .failure(error):
                        self.error.onNext(error.localizedDescription)
                        self.isSearchLoading.onNext(false)
                    }
                }

            }).disposed(by: disposeBag)
    }
}
