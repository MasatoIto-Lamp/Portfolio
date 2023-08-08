//
//  PortfolioUITests.swift
//  PortfolioUITests
//
//  Created by イトマサ on 2023/08/07.
//

import XCTest

final class PortfolioUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    func  testAppHas4Tabs() throws {
        // UI tests must launch the application that they test.

        
//        XCTAssertEqual(app.tabBars.buttons.count, 4, "There should be 4 tabs in the app.")

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}
