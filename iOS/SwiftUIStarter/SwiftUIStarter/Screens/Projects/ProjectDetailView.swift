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
        List {
            Section("Geolocated iModels") {
                ForEach(vm.iModelsWithExtents) { imodel in
                    ZStack {
                        NavigationLink {
                            iModelView(iModel: imodel)
                        } label: {
                            VStack(alignment: .leading) {
                                Text("\(imodel.displayName ?? "No Name")")
                                    .font(.system(.title, design: .rounded))
                                    .bold()
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                                
                                Text("\(imodel.description ?? "No description")")
                                    .font(.body)
                                    .foregroundColor(Color(uiColor: .secondaryLabel))
                                    .lineLimit(3)
                                    .minimumScaleFactor(0.75)
                            }
                        }
                        HStack {
                            Spacer()
                            Button {
                                vm.selectediModel = imodel
                            } label: {
                                Label {
                                    Text("Show on map")
                                } icon: {
                                    Image(systemName: "map.circle")
                                }
                                
                            }
                            .buttonStyle(.bordered)
                            .padding(.trailing, 50)
                        }
                        .sheet(isPresented: $vm.showMap) {
                            vm.selectediModel = nil
                        } content: {
                            if let imodel = vm.selectediModel {
                                iModelLocationMapView(iModel: imodel)
                            }
                            
                        }
                    }
                }
            }
            Section("Non-Geolocated iModels") {
                ForEach(vm.iModelsWithoutExtents) { imodel in
                    NavigationLink {
                        iModelView(iModel: imodel)
                    } label: {
                        VStack(alignment: .leading) {
                            Text("\(imodel.displayName ?? "No Name")")
                                .font(.system(.title, design: .rounded))
                                .bold()
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            
                            
                            Text("\(imodel.description ?? "No description")")
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                                .lineLimit(3)
                                .minimumScaleFactor(0.75)
                        }
                    }
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
