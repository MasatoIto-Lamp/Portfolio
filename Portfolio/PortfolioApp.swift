//
//  PortfolioApp.swift
//  Portfolio
//
//  Created by イトマサ on 2023/07/20.
//

import SwiftUI

@main

struct PortfolioApp: App {
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
        }
    }
}
