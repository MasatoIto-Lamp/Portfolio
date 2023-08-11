//
//  NoIssueView.swift
//  Portfolio
//
//  Created by イトマサ on 2023/07/24.
//

import SwiftUI

// ContentViewにてIssueが選択されていない場合に表示するView
struct NoIssueView: View {
    // 環境からDataControllerインスタンスを読み取るためのプロパティ
    @EnvironmentObject var dataController: DataController

    var body: some View {
        Text("No Issue Selected")
            .font(.title)
            .foregroundStyle(.secondary)

        Button("New Issue", action: dataController.newIssue)
    }
}

struct NoIssueView_Previews: PreviewProvider {
    static var previews: some View {
        NoIssueView()
            .environmentObject(DataController.preview)
    }
}
