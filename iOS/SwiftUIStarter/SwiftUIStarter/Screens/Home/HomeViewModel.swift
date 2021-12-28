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
        @Published var projects: Projects? = nil
        
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
            } catch {
                print("Failed to parse projects in viewmodel \(error.localizedDescription)")
            }
            
        }
    }
}
