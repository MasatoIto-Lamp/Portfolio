//
//  Award.swift
//  Portfolio
//
//  Created by イトマサ on 2023/07/30.
//

import Foundation

// アワードデータが入ったJSONファイルに対応するアワードの型
struct Award: Decodable, Identifiable {
    // Preview用Awardインスタンス
    static let allAwards = Bundle.main.decode("Awards.json", as: [Award].self)
    static let example = allAwards[0]
    
    // idはアワード名と同一
    var id: String { name }
    
    // アワード名
    var name: String
    
    // アワードの説明
    var description: String
    
    // アワードの色
    var color: String
    
    // Awardを獲得するためのクライテリア(Issue作成数/Issueクローズ数)
    var criterion: String
    
    // クライテリアの具体的な(Issue作成数/Issueクローズ数)
    var value: Int
    
    // アワードの画像(SFシンボル)
    var image: String
}
