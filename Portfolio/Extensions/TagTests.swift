//
//  TagTests.swift
//  PortfolioTests
//
//  Created by イトマサ on 2023/08/07.
//

import CoreData
import XCTest
@testable import Portfolio

// コアデータのテスト
final class TagTests: BaseTestCase {
    
    // TagとIssueが正しく生成されることをテスト
    func testCreatingTagsAndIssues() {
        let count = 10
        let issueCount = count * count

        for _ in 0..<count {
            let tag = Tag(context: managedObjectContext)

            for _ in 0..<count {
                let issue = Issue(context: managedObjectContext)
                tag.addToIssues(issue)
            }
        }

        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), count, "Expected \(count) tags.")
        XCTAssertEqual(dataController.count(for: Issue.fetchRequest()), issueCount, "Expected \(issueCount) issues.")
    }

    // Tagを削除しても関連するIssueが削除されないことをテスト(nullify削除ルールが有効であるか確認するテスト)
    func testDeletingTagDoesNotDeleteIssues() throws {
        dataController.createSampleData()

        let request = NSFetchRequest<Tag>(entityName: "Tag")
        let tags = try managedObjectContext.fetch(request)

        dataController.delete(tags[0])

        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), 4, "Expected 4 tags after deleting 1.")
        XCTAssertEqual(dataController.count(for: Issue.fetchRequest()), 50, "Expected 50 issues after deleting a tag.")
    }
}
