//
//  SwiftUiModelAppAuthClient.swift
//  SwiftUIStarter
//
//  Created by Carl Hinkle on 12/29/21.
//

import Foundation
import ITwinMobile
import IModelJsNative

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
