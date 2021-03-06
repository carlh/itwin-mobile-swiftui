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
        VStack {
            projectSelectionHeader
            projectList
        }
        .task {
            await vm.fetchProjects()
        }
    }
    
    var searchResults: [Project] {
        if searchString.isEmpty {
            return vm.projectsList
        } else {
            // TODO - Filtering should be in the viewmodel
            return vm.projectsList.filter { project in
                project.displayName?.localizedCaseInsensitiveContains(searchString) ?? false
            }
        }
    }
    
    var loadMoreButton: some View {
        HStack {
            Spacer()
            
            Button {
                Task {
                    await vm.fetchNextBatchOfProjects()
                }
            } label: {
                Label {
                    Text("Load next")
                } icon: {
                    Image(systemName: "square.and.arrow.down")
                        .foregroundColor(.green)
                }
            }
            .tint(.green)
            .buttonStyle(.bordered)
            
            Spacer()
        }
        .padding()
    }
    
    var projectSelectionHeader: some View {
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
        .padding(.horizontal)
        .padding(.top)
    }
    
    var projectList: some View {
        List {
            ForEach(searchResults) { project in
                NavigationLink {
                    ProjectDetailView(project: project)
                } label: {
                    VStack(alignment: .leading) {
                        Text(project.displayName ?? "No Name")
                            .font(.system(.title, design: .rounded))
                            .bold()
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        HStack {
                            Text(project.projectNumber ?? "No project number")
                                .font(.system(.body, design: .rounded))
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                            Spacer()
                            Text(project.geographicLocation ?? "No Geolocation")
                                .font(.system(.body, design: .rounded))
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                        }
                    }
                }
            }
            if vm.hasMoreProjects {
                loadMoreButton
            }
        }
        .overlay(vm.isLoading ? FullScreenProgressView() : nil)
        .searchable(text: $searchString, placement: SearchFieldPlacement.navigationBarDrawer, prompt: Text("Search"))
    }
}


struct ProjectsList_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsList()
    }
}

