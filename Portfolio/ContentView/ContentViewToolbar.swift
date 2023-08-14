//
//  ContentViewToolbar.swift
//  Portfolio
//
//  Created by イトマサ on 2023/08/04.
//

import SwiftUI

// ContentViewのツールバーを表示するView
struct ContentViewToolbar: View {
    // 環境からDataControllerインスタンスを読み取るためのプロパティ
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        // Issueを新規追加するボタン
        Button(action: dataController.newIssue) {
            Label("New Issue", systemImage: "square.and.pencil")
        }
        
        // ソート順を設定するMenuボタン
        Menu {
            Menu("Sort By") {
                Picker("Sort By", selection: $dataController.sortType) {
                    Text("Date Created").tag(SortType.dateCreated)
                    Text("Date Modified").tag(SortType.dateModified)
                    Text("Due Date").tag(SortType.dueDate)
                }
                
                Divider()
                
                Picker("Sort Order", selection: $dataController.sortNewestFirst) {
                    Text("Newest to Oldest").tag(true)
                    Text("Oldest to Newest").tag(false)
                }
            }
        } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down")
        }

        // フィルターを設定するMenuボタン
        Menu {
            Button(dataController.filterEnabled ? "Turn Filter Off" : "Turn Filter On") {
                dataController.filterEnabled.toggle()
            }
            
            Divider()
            
            Picker("Status", selection: $dataController.filterStatus) {
                Text("All").tag(Status.all)
                Text("Open").tag(Status.open)
                Text("Closed").tag(Status.closed)
            }
            .disabled(dataController.filterEnabled == false)
            
            Picker("Priority", selection: $dataController.filterPriority) {
                Text("All").tag(-1)
                Text("Low").tag(0)
                Text("Medium").tag(1)
                Text("High").tag(2)
            }
            .disabled(dataController.filterEnabled == false)
            
        } label: {
            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                .symbolVariant(dataController.filterEnabled ? .fill : .none)
        }
    }
}

struct ContentViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewToolbar()
            .environmentObject(DataController.preview)
    }
}
