//
//  AwardTests.swift
//  PortfolioTests
//
//  Created by イトマサ on 2023/08/07.
//

import CoreData
import XCTest
@testable import Portfolio

// アワードに関するテスト
final class AwardsTest: BaseTestCase {
    let awards = Award.allAwards

    // アワードIDはアワード名と常に同一であることを確認するためのテスト
    func testAwardIDMatchesName() {
        for award in awards {
            XCTAssertEqual(award.id, award.name, "Award ID should always match its name.")
        }
    }

    // ユーザーがタスクを追加した場合、その数に応じて課題のアワードがアンロックされることをテスト
    func testCreatingIssuesUnlocksAwards() {
        let values = [1, 5, 15, 30, 50]

        for (count, value) in values.enumerated() {
            var issues = [Issue]()

            for _ in 0..<value {
                let issue = Issue(context: managedObjectContext)
                issues.append(issue)
            }

            let matches = awards.filter { award in
                award.criterion == "issues" && dataController.hasEarned(award: award)
            }

            XCTAssertEqual(matches.count, count + 1, "Adding \(value) task should unlock \(count + 1) awards")
            dataController.deleteAll()
        }
    }

    // ユーザーがタスクを完了した場合、その数に応じて課題のアワードがアンロックされることをテスト
    func testClosingIssuesUnlocksAwards() {
        let values = [1, 5, 15, 30, 50]

        for (count, value) in values.enumerated() {
            var issues = [Issue]()

            for _ in 0..<value {
                let issue = Issue(context: managedObjectContext)
                issue.completed = true
                issues.append(issue)
            }

            let matches = awards.filter { award in
                award.criterion == "closed" && dataController.hasEarned(award: award)
            }

            XCTAssertEqual(matches.count, count + 1, "Completing \(value) task should unlock \(count + 1) awards")
            dataController.deleteAll()
        }
    }

}
