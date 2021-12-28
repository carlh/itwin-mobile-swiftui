//
//  ProjectDetailView.swift
//  SwiftUIStarter
//
//  Created by Carl Hinkle on 12/28/21.
//

import SwiftUI

struct ProjectDetailView: View {
    var project: Project
    @StateObject private var vm: ViewModel
    
    init(project: Project) {
        self.project = project
        _vm = StateObject(wrappedValue: ViewModel(with: project))
    }
    
    var body: some View {
        List($vm.imodelList, id: \.self) { imodel in
            GroupBox(imodel.wrappedValue.displayName ?? "No Name") {
                VStack {
                    Text("\(imodel.wrappedValue.description ?? "No description")")
                        .font(.body)
                        .lineLimit(3)
                        .minimumScaleFactor(0.75)
                }
            }
        }
        .task {
            await vm.fetchIModels()
        }
        .navigationTitle(vm.project.displayName ?? "")
    }
}

struct ProjectDetailView_Previews: PreviewProvider {
    static let project = Project(id: UUID().uuidString, displayName: "Text Project", projectNumber: "224234", geographicLocation: "Connecticut", links: Project.Links(imodels: Project.Links.Link(href: "https://www.google.com")))
    static var previews: some View {
        ProjectDetailView(project: project)
    }
}
