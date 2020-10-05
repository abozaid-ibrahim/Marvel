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

final class HeroesViewModelTests: XCTestCase {
    private var disposeBag: DisposeBag!
    private var viewModel: HeroesViewModel!
    override func setUp() {
        let loader = HeroesLoader(remoteLoader: HeroesRemoteLoader(apiClient: MockedSuccessAPIClient()), reachable: HasReachability())
        viewModel = HeroesViewModel(loader: loader)
        disposeBag = DisposeBag()
    }

    private func setShouldLoadRemotely(_ remote: Bool) {
        UserDefaults.standard.set(APIInterval.moreThanDay, forKey: UserDefaultsKeys.heroesApiLastUpdated(offset: 0).key)
        UserDefaults.standard.set(APIInterval.moreThanDay, forKey: UserDefaultsKeys.heroesApiLastUpdated(offset: 20).key)
        UserDefaults.standard.set(APIInterval.moreThanDay, forKey: UserDefaultsKeys.heroesApiLastUpdated(offset: 40).key)
        UserDefaults.standard.synchronize()
    }

    func testLoadingFromAPIClient() throws {
        setShouldLoadRemotely(true)
        let schedular = TestScheduler(initialClock: 0)
        let reloadObserver = schedular.createObserver(DataChange.self)
        viewModel.reloadFields.bind(to: reloadObserver).disposed(by: disposeBag)
        schedular.scheduleAt(0, action: { self.viewModel.loadData() })
        schedular.start()
        XCTAssertEqual(reloadObserver.events, [.next(0, .all)])
        XCTAssertEqual(viewModel.dataList.count, 3)
    }

    func testLoadingMultiplePages() throws {
        setShouldLoadRemotely(true)
        let schedular = TestScheduler(initialClock: 0)
        let reloadObserver = schedular.createObserver(DataChange.self)
        viewModel.reloadFields.bind(to: reloadObserver).disposed(by: disposeBag)

        schedular.scheduleAt(1, action: { self.viewModel.loadData() })
        schedular.scheduleAt(2, action: { prefetch(row: 2) })
        schedular.scheduleAt(3, action: { prefetch(row: 5) })

        let newItems1 = [3, 4, 5].map { IndexPath(row: $0, section: 0) }
        let newItems2 = [6, 7, 8].map { IndexPath(row: $0, section: 0) }
        schedular.start()
        XCTAssertEqual(reloadObserver.events, [.next(1, .all),
                                               .next(2, .insertItems(newItems1)),
                                               .next(3, .insertItems(newItems2))])
        func prefetch(row: Int) {
            viewModel.prefetchItemsAt(prefetch: true, indexPaths: [.init(row: row, section: 0)])
        }
    }

    func testAPIFailure() throws {
        setShouldLoadRemotely(true)
        let schedular = TestScheduler(initialClock: 0)
        let errorObserver = schedular.createObserver(String.self)
        let loader = HeroesLoader(remoteLoader: HeroesRemoteLoader(apiClient: MockedFailureApi()),
                                  reachable: HasReachability())
        let viewModel = HeroesViewModel(loader: loader)
        viewModel.error.bind(to: errorObserver).disposed(by: disposeBag)

        schedular.scheduleAt(1, action: { viewModel.loadData() })
        schedular.start()
        XCTAssertEqual(errorObserver.events, [.next(1, APIError.failedToParseData.localizedDescription)])
    }

    override func tearDown() {
        disposeBag = nil
        viewModel = nil
    }
}
