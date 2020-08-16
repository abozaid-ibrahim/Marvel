//
//  IMDBTests.swift
//  IMDBTests
//
//  Created by abuzeid on 13.08.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

@testable import IMDB
import RxSwift
import RxTest
import XCTest

final class MoviesListViewModelTests: XCTestCase {
    private var disposeBag: DisposeBag!
    override func setUp() {
        disposeBag = DisposeBag()
    }

    func testLoadingDataFromAPIClient() throws {
        let viewModel = MoviesViewModel(apiClient: MockedSuccessApi())
        let schedular = TestScheduler(initialClock: 0)
        let reloadObserver = schedular.createObserver(CollectionReload.self)
        viewModel.reloadFields.bind(to: reloadObserver).disposed(by: disposeBag)
        schedular.scheduleAt(0, action: { viewModel.loadData() })
        schedular.start()
        XCTAssertEqual(reloadObserver.events, [.next(0, .all)])
        XCTAssertEqual(viewModel.dataList.count, 10)
    }

    func testLoadingMultiplePages() throws {
        let schedular = TestScheduler(initialClock: 0)
        let reloadObserver = schedular.createObserver(CollectionReload.self)
        let viewModel = MoviesViewModel(apiClient: MockedSuccessApi())
        viewModel.reloadFields.bind(to: reloadObserver).disposed(by: disposeBag)

        schedular.scheduleAt(1, action: { viewModel.loadData() })
        schedular.scheduleAt(2, action: { viewModel.prefetchItemsAt(prefetch: true, indexPaths: [.init(row: 9, section: 0)]) })
        schedular.scheduleAt(3, action: { viewModel.prefetchItemsAt(prefetch: true, indexPaths: [.init(row: 19, section: 0)]) })

        let newItems1 = (10 ... 19).map { IndexPath(row: $0, section: 0) }
        let newItems2 = (20 ... 29).map { IndexPath(row: $0, section: 0) }
        schedular.start()
        XCTAssertEqual(reloadObserver.events, [.next(1, .all),
                                               .next(2, .insertIndexPaths(newItems1)),
                                               .next(3, .insertIndexPaths(newItems2))])
    }


    override func tearDown() {
        disposeBag = nil
    }
}

final class MockedSuccessApi: ApiClient {
    func getData(of request: RequestBuilder, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let movie = Movie(posterPath: nil,
                          adult: false,
                          overview: nil,
                          releaseDate: nil,
                          genreIDS: [],
                          id: 0,
                          originalTitle: "Hello",
                          originalLanguage: nil,
                          title: nil,
                          backdropPath: nil,
                          popularity: 0,
                          voteCount: 1,
                          video: true,
                          voteAverage: 3.2)
        let response = MoviesResponse(page: 1,
                                      results: .init(repeating: movie, count: 10),
                                      dates: nil,
                                      totalPages: 3,
                                      totalResults: 30)

        completion(.success(try! JSONEncoder().encode(response)))
    }

    func cancel() {
        // todo
    }
}
