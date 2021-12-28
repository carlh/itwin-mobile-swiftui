//
//  HomeViewModel.swift
//  SwiftUIStarter
//
//  Created by Carl Hinkle on 12/27/21.
//

import Foundation
import AppAuth

extension Home {
    @MainActor class ViewModel: ObservableObject {
        @Published var userAuthenticated = false
        @Published var projectsList: [Project] = []
        
        private var projects: Projects? = nil
        
        func isLoggedIn() {
            userAuthenticated = AppAuthHelper.isAuthorized()
        }
        
        func logIn()  {
            Task {
                do {
                    try await AppAuthHelper.authenticate()
                    userAuthenticated = AppAuthHelper.isAuthorized()
                    await fetchProjects()
                } catch {
                    print("Error while authenticating: \(error.localizedDescription)")
                }
            }
        }
        
        func doSilentLogin() {
            Task {
                userAuthenticated = AppAuthHelper.isAuthorized()
                if userAuthenticated {
                    await fetchProjects()
                }
            }
        }
        
        func logOut() {
            AppAuthHelper.logOut()
            userAuthenticated = AppAuthHelper.isAuthorized()
        }
        
        private func fetchProjects() async {
            do {
                projects = try await ITwinRequests.allProjects()
                if let projects = projects {
                    projectsList.append(contentsOf: projects.projects)
                }
                
            } catch {
                print("Failed to parse projects in viewmodel \(error.localizedDescription)")
            }
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
