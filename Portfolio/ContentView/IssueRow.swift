//
//  IssueRow.swift
//  Portfolio
//
//  Created by イトマサ on 2023/07/24.
//

import SwiftUI

// ContentViewより特定のIssueを受け取りリストの行を構成するView
struct IssueRow: View {
    // 環境からDataControllerインスタンスを読み取るためのプロパティ
    @EnvironmentObject var dataController: DataController
    
    // ContentViewから渡されるIssueを格納する
    @ObservedObject var issue: Issue
    
    // ContentViewのリストに表示する各行のView
    var body: some View {
        NavigationLink(value: issue) {
            HStack {
                Image(systemName: "exclamationmark.circle")
                    .imageScale(.large)
                    .opacity(issue.priority == 2 ? 1 : 0)

                VStack(alignment: .leading) {
                    Text(issue.issueTitle)
                        .font(.headline)
                        .lineLimit(1)

                    Text(issue.issueTagsList)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(issue.issueFormattedCreationDate)
                        .accessibilityLabel(issue.issueCreationDate.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline)
                    
                    if issue.completed {
                        Text("CLOSED")
                            .font(.body.smallCaps())
                    }
                }
                .foregroundStyle(.secondary)
            }
            .background(dataController.colorForSelectedFilter(issue: issue))
            
        }
        .accessibilityHint(issue.priority == 2 ? "High priority" : "")
    }
}

struct IssueRow_Previews: PreviewProvider {
    static var previews: some View {
        IssueRow(issue: .example)
            .environmentObject(DataController.preview)
    }
}
