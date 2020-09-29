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
            XCTFail()
            return
        }

        CoreDataHelper.shared.saveImage(url: url, data: imageData)
        XCTAssertEqual(CoreDataHelper.shared.getImage(url: url), imageData)
    }

    func test_DB_CRUD_forHero() throws {
        CoreDataHelper.shared.clearCache(for: .heroes)
        XCTAssertEqual(CoreDataHelper.shared.load(offset: 0, entity: .heroes).count, 0)

        let heroes = [Hero(id: 1, name: "Abozaid", resultDescription: nil,
                           thumbnail: .init(path: "https://www.google.com/imagename", thumbnailExtension: "png")),
                      Hero(id: 2, name: "Abozaid", resultDescription: nil,
                           thumbnail: .init(path: "https://www.google.com/imagename", thumbnailExtension: "png")),
                      Hero(id: 1, name: "Abozaid", resultDescription: nil,
                           thumbnail: .init(path: "https://www.google.com/imagename", thumbnailExtension: "png"))]
        CoreDataHelper.shared.save(data: heroes, entity: .heroes)
        print(CoreDataHelper.shared.load(offset: 0, entity: .heroes))
        XCTAssertEqual(CoreDataHelper.shared.load(offset: 0, entity: .heroes).count, 2)
    }

    func test_DB_CRUD_forFeed() throws {
        CoreDataHelper.shared.clearCache(for: .feed)
        XCTAssertEqual(CoreDataHelper.shared.load(offset: 0, entity: .feed).count, 0)

        let feed = [Feed(id: 1, title: "Abozaid", modified: nil,
                         thumbnail: .init(path: "https://www.google.com/imagename", thumbnailExtension: "png")),
                    Feed(id: 3, title: "Abozaid", modified: nil,
                         thumbnail: .init(path: "https://www.google.com/imagename", thumbnailExtension: "png")),
                    Feed(id: 3, title: "Abozaid", modified: nil,
                         thumbnail: .init(path: "https://www.google.com/imagename", thumbnailExtension: "png"))]
        CoreDataHelper.shared.save(data: feed, entity: .feed)
        XCTAssertEqual(CoreDataHelper.shared.load(offset: 0, entity: .feed).count, 2)
        XCTAssertEqual(CoreDataHelper.shared.load(offset: 0, entity: .feed, predicate: NSPredicate(format: "id = %i", 1)).count, 1)
    }
}
