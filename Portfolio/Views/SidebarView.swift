//
//  SidebarView.swift
//  Portfolio
//
//  Created by イトマサ on 2023/07/21.
//

import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var dataController: DataController
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var tags: FetchedResults<Tag>
    
    @State private var tagToRename: Tag?
    @State private var renamingTag = false
    @State private var tagName = ""
    @State private var showingAwards = false
    
    let smartFilters: [Filter] = [.all, .recent]
    var tagFilters: [Filter] {
        tags.map { tag in
            Filter(id: tag.tagID, name: tag.tagName, icon: "tag", tag: tag)
        }
    }
    
    var body: some View {
        List(selection: $dataController.selectedFilter) {
            Section("Smart Filters") {
                ForEach(smartFilters) { filter in
                    NavigationLink(value: filter) {
                        Label(filter.name, systemImage: filter.icon)
                    }
                }
            }
            Section("Tags") {
                ForEach(tagFilters) { filter in
                    NavigationLink(value: filter) {
                        Label(LocalizedStringKey(filter.name), systemImage: filter.icon)
                            .badge(filter.activeIssuesCount)
                            .contextMenu {
                                Button {
                                    rename(filter)
                                } label: {
                                    Label("Rename", systemImage: "pencil")
                                }
                                
                                Button(role: .destructive) {
                                    delete(filter)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .accessibilityElement()
                            .accessibilityLabel(filter.name)
                            .accessibilityHint("\(filter.activeIssuesCount) issues")
                    }
                }
                .onDelete(perform: delete)
            }
        }
        .toolbar {
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
        .alert("Rename tag", isPresented: $renamingTag) {
            Button("OK", action: completeRename)
            Button("Cancel", role: .cancel) { }
            TextField("New name", text: $tagName)
        }
        .navigationTitle("Filters")
        .sheet(isPresented: $showingAwards, content: AwardsView.init)
    }
    
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
