//
//  MarvelTests.swift
//  MarvelTests
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

@testable import Marvel
import RxSwift
import RxTest
import XCTest

final class HeroesListViewModelTests: XCTestCase {
    private var disposeBag: DisposeBag!
    override func setUp() {
        disposeBag = DisposeBag()
    }

    func testLoadingFromAPIClient() throws {
        let viewModel = HeroesViewModel(apiClient: HeroesMockedSuccessApi())
        let schedular = TestScheduler(initialClock: 0)
        let reloadObserver = schedular.createObserver(CollectionReload.self)
        viewModel.reloadFields.bind(to: reloadObserver).disposed(by: disposeBag)
        schedular.scheduleAt(0, action: { viewModel.loadData() })
        schedular.start()
        XCTAssertEqual(reloadObserver.events, [.next(0, .all)])
        XCTAssertEqual(viewModel.dataList.count, 20)
    }

    func testLoadingMultiplePages() throws {
        let schedular = TestScheduler(initialClock: 0)
        let reloadObserver = schedular.createObserver(CollectionReload.self)
        let viewModel = HeroesViewModel(apiClient: HeroesMockedSuccessApi())
        viewModel.reloadFields.bind(to: reloadObserver).disposed(by: disposeBag)

        schedular.scheduleAt(1, action: { viewModel.loadData() })
        schedular.scheduleAt(2, action: { viewModel.prefetchItemsAt(prefetch: true, indexPaths: [.init(row: 19, section: 0)]) })
        schedular.scheduleAt(3, action: { viewModel.prefetchItemsAt(prefetch: true, indexPaths: [.init(row: 39, section: 0)]) })
        schedular.scheduleAt(4, action: { viewModel.prefetchItemsAt(prefetch: true, indexPaths: [.init(row: 59, section: 0)]) })

        let newItems1 = (20 ... 39).map { IndexPath(row: $0, section: 0) }
        let newItems2 = (40 ... 59).map { IndexPath(row: $0, section: 0) }
        schedular.start()
        XCTAssertEqual(reloadObserver.events, [.next(1, .all),
                                               .next(2, .insertItems(newItems1)),
                                               .next(3, .insertItems(newItems2))])
    }

    func testAPIFailure() throws {
        let schedular = TestScheduler(initialClock: 0)
        let errorObserver = schedular.createObserver(String.self)
        let viewModel = HeroesViewModel(apiClient: HeroesMockedFailureApi())
        viewModel.error.bind(to: errorObserver).disposed(by: disposeBag)

        schedular.scheduleAt(1, action: { viewModel.loadData() })
        schedular.start()
        XCTAssertEqual(errorObserver.events, [.next(1, NetworkError.failedToParseData.localizedDescription)])
    }

    override func tearDown() {
        disposeBag = nil
    }
}

final class HeroesMockedSuccessApi: ApiClient {
    func getData(of request: RequestBuilder, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let hero = Hero(id: 1, name: "Hello", resultDescription: nil, thumbnail: nil, resourceURI: nil, comics: nil)
        let data = DataClass(offset: 0, limit: 20, total: 60, count: 0, results: .init(repeating: hero, count: 20))
        let response = HeroesResponse(code: 0, status: nil, copyright: nil, attributionText: nil, attributionHTML: nil, etag: nil, data: data)

        completion(.success(try! JSONEncoder().encode(response)))
    }

    func cancel() {
        // todo
    }
}
final class HeroesMockedFailureApi: ApiClient {
    func getData(of request: RequestBuilder, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let data = "{data:1}".data(using: .utf8)
        completion(.success(try! JSONEncoder().encode(data)))
    }

    func cancel() {
        // todo
    }
}
