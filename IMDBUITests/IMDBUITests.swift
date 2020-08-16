//
//  IMDBUITests.swift
//  IMDBUITests
//
//  Created by abuzeid on 13.08.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import XCTest

final class IMDBUITests: XCTestCase {
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
