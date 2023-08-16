//
//  AssetTests.swift
//  PortfolioTests
//
//  Created by イトマサ on 2023/08/07.
//

import XCTest
@testable import Portfolio

// アプリで使用するアセットが利用できることを確認するテスト
class AssetTests: XCTestCase {

    // アプリで使用する全ての色がアセットに登録されていることを確認するテスト
    func testColorsExist() {
        let allColors = ["Dark Blue", "Dark Gray", "Gold", "Gray", "Green",
                         "Light Blue", "Midnight", "Orange", "Pink", "Purple", "Red", "Teal"]

        for color in allColors {
            XCTAssertNotNil(UIColor(named: color), "Failed to load color '\(color)' from asset catalog.")
        }
    }

    // JOSNファイルからアワードデータをロードできていることを確認するテスト
    func testAwardsLoadCorrectly() {
        XCTAssertTrue(Award.allAwards.isEmpty == false, "Failed to load awards from JSON.")
    }
}
