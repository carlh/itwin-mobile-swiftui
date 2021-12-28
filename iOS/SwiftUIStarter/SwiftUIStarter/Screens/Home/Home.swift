//
//  Home.swift
//  SwiftUIStarter
//
//  Created by Carl Hinkle on 12/17/21.
//

import SwiftUI

struct Home: View {
    @StateObject private var vm = ViewModel()
    
    var body: some View {
        NavigationView {
            if !vm.userAuthenticated {
                LoginButton(vm: vm)
            } else {
                projectsList
            }
        }
        .navigationViewStyle(.stack)
    }
    
    var projectsList: some View {
        ProjectsList()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        vm.logOut()
                    } label: {
                        Label("Sign out", systemImage: "person.circle.fill")
                    }
                    .buttonStyle(.bordered)
                }
            }
            .navigationTitle("Your projects")
    }
    
    struct LoginButton: View {
        let vm: ViewModel
        
        var body: some View {
            VStack {
                Button {
                    vm.logIn()
                } label: {
                    Label("Sign in", systemImage: "person.circle")
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
