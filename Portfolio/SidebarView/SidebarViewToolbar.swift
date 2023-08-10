//
//  SidebarViewToolbar.swift
//  Portfolio
//
//  Created by イトマサ on 2023/08/03.
//

import SwiftUI

struct SidebarViewToolbar: View {
    @EnvironmentObject var dataController: DataController
    @Binding var showingAwards: Bool
    
    // SidebarViewのツールバーを表示するView
    var body: some View {
        
#if DEBUG
        // データベース上のTag、Issueの全データを削除し、サンプルデータへ置き換える
        // Simulatorでのデバッグ用機能
        Button {
            dataController.deleteAll()
            dataController.createSampleData()
        } label: {
            Label("ADD SAMPLES", systemImage: "flame")
        }
#endif
        // ユーザフィルタ(Tag)を追加する
        Button(action: dataController.newTag) {
            Label("Add tag", systemImage: "plus")
        }
        
        // AwardsViewを表示する
        Button {
            showingAwards.toggle()
        } label: {
            Label("Show awards", systemImage: "rosette")
        }
    }
}

struct SidebarViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        SidebarViewToolbar(showingAwards: .constant(true))
            .environmentObject(DataController.preview)
    }
}
