//
//  PortfolioApp.swift
//  Portfolio
//
//  Created by イトマサ on 2023/07/20.
//

import SwiftUI

@main

// iPhone、iPadでの利用を想定したIssue管理アプリ
struct PortfolioApp: App {
    // App起動時にDataControllerのインスタンスを格納するプロパティ
    // environmentObjectへ登録し、各Viewからアクセスできるようにする
    @StateObject var dataController = DataController()
    
    // アプリケーション状態を表すプロパティ
    // 非アクティブ状態へ移行時にデータをディスク保存するために利用する
    @Environment(\.scenePhase) var scenePhase
    
    // アプリの画面構成は3つの異なるビューを縦3列に配置した構成
    // 左側ビューにはIssueを絞り込むためのフィルタを表示(SidebarView)
    // 中央ビューには絞り込みされたIssueの一覧を表示(ContentView)
    // 右側ビューには選択したIssueの詳細を表示(DetailView)
    var body: some Scene {
        WindowGroup {
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
