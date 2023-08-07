//
//  SidebarViewToolbar.swift
//  Portfolio
//
//  Created by イトマサ on 2023/08/03.
//

import SwiftUI

struct SidebarViewToolbar: View {
    @EnvironmentObject var dataController: DataController
    @Binding var showingAwards: Bool
    
    var body: some View {
        Button {
            dataController.deleteAll()
            dataController.createSampleData()
        } label: {
            Label("ADD SAMPLES", systemImage: "flame")
        }
        
        Button(action: dataController.newTag) {
            Label("Add tag", systemImage: "plus")
            
        }
        
        Button {
            showingAwards.toggle()
        } label: {
            Label("Show awards", systemImage: "rosette")
        }
    }
}

struct SidebarViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        SidebarViewToolbar(showingAwards: .constant(true))
    }
}
