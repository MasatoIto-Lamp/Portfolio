//
//  PerformanceTests.swift
//  PortfolioTests
//
//  Created by イトマサ on 2023/08/07.
//

import XCTest
@testable import Portfolio

final class PerformanceTests: BaseTestCase {
    // Create a significant amount of test data
    func testAwardCalculationPerformance() {
        for _ in 1...100 {
            dataController.createSampleData()
        }

        // Simulate lots of awards to check
        let awards = Array(repeating: Award.allAwards, count: 25).joined()
        XCTAssertEqual(awards.count, 500, "This checks the awards count is constant. Change this if you add awards.")

        measure {
            _ = awards.filter(dataController.hasEarned)
        }
    }
}
