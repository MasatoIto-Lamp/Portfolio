//
//  Tag-CoreDataHelpers.swift
//  Portfolio
//
//  Created by イトマサ on 2023/07/22.
//

import Foundation

extension Tag {
    // Preview用のTagインスタンス
    static var example: Tag {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext

        let tag = Tag(context: viewContext)
        tag.id = UUID()
        tag.name = "Example Tag"
        return tag
    }

    // オプショナルなtagIDプロパティに対しアンラップ処理を行う
    var tagID: UUID {
        id ?? UUID()
    }

    //オプショナルなtagNameプロパティに対しアンラップ処理を行う
    var tagName: String {
        name ?? ""
    }
    
    // オプショナルなissues属性に対しアンラップ処理を行う、同時にNSSet型を[Issue]型へキャストする
    // 更に、クローズしていないIssueのみを抽出して返す
    var tagActiveIssues: [Issue] {
        let result = issues?.allObjects as? [Issue] ?? []
        return result.filter { $0.completed == false }
    }
}

// タグの表示順が不安定にならぬようComparableへ準拠する
extension Tag: Comparable {
    public static func <(lhs: Tag, rhs: Tag) -> Bool {
        let left = lhs.tagName.localizedLowercase
        let right = rhs.tagName.localizedLowercase

        if left == right {
            return lhs.tagID.uuidString < rhs.tagID.uuidString
        } else {
            return left < right
        }
    }
}
