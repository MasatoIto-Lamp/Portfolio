//
//  SidebarView.swift
//  Portfolio
//
//  Created by イトマサ on 2023/07/21.
//

import SwiftUI

// Issueを絞り込むためのフィルタ(スマートフィルタ、ユーザフィルタ)を表示するView
struct SidebarView: View {
    // 環境からDataControllerインスタンスを読み取るためのプロパティ
    @EnvironmentObject var dataController: DataController
    
    // データベースから全てのTagを取得し格納
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var tags: FetchedResults<Tag>
    
    @State private var tagToRename: Tag?
    @State private var renamingTag = false
    @State private var tagName = ""
    
    // AwardsViewをシート表示するためのトリガー
    @State private var showingAwards = false
    
    // スマートフィルタを格納
    let smartFilters: [Filter] = [.all, .recent]
    
    // データベースから取得したTagをFilterへ変換
    var tagFilters: [Filter] {
        tags.map { tag in
            Filter(id: tag.tagID, name: tag.tagName, icon: "tag", tag: tag)
        }
    }
    
    // スマートフィルタ(全Issue、直近1週間)とユーザフィルタ(Tag)を表示するView
    var body: some View {
        List(selection: $dataController.selectedFilter) {
            Section("Smart Filters") {
                ForEach(smartFilters, content: SmartFilterRow.init)
            }
            
            Section("Tags") {
                ForEach(tagFilters) { filter in
                    UserFilterRow(filter: filter, rename: rename, delete: delete)
                }
                .onDelete(perform: delete)
            }
        }
        .toolbar {
            SidebarViewToolbar(showingAwards: $showingAwards)
        }
        .alert("Rename tag", isPresented: $renamingTag) {
            Button("OK", action: completeRename)
            Button("Cancel", role: .cancel) { }
            TextField("New name", text: $tagName)
        }
        .navigationTitle("Filters")
        .sheet(isPresented: $showingAwards, content: AwardsView.init)
    }
    
    // 特定のユーザフィルタ(Tag)を削除する
    func delete(_ offsets: IndexSet) {
        for offset in offsets {
            let item = tags[offset]
            dataController.delete(item)
        }
    }
    
    func rename(_ filter: Filter) {
        tagToRename = filter.tag
        tagName = filter.name
        renamingTag = true
    }
    
    func completeRename() {
        tagToRename?.name = tagName
        dataController.save()
    }
    
    func delete(_ filter: Filter) {
        guard let tag = filter.tag else { return }
        dataController.delete(tag)
        dataController.save()
    }
    
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
            .environmentObject(DataController.preview)
    }
}
