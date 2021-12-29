//
//  SwiftUIModelApplication.swift
//  SwiftUIStarter
//
//  Created by Carl Hinkle on 12/28/21.
//

import Foundation
import ITwinMobile
import IModelJsNative
import PromiseKit

class SwiftUIModelApplication: ModelApplication {
    
    private struct iTwinData: Codable {
        let iModelId: String
        let contextId: String
        
        private enum CodingKeys: String, CodingKey {
            case iModelId
            case contextId
        }
    }
    
    // The view model is acting as a data source for the ModelApplication.  I should probably define it that way instead of taking a hard dependency on the ViewModel.
    weak var vm: iModelView.ViewModel? = nil
    
    required init() {
        super.init()
        registerHandlers()
    }
    
    private func registerHandlers() {
        registerQueryHandler(ITMMessages.selectedIModel) { () -> Promise<String?> in
            guard let vm = self.vm else {
                return Promise.value(nil);
            }

            let iModel = vm.iModel
            
            guard  let contextId = iModel.projectId else {
                return Promise.value(nil);
            }
            
            let data: iTwinData = iTwinData(iModelId: iModel.id, contextId: contextId)
            do {
                let encoded = try JSONEncoder().encode(data)
                return Promise.value(encoded.base64EncodedString())
            } catch {
                print("Failed to encode the data: \(error.localizedDescription)")
            }
            return Promise.value(nil)
        }
    }
    
    override func getAuthClient() -> AuthorizationClient? {
        return SwiftUIModelAppAuthClient()
    }
}
