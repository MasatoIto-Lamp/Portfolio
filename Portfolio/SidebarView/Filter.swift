//
//  Filter.swift
//  Portfolio
//
//  Created by イトマサ on 2023/07/21.
//

import Foundation

// Issueの絞り込みを行うためのフィルタを新たす構造体
// SidebarViewのフィルタ一覧の表示に利用する
// フィルタ条件に合致するIssueをデータベースから抽出する際に利用する
struct Filter: Identifiable, Hashable {
    // 全てのIssueを表示するためのフィルタ(スマートフィルタ)
    static var all = Filter(
        id: UUID(),
        name: "All Issues",
        icon: "tray")
    
    // 1週間以内に更新されたIssueを表示するためのフィルタ(スマートフィルタ)
    static var recent = Filter(
        id: UUID(),
        name: "Recent Issues",
        icon: "clock",
        minModificationDate: .now.addingTimeInterval(86400 * -7)
    )

    // フィルタID
    var id: UUID
    
    // フィルタ名
    var name: String
    
    // フィルタを表すアイコン名(SFシンボル利用)
    var icon: String
    
    // 直近の更新日(デフォルトは最過去)
    var minModificationDate = Date.distantPast
    
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
