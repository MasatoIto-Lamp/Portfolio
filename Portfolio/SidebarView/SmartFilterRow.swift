//
//  SmartFilterRow.swift
//  Portfolio
//
//  Created by イトマサ on 2023/08/04.
//

import SwiftUI

// スマートフィルターを受け取りフィルタ名とアイコンをSidebarに表示するView
struct SmartFilterRow: View {
    // 環境からDataControllerインスタンスを読み取るためのプロパティ
    @EnvironmentObject var dataController: DataController
    
    var filter: Filter
    
    var body: some View {
        NavigationLink(value: filter) {
            Label(LocalizedStringKey(filter.name), systemImage: filter.icon)
                .badge(dataController.activeTaskcount(filter: filter))
                .accessibilityElement()
                .accessibilityLabel(filter.name)
                .accessibilityHint("\(dataController.activeTaskcount(filter: filter)) tasks")
        }
    }
}

struct SmartFilterRow_Previews: PreviewProvider {
    static var previews: some View {
        SmartFilterRow(filter: DataController.preview.selectedFilter!)
            .environmentObject(DataController.preview)
    }
}
