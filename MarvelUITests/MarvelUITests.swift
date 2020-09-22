//
//  MarvelUITests.swift
//  MarvelUITests
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import XCTest

final class MarvelUITests: XCTestCase {
    func testOpenDetailsView() throws {
        let app = XCUIApplication()
        app.launch()
        app.collectionViews
            .children(matching: .cell)
            .element(boundBy: 0)
            .children(matching: .other)
            .element
            .children(matching: .other)
            .element
            .tap()
        XCTAssertTrue(app.otherElements["details_view"].exists)
    }
}
