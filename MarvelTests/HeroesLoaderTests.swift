//
//  HeroesLoaderTests.swift
//  MarvelTests
//
//  Created by abuzeid on 27.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

@testable import Marvel
import XCTest

final class HeroesLoaderTests: XCTestCase {
    func testLoadingRightDataSource() throws {
        let feeder = HeroesLoader()
        UserDefaults.standard.set(APIInterval.moreThanDay, forKey: UserDefaultsKeys.heroesApiLastUpdated.key)
        UserDefaults.standard.synchronize()
        XCTAssertEqual(feeder.shouldLoadRemotely(for: .heroesApiLastUpdated, reachable: HasReachability()), true)

        UserDefaults.standard.set(APIInterval.lessThanDay, forKey: UserDefaultsKeys.heroesApiLastUpdated.key)
        UserDefaults.standard.synchronize()
        XCTAssertEqual(feeder.shouldLoadRemotely(for: .heroesApiLastUpdated,
                                                 reachable: HasReachability()), false)
    }

    func testRecachDataWhenReCallThe_HeroesAPI() throws {
        CoreDataHelper.shared.clearCache(for: .heroes)
        let feeder = HeroesLoader(remoteLoader: MockedRemoteHeroesLoader())
        UserDefaults.standard.set(APIInterval.moreThanDay, forKey: UserDefaultsKeys.heroesApiLastUpdated.key)
        UserDefaults.standard.synchronize()
        let loadDataRemotelyExp = expectation(description: "loadDataRemotelyExp")
        XCTAssertEqual(feeder.shouldLoadRemotely(for: .heroesApiLastUpdated, reachable: HasReachability()), true)
        feeder.loadHeroes(offset: 0) { [weak feeder] res in
            guard let feeder = feeder else { return }
            if case let .success(response) = res {
                XCTAssertEqual(response.heroes.count, 20)
            } else {
                XCTFail()
            }
            self.loadDataFromCach(feeder, exp: loadDataRemotelyExp)
        }

        waitForExpectations(timeout: 0.15, handler: nil)
    }

    private func loadDataFromCach(_ feeder: HeroesLoader, exp: XCTestExpectation) {
        feeder.loadHeroes(offset: 0) { res in
            if case let .success(response) = res {
                XCTAssertEqual(response.heroes.count, 20)
            } else {
                XCTFail()
            }
            exp.fulfill()
        }
    }

    func testRecachDataWhenReCallThe_FeedAPI() throws {
        CoreDataHelper.shared.clearCache(for: .feed)
        let feeder = FeedLoader(remoteLoader: MockedRemoteFeedLoader())
        UserDefaults.standard.set(APIInterval.moreThanDay, forKey: UserDefaultsKeys.feedApiLastUpdated(id: 1).key)
        UserDefaults.standard.synchronize()
        let loadDataRemotelyExp = expectation(description: "loadDataRemotelyExp")

        XCTAssertEqual(feeder.shouldLoadRemotely(for: .feedApiLastUpdated(id: 1), reachable: HasReachability()), true)
        feeder.loadHeroesFeed(id: 1, offset: 0) { [weak feeder] res in
            guard let feeder = feeder else { return }
            if case let .success(response) = res {
                XCTAssertEqual(response.feed.count, 20)
            } else {
                XCTFail()
            }
            self.loadFeedDataFromCach(id: 1, feeder, exp: loadDataRemotelyExp)
        }

        waitForExpectations(timeout: 0.15, handler: nil)
    }

    private func loadFeedDataFromCach(id: Int, _ feeder: FeedLoader, exp: XCTestExpectation) {
        feeder.loadHeroesFeed(id: id, offset: 0) { res in
            if case let .success(response) = res {
                XCTAssertEqual(response.feed.count, 20)
            } else {
                XCTFail()
            }
            exp.fulfill()
        }
    }
}
