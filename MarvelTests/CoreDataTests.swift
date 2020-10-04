//
//  CoreDataTests.swift
//  MarvelTests
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

@testable import Marvel
import XCTest

final class CoreDataTests: XCTestCase {
    func testSaveAndRetrieveImageFromDB() throws {
        let url = "http://www.google.com/image.png"
        guard let imageData = UIImage(systemName: "folder")?.pngData() else {
            XCTFail("Falied to convert image to data")
            return
        }

        CoreDataHelper.shared.saveImage(url: url, data: imageData)
        XCTAssertEqual(CoreDataHelper.shared.getImage(url: url), imageData)
    }

    func test_DB_CRUD_forHero() throws {
        CoreDataHelper.shared.clearCache(for: .heroes)
        XCTAssertEqual(CoreDataHelper.shared.load(offset: 0, entity: .heroes).count, 0)

        let heroes = [Hero(id: 1, name: "Abozaid", thumbnail: .init(path: "https://www.google.com/imagename", thumbnailExtension: "png")),
                      Hero(id: 2, name: "Abozaid", thumbnail: .init(path: "https://www.google.com/imagename", thumbnailExtension: "png")),
                      Hero(id: 3, name: "Abozaid", thumbnail: .init(path: "https://www.google.com/imagename", thumbnailExtension: "png"))]
        let exp = expectation(description: "Tests")

        CoreDataHelper.shared.save(data: heroes, entity: .heroes, onComplete: { _ in
            XCTAssertEqual(CoreDataHelper.shared.load(offset: 0, entity: .heroes).count, 3)
            exp.fulfill()
        })

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func test_DB_CRUD_forFeed() throws {
        CoreDataHelper.shared.clearCache(for: .feed)
        XCTAssertEqual(CoreDataHelper.shared.load(offset: 0, entity: .feed).count, 0)

        let feed = [Feed(pid: 1, id: 1, title: "Abozaid", modified: nil,
                         thumbnail: .init(path: "https://www.google.com/imagename", thumbnailExtension: "png")),
                    Feed(pid: 1, id: 3, title: "Abozaid", modified: nil,
                         thumbnail: .init(path: "https://www.google.com/imagename", thumbnailExtension: "png")),
                    Feed(pid: 2, id: 2, title: "Abozaid", modified: nil,
                         thumbnail: .init(path: "https://www.google.com/imagename", thumbnailExtension: "png"))]
        let exp = expectation(description: "af")
        CoreDataHelper.shared.save(data: feed, entity: .feed, onComplete: { _ in
            XCTAssertEqual(CoreDataHelper.shared.load(offset: 0, entity: .feed).count, 3)
            XCTAssertEqual(CoreDataHelper.shared.load(offset: 0, entity: .feed, predicate: .feed(pid:1)).count, 2)
            XCTAssertEqual(CoreDataHelper.shared.load(offset: 0, entity: .feed, predicate: .feed(pid:2)).count, 1)
            exp.fulfill()
        })
        wait(for: [exp], timeout: 0.1)
    }
}
