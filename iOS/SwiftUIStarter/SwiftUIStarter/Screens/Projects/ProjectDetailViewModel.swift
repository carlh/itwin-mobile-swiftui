//
//  ProjectDetailViewModel.swift
//  SwiftUIStarter
//
//  Created by Carl Hinkle on 12/28/21.
//

import Foundation

extension ProjectDetailView {
    @MainActor class ViewModel: ObservableObject {
        let project: Project
        @Published var imodelList: [iModel] = []
        
        init(with project: Project) {
            self.project = project
        }
        
        func fetchIModels() async {
            guard let iModelsHref = project.links?.imodels?.href else {
                print("No link to iModels in this project")
                return
            }
            if let imodels: iModels = await ITwinRequests.fetchObjects(url: iModelsHref){
                imodelList = imodels.iModels
                print("Got iModels: \(imodelList)")
            }
        }
    }

}
