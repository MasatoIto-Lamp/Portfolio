//
//  IssueView.swift
//  Portfolio
//
//  Created by イトマサ on 2023/07/24.
//

import SwiftUI

// ContentViewにてIssueが選択されている場合に詳細情報を表示する画面
// Issueのタイトル、内容、優先度、タグ、ステータスなど各情報の更新が可能
struct IssueView: View {
    // 環境からDataControllerインスタンスを読み取るためのプロパティ
    @EnvironmentObject var dataController: DataController
    
    // 現在選択されているIssueを保持する
    @ObservedObject var issue: Issue
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    TextField(
                        "Title",
                        text: $issue.issueTitle,
                        prompt: Text("Enter the issue title here")
                    )
                    .font(.title)
                    
                    Text("**Modified:** \(issue.issueModificationDate.formatted(date: .long, time: .shortened))")
                        .foregroundStyle(.secondary)
                    
                    Text("**Status:** \(issue.issueStatus)")
                        .foregroundStyle(.secondary)
                }
                
                Picker("Priority", selection: $issue.priority) {
                    Text("Low").tag(Int16(0))
                    Text("Medium").tag(Int16(1))
                    Text("High").tag(Int16(2))
                }
                
                TagsMenuView(issue: issue)
            }
            
            Section {
                VStack(alignment: .leading) {
                    Text("Basic Information")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    
                    TextField(
                        "Description",
                        text: $issue.issueContent,
                        prompt: Text("Enter the issue description here"),
                        axis: .vertical
                    )
                }
            }
        }
        .disabled(issue.isDeleted)
        // Issueの情報が更新された際に保存処理を行う
        .onReceive(issue.objectWillChange) { _ in
            dataController.queueSave()
        }
        .toolbar {
            IssueViewToolbar(issue: issue)
        }
    }
}

struct IssueView_Previews: PreviewProvider {
    static var previews: some View {
        IssueView(issue: .example)
            .environmentObject(DataController.preview)
    }
}
