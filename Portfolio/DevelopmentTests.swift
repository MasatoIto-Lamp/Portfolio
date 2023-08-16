//
//  DevelopmentTests.swift
//  PortfolioTests
//
//  Created by イトマサ on 2023/08/07.
//

import XCTest
import CoreData
@testable import Portfolio

// 開発中に使うサンプルデータ自体のテスト
final class DevelopmentTests: BaseTestCase {
    
    // サンプルデータとしてTagが5つ、Issueが50個生成されることをテスト
    func testSampleDataCreationWorks() {
        dataController.createSampleData()

        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), 5, "There should be 5 sample tags.")
        XCTAssertEqual(dataController.count(for: Issue.fetchRequest()), 50, "There should be 50 sample issues.")
    }
    
    // サンプルデータの削除コマンドが有効であることをテスト
    func testDeleteAllClearsEverything() {
        dataController.createSampleData()
        dataController.deleteAll()

        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), 0, "deleteAll() should leave 0 tags.")
        XCTAssertEqual(dataController.count(for: Issue.fetchRequest()), 0, "deleteAll() should leave 0 issues.")
    }
    
    // Tagのサンプルデータが正常に生成されていることをテスト
    func testExampleTagHasNoIssues() {
        let tag = Tag.example
        XCTAssertEqual(tag.issues?.count, 0, "The example tag should have 0 issues.")
    }

    // Issueのサンプルデータが正常に生成されていることをテスト
    func testExampleIssueIsHighPriority() {
        let issue = Issue.example
        XCTAssertEqual(issue.priority, 2, "The example issue should be high priority.")
    }
    
}
