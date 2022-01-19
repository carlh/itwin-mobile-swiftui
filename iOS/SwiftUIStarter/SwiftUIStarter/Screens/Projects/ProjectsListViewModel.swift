//
//  ProjectListViewModel.swift
//  SwiftUIStarter
//
//  Created by Carl Hinkle on 12/28/21.
//

import Foundation

extension ProjectsList {
    @MainActor class ViewModel: ObservableObject {
        enum ProjectListViewMode {
            case favorites
            case recents
            case all
        }
        
        @Published var listMode: ProjectListViewMode = .all {
            didSet {
                Task {
                    await fetchProjects()
                }
            }
        }
        
        @Published var projectsList: [Project] = []
        
        @Published var isLoading = false
        
        @Published var projects: Projects? = nil
        
        func fetchProjects() async {
            isLoading = true
            do {
                switch listMode {
                    case .favorites:
                        projects = try await fetchFavoriteProjects()
                    case .recents:
                        projects = try await fetchRecentProject()
                    case .all:
                        projects = try await fetchAllProjects()
                }
                
                if let projects = projects {
                    projectsList.removeAll()
                    projectsList.append(contentsOf: projects.projects)
                }
                isLoading = false
            } catch {
                print("Failed to parse projects in viewmodel \(error.localizedDescription)")
                isLoading = false
            }
        }
        
        private func fetchAllProjects() async throws -> Projects? {
            return try await ITwinRequests.allProjects()
        }
        
        private func fetchRecentProject() async throws -> Projects? {
            return try await ITwinRequests.recentProjects(count: 20)
        }
        
        private func fetchFavoriteProjects() async throws -> Projects? {
            return try await ITwinRequests.favoriteProjects()
        }
        
        var hasMoreProjects: Bool {
            if listMode != .all {
                return false  // This is due to a bug in the API that breaks the links for favorites and recents.  This can be removed once the bug is fixed.
            }
            return projects?.links?.next?.href != nil
        }
        
        func fetchNextBatchOfProjects() async {
            guard let batch = projects, let nextProp = batch.links?.next, let nextUrl = nextProp.href else {
                return
            }
            
            isLoading = true
            let nextProjects: Projects? = await ITwinRequests.fetchObjects(url: nextUrl)
            if let nextProjects = nextProjects {
                projectsList.append(contentsOf: nextProjects.projects)
                projects = nextProjects
            }
            isLoading = false
        }
    }
}
