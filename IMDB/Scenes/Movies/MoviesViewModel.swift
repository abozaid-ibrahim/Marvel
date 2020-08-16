//
//  MoviesViewModel.swift
//  IMDB
//
//  Created by abuzeid on 13.08.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import RxSwift

enum CollectionReload: Equatable {
    case all
    case insertItems([IndexPath])
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
    private var moviesList: [Movie] = []
    private var searchResultList: [Movie] = []

    private(set) var reloadFields = PublishSubject<CollectionReload>()

    init(apiClient: ApiClient = HTTPClient()) {
        self.apiClient = apiClient
        bindForSearch()
    }

    var dataList: [Movie] {
        isSearchingMode ? searchResultList : moviesList
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
        let apiEndpoint = MovieApi.nowPlaying(page: page.currentPage)
        apiClient.getData(of: apiEndpoint) { [weak self] result in
            switch result {
            case let .success(data):
                let response: MoviesResponse? = data.parse()
                self?.updateUI(with: response?.results ?? [])
                self?.updatePage(total: response?.totalPages ?? 0)
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

private extension MoviesViewModel {
    func updatePage(total: Int) {
        page.currentPage += 1
        page.isFetchingData = false
        page.totalPages = total
        page.fetchedItemsCount = moviesList.count
    }

    func updateUI(with sessions: [Movie]) {
        isDataLoading.onNext(false)
        let startRange = moviesList.count
        moviesList.append(contentsOf: sessions)
        if page.currentPage == 1 {
            reloadFields.onNext(.all)
        } else if moviesList.count > startRange {
            let rows = (startRange ... moviesList.count - 1).map { IndexPath(row: $0, section: 0) }
            reloadFields.onNext(.insertItems(rows))
        }
    }

    func bindForSearch() {
        searchFor.distinctUntilChanged()
            .filter { !$0.isEmpty }
            .debounce(.milliseconds(400), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] text in
                self.isSearchLoading.onNext(true)
                self.apiClient.getData(of: MovieApi.search(text)) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case let .success(data):
                        let response: MoviesResponse? = data.parse()
                        self.isSearchingMode = true
                        self.searchResultList = response?.results ?? []
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
