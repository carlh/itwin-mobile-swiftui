//
//  ProjectsList.swift
//  SwiftUIStarter
//
//  Created by Carl Hinkle on 12/28/21.
//

import SwiftUI

struct ProjectsList: View {
    @State private var searchString = ""
    
    @StateObject private var vm = ViewModel()
    
    var body: some View {
        List {
            Section {
                ForEach(searchResults, id: \.id) { project in
                    GroupBox(project.geographicLocation ?? "") {
                        LazyVStack(alignment: .leading) {
                            NavigationLink {
                                ProjectDetailView(project: project)
                            } label: {
                                Text(project.displayName ?? "No Name")
                                    .font(.title)
                                    .bold()
                            }
                        }
                    }
                }
            } header: {
                VStack(alignment: .leading) {
                    Text("Project View")
                        .font(.title2)
                        .bold()
                    Picker(selection: $vm.listMode) {
                        Text("All")
                            .tag(ViewModel.ProjectListViewMode.all)
                        Text("Recent")
                            .tag(ViewModel.ProjectListViewMode.recents)
                        Text("Favorites")
                            .tag(ViewModel.ProjectListViewMode.favorites)
                    } label: {
                        Text("Project View")
                    }
                    .pickerStyle(.segmented)
                }

            }

            
        }
        .searchable(text: $searchString, placement: SearchFieldPlacement.navigationBarDrawer, prompt: Text("Search"))
        .task {
            await vm.fetchProjects()
        }
    }
    
    var searchResults: [Project] {
        if searchString.isEmpty {
            return vm.projectsList
        } else {
            return vm.projectsList.filter { project in
                project.displayName?.localizedCaseInsensitiveContains(searchString) ?? false
            }
        }
    }
}

struct ProjectsList_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsList()
    }
}
