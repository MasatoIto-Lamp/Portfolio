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
    
    // 名前変更する対象のタグを格納する
    @State private var tagToRename: Tag?
    
    // 名前変更を行うアラート画面を表示するためのトリガー
    @State private var renamingTag = false
    
    // 変更前後のTagの名前を格納する
    @State private var tagName = ""
    
    // AwardsViewをシート表示するためのトリガー
    @State private var showingAwards = false
    
    // スマートフィルタを格納
    let smartFilters: [Filter] = [.all, .expired, .today, .tomorrow, .inWeek]
    
    // データベースから取得したTagをFilterへ変換する
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
    
    // 画面リスト上でスワイプ削除されたユーザフィルタ(Tag)を削除する
    func delete(_ offsets: IndexSet) {
        for offset in offsets {
            let item = tags[offset]
            dataController.delete(item)
        }
    }
    
    // 名前変更するTagおよび現時点の名前を特定し、名前変更のアラート画面をトリガーする
    func rename(_ filter: Filter) {
        tagToRename = filter.tag
        tagName = filter.name
        renamingTag = true
    }
    
    // 名前変更を確定する
    func completeRename() {
        tagToRename?.name = tagName
        dataController.save()
    }
    
    // コンテキストメニューから削除選択されたユーザフィルタ(Tag)を削除する
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
