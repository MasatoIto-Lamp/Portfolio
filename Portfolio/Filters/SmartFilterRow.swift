//
//  SmartFilterRow.swift
//  Portfolio
//
//  Created by イトマサ on 2023/08/04.
//

import SwiftUI
struct SmartFilterRow: View {
    var filter: Filter
    
    var body: some View {
        NavigationLink(value: filter) {
            Label(filter.name, systemImage: filter.icon)
        }
    }
}

struct SmartFilterRow_Previews: PreviewProvider {
    static var previews: some View {
        SmartFilterRow(filter: DataController.preview.selectedFilter!)
    }
}
