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
        private var imodelList: [iModel] = []
        
        @Published var iModelsWithExtents: [iModel] = []
        @Published var iModelsWithoutExtents: [iModel] = []
        @Published var showMap = false
        @Published var isLoading = false
        
        var selectediModel: iModel? {
            didSet {
                showMap = selectediModel != nil
            }
        }
        
        init(with project: Project) {
            self.project = project
        }
        
        func fetchIModels() async {
            guard let iModelsHref = project.links?.imodels?.href else {
                print("No link to iModels in this project")
                return
            }
            
            isLoading = true
            if let imodels: iModels = await ITwinRequests.fetchObjects(url: iModelsHref) {
                imodelList = imodels.iModels.sorted(by: { first, second in
                    if first.extent != nil { return true }
                    if second.extent != nil { return false }
                    return true
                })
                
                var tmpImWithExtents: [iModel] = []
                var tmpImWithoutExtents: [iModel] = []
                imodelList.forEach { imodel in
                    if imodel.extent == nil {
                        tmpImWithoutExtents.append(imodel)
                    } else {
                        tmpImWithExtents.append(imodel)
                    }
                }
                iModelsWithoutExtents = tmpImWithoutExtents
                iModelsWithExtents = tmpImWithExtents
                isLoading = false
            }
        }
    }
}
