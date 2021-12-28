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
        
        private var projects: Projects? = nil
        
        func fetchProjects() async {
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
                
            } catch {
                print("Failed to parse projects in viewmodel \(error.localizedDescription)")
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
        
        private func fetchNextBatchOfProjects(from batch: Projects ) async {
            guard let nextProp = batch.links?.next, let nextUrl = nextProp.href else {
                return
            }
            
            let nextProjects: Projects? = await ITwinRequests.fetchObjects(url: nextUrl)
            if let projects = nextProjects {
                projectsList.append(contentsOf: projects.projects)
                if let _ = projects.links?.next {
                    await fetchNextBatchOfProjects(from: projects)
                }
            }
        }
    }
}
