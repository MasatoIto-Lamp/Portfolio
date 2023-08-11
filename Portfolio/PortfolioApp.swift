//
//  PortfolioApp.swift
//  Portfolio
//
//  Created by イトマサ on 2023/07/20.
//

import SwiftUI

@main

// iPhone、iPadでの利用を想定したIssue管理アプリ
// Issueの作成、編集、削除といった基本動作に加え、Issueに任意のタグを追加しタグでIssueを管理する機能を持つ
struct PortfolioApp: App {
    
    // ソフトウェアデザインパターンはシングルトンを採用
    // データ管理を一手に担うDataControllerクラスのインスタンスを各Viewから利用する
    @StateObject var dataController = DataController()
    
    // アプリケーションの状態を保持する
    // 非アクティブ状態へ移行時にデータをディスク保存するために利用する
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            // アプリの画面構成は3つの異なるビューを縦3列に配置したSprit構成
            // 左側ビューにはIssueを絞り込むためのフィルタを表示(SidebarView)
            // 中央ビューには絞り込みされたIssueの一覧を表示(ContentView)
            // 右側ビューには選択したIssueの詳細を表示(DetailView)
            NavigationSplitView {
                SidebarView()
            } content: {
                ContentView()
            } detail: {
                DetailView()
            }
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
            .onChange(of: scenePhase) { phase in
                if phase != .active {
                    dataController.save()
                }
            }
        }
    }
}
