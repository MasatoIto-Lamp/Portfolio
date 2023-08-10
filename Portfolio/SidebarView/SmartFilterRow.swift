//
//  SmartFilterRow.swift
//  Portfolio
//
//  Created by イトマサ on 2023/08/04.
//

import SwiftUI

// スマートフィルターを受け取りフィルタ名とアイコンを表示するView
struct SmartFilterRow: View {
    var filter: Filter
    
    var body: some View {
        NavigationLink(value: filter) {
            Label(LocalizedStringKey(filter.name), systemImage: filter.icon)
        }
    }
}

struct SmartFilterRow_Previews: PreviewProvider {
    static var previews: some View {
        SmartFilterRow(filter: DataController.preview.selectedFilter!)
    }
}
