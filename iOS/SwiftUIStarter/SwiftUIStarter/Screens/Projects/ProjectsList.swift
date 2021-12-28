//
//  ProjectsList.swift
//  SwiftUIStarter
//
//  Created by Carl Hinkle on 12/28/21.
//

import SwiftUI

struct ProjectsList: View {
    @Binding var projects: Projects?
    var body: some View {
        ScrollView {
            if projects != nil {
                ForEach(projects!.projects) { project in
                    GroupBox(project.geographicLocation ?? "") {
                        VStack(alignment: .leading) {
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
            } else {
                Text("Nothing to see here")
            }
        }
    }
}

struct ProjectsList_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsList(projects: .constant(nil))
    }
}
