//
//  TagsMenuView.swift
//  Portfolio
//
//  Created by イトマサ on 2023/08/04.
//

import SwiftUI

// Issueに紐づくタグの削除・追加を行うView
struct TagsMenuView: View {
    // 環境からDataControllerインスタンスを読み取るためのプロパティ
    @EnvironmentObject var dataController: DataController
    
    // 現在選択されているIssueを保持する
    @ObservedObject var issue: Issue
    
    var body: some View {
        Menu {
            // Issueに紐づいているタグを表示する
            ForEach(issue.issueTags) { tag in
                Button {
                    issue.removeFromTags(tag)
                } label: {
                    Label(tag.tagName, systemImage: "checkmark")
                }
            }
            
            // Issueに紐づいていないタグを追加候補として表示する
            let otherTags = dataController.missingTags(from: issue)
            
            if otherTags.isEmpty == false {
                Divider()
                
                Section("Add Tags") {
                    ForEach(otherTags) { tag in
                        Button(tag.tagName) {
                            issue.addToTags(tag)
                        }
                    }
                }
            }
        } label: {
            Text(issue.issueTagsList)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .animation(nil, value: issue.issueTagsList)
        }
    }
}

struct TagsMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TagsMenuView(issue: .example)
    }
}
