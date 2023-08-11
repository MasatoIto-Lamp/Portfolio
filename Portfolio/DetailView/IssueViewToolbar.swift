//
//  IssueViewToolbar.swift
//  Portfolio
//
//  Created by イトマサ on 2023/08/04.
//

import SwiftUI

// DetailViewのツールバーを表示するView
struct IssueViewToolbar: View {
    // 環境からDataControllerインスタンスを読み取るためのプロパティ
    @EnvironmentObject var dataController: DataController
    
    // 現在選択されているIssueを保持する
    @ObservedObject var issue: Issue
    
    // DeatiViewツールバー上のClose/Re-Openボタンのラベルで使用する文字列
    var openCloseButtonText: LocalizedStringKey {
        issue.completed ? "Re-open Issue" : "Close Issue"
    }

    // MenuボタンにてIssueのタイトルをコピーするボタン、Close/Reopenのボタンを表示する
    var body: some View {
        Menu {
            Button {
                UIPasteboard.general.string = issue.title
            } label: {
                Label("Copy Issue Title", systemImage: "doc.on.doc")
            }

            Button {
                issue.completed.toggle()
                dataController.save()
            } label: {
                Label(openCloseButtonText, systemImage: "bubble.left.and.exclamationmark.bubble.right")
            }
            
        } label: {
            Label("Actions", systemImage: "ellipsis.circle")
        }
    }
}


struct IssueViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        IssueViewToolbar(issue: Issue.example)
    }
}
