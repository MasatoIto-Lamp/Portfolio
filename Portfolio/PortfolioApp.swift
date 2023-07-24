//
//  PortfolioApp.swift
//  Portfolio
//
//  Created by イトマサ on 2023/07/20.
//

import SwiftUI

@main

struct PortfolioApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var dataController = DataController()
    
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
