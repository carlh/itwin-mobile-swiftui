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

enum ITMMessages {
    static let accessToken = "accessToken"
    static let selectedIModel = "selectedIModel"
}

struct iTwinData: Codable {
    let iModelId: String
    let contextId: String
    
    private enum CodingKeys: String, CodingKey {
        case iModelId
        case contextId
    }
}

class SwiftUIModelApplication: ModelApplication {
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
            
            let iModelId = iModel.id
            
            let data: iTwinData = iTwinData(iModelId: iModelId, contextId: contextId)
            do {
                let encoded = try JSONEncoder().encode(data)
                print("Encoded the data: \(encoded.base64EncodedString())")
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

class SwiftUIModelAppAuthClient: ITMAuthorizationClient {
    enum InteropError: Error, CustomStringConvertible {
        case tokenError
        
        var description: String {
            switch self {
                case .tokenError:
                    return "There was an error getting the refreshed access token from the AppAuthClient."
            }
        }
    }
    
     init() {
        super.init(viewController: nil)
        print("Using custom auth client")
    }
    
    @MainActor
    func setAuthState() {
        authState = AppAuthHelper.authState
    }
    
    override func initialize(_ authSettings: AuthSettings, onComplete completion: @escaping AuthorizationClientCallback) {
        super.initialize(authSettings) {
            error in
            Task {
                await self.setAuthState()
                completion(error)
            }
        }
    }
}
