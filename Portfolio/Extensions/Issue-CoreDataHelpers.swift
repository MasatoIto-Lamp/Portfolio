//
//  Issue-CoreDataHelpers.swift
//  Portfolio
//
//  Created by イトマサ on 2023/07/21.
//

import Foundation

extension Issue {
    // Preview用のIssueインスタンス
    static var example: Issue {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext

        let issue = Issue(context: viewContext)
        issue.title = "Example Issue"
        issue.content = "This is an example issue."
        issue.priority = 2
        issue.creationDate = .now
        issue.completed = false
        return issue
    }
    
    // オプショナルなtitleプロパティに対しアンラップ処理を行う
    var issueTitle: String {
        get { title ?? "" }
        set { title = newValue }
    }
    
    // オプショナルなcontentプロパティに対しアンラップ処理を行う
    var issueContent: String {
        get { content ?? "" }
        set { content = newValue }
    }

    // オプショナルなcreationDateプロパティに対しアンラップ処理を行う
    var issueCreationDate: Date {
        creationDate ?? .now
    }
    
    // オプショナルなmodificationDate属性に対しアンラップ処理を行う
    var issueModificationDate: Date {
        modificationDate ?? .now
    }
    
    // オプショナルなtags属性に対しアンラップ処理を行う、同時にNSSet型を[Tag]型へキャストする
    var issueTags: [Tag] {
        let result = tags?.allObjects as? [Tag] ?? []
        return result.sorted()
    }
    
    var issueStatus: String {
        if completed {
            return "Closed"
        } else {
            return "Open"
        }
    }
    
    var issueTagsList: String {
        guard let tags else { return "No tags" }

        if tags.count == 0 {
            return "No tags"
        } else {
            return issueTags.map(\.tagName).formatted()
        }
    }
    
    var issueFormattedCreationDate: String {
        issueCreationDate.formatted(date: .numeric, time: .omitted)
    }
}

// フィルタ条件に合うIssueをデータベースから取得した後、ソート処理行うためComparableへ準拠する
extension Issue: Comparable {
    public static func < (lhs: Issue, rhs: Issue) -> Bool {
        let left = lhs.issueTitle.localizedLowercase
        let right = rhs.issueTitle.localizedLowercase

        if left == right {
            return lhs.issueCreationDate < rhs.issueCreationDate
        } else {
            return left < right
        }
    }
}
