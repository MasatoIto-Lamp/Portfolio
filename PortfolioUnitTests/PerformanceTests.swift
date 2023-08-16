//
//  PerformanceTests.swift
//  PortfolioTests
//
//  Created by イトマサ on 2023/08/07.
//

import XCTest
@testable import Portfolio

// パフォーマンステスト
final class PerformanceTests: BaseTestCase {
    // データベースに大量のデータ(サンプルデータx100セット)を生成
    func testAwardCalculationPerformance() {
        for _ in 1...100 {
            dataController.createSampleData()
        }

        // 大量のアワード(500個)を生成
        let awards = Array(repeating: Award.allAwards, count: 50).joined()
        XCTAssertEqual(awards.count, 500, "This checks the awards count is constant. Change this if you add awards.")

        // 500個のアワード1つ1つに対して、データベースの大量のデータを参照してアワードを取得済みかどうかチェックする動作を行う
        measure {
            _ = awards.filter(dataController.hasEarned)
        }
    }
}
