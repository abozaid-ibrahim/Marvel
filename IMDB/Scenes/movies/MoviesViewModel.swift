//
//  MoviesViewModel.swift
//  IMDB
//
//  Created by abuzeid on 13.08.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import RxSwift

enum CollectionReload {
    case all
    case insertIndexPaths([IndexPath])
}

protocol MoviesViewModelType {
    var dataList: [Movie] { get }
    var error: PublishSubject<String> { get }
    var searchFor: PublishSubject<String> { get }
    var isDataLoading: PublishSubject<Bool> { get }
    var isSearchLoading: PublishSubject<Bool> { get }
    var reloadFields: PublishSubject<CollectionReload> { get }
    func searchCanceled()
    func loadData()
    func prefetchItemsAt(prefetch: Bool, indexPaths: [IndexPath])
}

final class MoviesViewModel: MoviesViewModelType {
    let error = PublishSubject<String>()
    let searchFor = PublishSubject<String>()
    let isDataLoading = PublishSubject<Bool>()
    let isSearchLoading = PublishSubject<Bool>()
    private let disposeBag = DisposeBag()
    private let apiClient: ApiClient
    private var page = Page()
    private var isSearchingMode = false
    private var sessionsList: [Movie] = []
    private var searchResultList: [Movie] = []

    private(set) var reloadFields = PublishSubject<CollectionReload>()

    init(apiClient: ApiClient = HTTPClient()) {
        self.apiClient = apiClient
        bindForSearch()
    }

    var dataList: [Movie] {
        isSearchingMode ? searchResultList : sessionsList
    }

    func searchCanceled() {
        isSearchingMode = false
        reloadFields.onNext(.all)
    }

    func loadData() {
        guard page.shouldLoadMore else {
            return
        }
        page.isFetchingData = true
        isDataLoading.onNext(true)
        let apiEndpoint = MovieApi.feed(page: page.currentPage, count: page.countPerPage)
        let api: Observable<MoviesResponse?> = apiClient.getData(of: apiEndpoint)
        let concurrentScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        api.subscribeOn(concurrentScheduler)
            .delay(DispatchTimeInterval.seconds(0), scheduler: concurrentScheduler)
            .subscribe(onNext: { [unowned self] response in
                self.updateUI(with: response?.results ?? [])
            }, onError: { [unowned self] err in
                self.error.onNext(err.localizedDescription)
                self.isDataLoading.onNext(false)
            }).disposed(by: disposeBag)
    }

    func prefetchItemsAt(prefetch: Bool, indexPaths: [IndexPath]) {
        guard let max = indexPaths.map({ $0.row }).max() else { return }
        if page.fetchedItemsCount <= (max + 1) {
            prefetch ? loadData() : apiClient.cancel()
        }
    }
}

// MARK: private

private extension MoviesViewModel {
    func updateUI(with sessions: [Movie]) {
        isDataLoading.onNext(false)
        let startRange = sessionsList.count
        sessionsList.append(contentsOf: sessions)
        if page.currentPage == 0 {
            reloadFields.onNext(.all)
        } else {
            let rows = (startRange ... sessionsList.count - 1).map { IndexPath(row: $0, section: 0) }
            reloadFields.onNext(.insertIndexPaths(rows))
        }
        updatePage(with: sessionsList.count)
    }

    func bindForSearch() {
        searchFor.distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] text in
                self.isSearchLoading.onNext(true)
                let endpoint: Observable<Movie?> = self.apiClient.getData(of: MovieApi.search(text))
                endpoint.subscribe(onNext: { [unowned self] value in
                    self.isSearchingMode = true
//                    self.searchResultList = value?.data.sessions ?? []
                    self.reloadFields.onNext(.all)
                    self.isSearchLoading.onNext(false)
                }, onError: { [unowned self] err in
                    self.error.onNext(err.localizedDescription)
                    self.isSearchLoading.onNext(false)
                }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
    }

    func updatePage(with count: Int) {
        page.isFetchingData = false
        page.currentPage += 1
        page.fetchedItemsCount = count
    }
}
