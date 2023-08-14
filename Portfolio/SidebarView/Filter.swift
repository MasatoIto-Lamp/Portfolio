//
//  Filter.swift
//  Portfolio
//
//  Created by イトマサ on 2023/07/21.
//

import Foundation

// Issueの絞り込みを行うためのフィルタを表す型
struct Filter: Identifiable, Hashable {
    // 全てのIssueを表示するためのフィルタ(スマートフィルタ)
    static var all = Filter(
        id: UUID(),
        name: "All Issues",
        icon: "tray")
    
    // 期限切れのIssueを表示するためのフィルタ(スマートフィルタ)
    static var expired = Filter(
        id: UUID(),
        name: "Expired Issues",
        icon: "calendar.badge.exclamationmark",
        dueDate: .now)
    
    // 本日対応期限のIssueを表示するためのフィルタ(スマートフィルタ)
    static var today = Filter(
        id: UUID(),
        name: "Today's Issues",
        icon: "calendar.badge.exclamationmark",
        dueDate: .now)
    
    // 明日対応期限のIssueを表示するためのフィルタ(スマートフィルタ)
    static var tomorrow = Filter(
        id: UUID(),
        name: "Tomorrow's Issues",
        icon: "calendar.badge.exclamationmark",
        dueDate: .now)
    
    // 1週間以内が対応期限のIssueを表示するためのフィルタ(スマートフィルタ)
    static var inWeek = Filter(
        id: UUID(),
        name: "Weekly Issues",
        icon: "calendar.badge.exclamationmark",
        dueDate: .now)

    // フィルタID
    var id: UUID
    
    // フィルタ名
    var name: String
    
    // フィルタを表すアイコン名(SFシンボル利用)
    var icon: String
    
    // 直近の更新日(デフォルトは最過去)
    var minModificationDate = Date.distantPast
    
    // 対応期限(スマートフィルタ用)
    var dueDate: Date?
    
    // フィルタしたいタグ
    var tag: Tag?
    
    // 指定されたタグに紐づく未解決なIssueの数
    var activeIssuesCount: Int {
        tag?.tagActiveIssues.count ?? 0
    }
    
    // Hashableプロトコルに準拠するためのメソッド
    // ハッシュ値をidから算出するよう指定する
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // Hashableプロトコルへ準拠するためのメソッド
    static func == (lhs: Filter, rhs: Filter) -> Bool {
        lhs.id == rhs.id
    }
}
