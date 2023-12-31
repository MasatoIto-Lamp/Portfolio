//
//  Issue-CoreDataHelpers.swift
//  Portfolio
//
//  Created by イトマサ on 2023/07/21.
//

import Foundation
import SwiftUI

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
        issue.dueDate = .now.addingTimeInterval(86400 * 7)
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
    
    // オプショナルなdueDate属性に対しアンラップ処理を行う
    var issueDueDate: Date {
        get { dueDate ?? .now.addingTimeInterval(86400 * 7) }
        set { dueDate = newValue }
    }
    
    // オプショナルなtags属性に対しアンラップ処理を行う、同時にNSSet型を[Tag]型へキャストする
    var issueTags: [Tag] {
        let result = tags?.allObjects as? [Tag] ?? []
        return result.sorted()
    }
    
    // タスクの状態を文字列で返す
    var issueStatus: String {
        if completed {
            return NSLocalizedString("Closed", comment: "Closed")
        } else {
            return NSLocalizedString("Open", comment: "Open")
        }
    }
    
    // タスクに紐づく全てのタグを結合してString型として返す
    var issueTagsList: String {
        guard let tags else { return "No tags" }

        if tags.count == 0 {
            return "No tags"
        } else {
            return issueTags.map(\.tagName).formatted()
        }
    }
    
    // Issue作成日をDate型からString型へ変換
    var issueFormattedCreationDate: String {
        issueCreationDate.formatted(date: .numeric, time: .omitted)
    }
    
    // Issue期日をDate型からString型へ変換
    var issueFormattedDueDate: String {
        issueDueDate.formatted(date: .numeric, time: .omitted)
    }
}

// フィルタ条件に合うタスクをデータベースから取得した後、ソート処理行うためComparableへ準拠する
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
