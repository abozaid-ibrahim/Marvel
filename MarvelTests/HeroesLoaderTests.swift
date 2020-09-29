//
//  HeroesLoaderTests.swift
//  MarvelTests
//
//  Created by abuzeid on 27.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

@testable import Marvel
import XCTest

class HeroesLoaderTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let remote: HeroesDataSource = RemoteHeroesLoader()
        let local: HeroesDataSource = LocalHeroesLoader()
        let feeder = HeroesLoader()

        XCTAssertEqual(feeder.shouldLoadRemotely(for: .feedApiLastUpdated), false)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}

class MockedRemote: HeroesDataSource {
    func loadHeroes(offset: Int, compeletion: @escaping (Result<HeroResponse, Error>) -> Void) {
    }
}

class MockedLocal: HeroesDataSource {
    func loadHeroes(offset: Int, compeletion: @escaping (Result<HeroResponse, Error>) -> Void) {
    }
}
