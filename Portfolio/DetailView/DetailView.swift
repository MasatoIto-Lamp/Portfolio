//
//  DetailView.swift
//  Portfolio
//
//  Created by イトマサ on 2023/07/21.
//

import SwiftUI

// ContentViewで選択したIssueの詳細情報を表示するView
struct DetailView: View {
    // 環境からDataControllerインスタンスを読み取るためのプロパティ
    @EnvironmentObject var dataController: DataController

    // Issue選択中or未選択によって表示するViewを切り替える
    var body: some View {
        VStack {
            if let issue = dataController.selectedIssue {
                IssueView(issue: issue)
            } else {
                NoIssueView()
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
            .environmentObject(DataController.preview)
    }
}
