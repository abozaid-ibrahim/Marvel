//
//  HeroFeedViewModelTests.swift
//  MarvelTests
//
//  Created by abuzeid on 24.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import XCTest

@testable import Marvel
import RxCocoa
import RxSwift
import RxTest
import XCTest

final class HeroFeedViewModelTests: XCTestCase {
    private var disposeBag: DisposeBag!
    override func setUp() {
        disposeBag = DisposeBag()
    }

    func testLoadingHeroFeedInCaseMultipleSelectionQuickly() throws {
        let schedular = TestScheduler(initialClock: 0, resolution: 0.001)
        SharingScheduler.mock(scheduler: schedular) {
            let viewModel = HeroFeedViewModel(apiClient: FeedMockedSuccessApi())
            let reloadObserver = schedular.createObserver(CollectionReload.self)
            viewModel.reloadFields.bind(to: reloadObserver).disposed(by: disposeBag)
            schedular.scheduleAt(100, action: { viewModel.selectHeroById.onNext(1) })
            schedular.scheduleAt(200, action: { viewModel.selectHeroById.onNext(2) })
            schedular.scheduleAt(300, action: { viewModel.selectHeroById.onNext(3) })
            schedular.scheduleAt(400, action: { viewModel.selectHeroById.onNext(4) })
            schedular.scheduleAt(701, action: { viewModel.selectHeroById.onNext(5) })
            schedular.scheduleAt(1200, action: { viewModel.selectHeroById.onNext(5) })
            schedular.start()

            XCTAssertEqual(reloadObserver.events, [.next(700, .all), .next(1001, .all)])
            XCTAssertEqual(viewModel.dataList.count, 20)
        }
    }

    func testLoadingMultiplePagesUntilReachTotal() throws {
        let schedular = TestScheduler(initialClock: 0, resolution: 0.001)
        SharingScheduler.mock(scheduler: schedular) {
            let reloadObserver = schedular.createObserver(CollectionReload.self)
            let viewModel = HeroFeedViewModel(apiClient: FeedMockedSuccessApi())
            viewModel.reloadFields.bind(to: reloadObserver).disposed(by: disposeBag)

            schedular.scheduleAt(10, action: { viewModel.selectHeroById.onNext(1) })
            schedular.scheduleAt(311, action: { viewModel.prefetchItemsAt(prefetch: true, indexPaths: [.init(row: 19, section: 0)]) })
            schedular.scheduleAt(400, action: { viewModel.prefetchItemsAt(prefetch: true, indexPaths: [.init(row: 39, section: 0)]) })
            schedular.scheduleAt(500, action: { viewModel.prefetchItemsAt(prefetch: true, indexPaths: [.init(row: 59, section: 0)]) })

            let newItems1 = (20 ... 39).map { IndexPath(row: $0, section: 0) }
            let newItems2 = (40 ... 59).map { IndexPath(row: $0, section: 0) }
            schedular.start()
            XCTAssertEqual(reloadObserver.events, [.next(310, .all),
                                                   .next(311, .insertItems(newItems1)),
                                                   .next(400, .insertItems(newItems2))])
            XCTAssertEqual(viewModel.dataList.count, 60)
        }
    }

    func testPagesLoadingWithHeroChanging() throws {
        let schedular = TestScheduler(initialClock: 0, resolution: 0.001)
        SharingScheduler.mock(scheduler: schedular) {
            let viewModel = HeroFeedViewModel(apiClient: FeedMockedSuccessApi())
            let reloadObserver = schedular.createObserver(CollectionReload.self)
            viewModel.reloadFields.bind(to: reloadObserver).disposed(by: disposeBag)
            schedular.scheduleAt(100, action: { viewModel.selectHeroById.onNext(1) })
            schedular.scheduleAt(500, action: { viewModel.prefetchItemsAt(prefetch: true, indexPaths: [.init(row: 19, section: 0)]) })
            schedular.scheduleAt(600, action: { viewModel.selectHeroById.onNext(2) })
            schedular.start()
            let newItems1 = (20 ... 39).map { IndexPath(row: $0, section: 0) }

            XCTAssertEqual(reloadObserver.events, [.next(400, .all), .next(500, .insertItems(newItems1)), .next(900, .all)])
            XCTAssertEqual(viewModel.dataList.count, 20)
        }
    }

    override func tearDown() {
        disposeBag = nil
    }
}

final class FeedMockedSuccessApi: ApiClient {
    func getData(of request: RequestBuilder, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let feed = FeedResult(id: 1, title: nil, modified: nil, pageCount: nil, thumbnail: nil, images: [])
        let data = FeedDataClass(offset: 0, limit: 20, total: 60, count: 0, results: .init(repeating: feed, count: 20))
        let response = FeedResponse(code: nil, status: nil, copyright: nil, attributionText: nil, attributionHTML: nil, etag: nil, data: data)
        completion(.success(try! JSONEncoder().encode(response)))
    }

    func cancel() {
        // todo
    }
}

extension Double {
    var asTime: Int {
        return TestTime(self)
    }
}
