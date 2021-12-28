//
//  OIDAuthState+Ext.swift
//  SwiftUIStarter
//
//  Created by Carl Hinkle on 12/28/21.
//

import Foundation
import AppAuth

extension OIDAuthState {
    static func authState(byPresenting req: OIDAuthorizationRequest, presenting vc: UIViewController) async throws -> (OIDExternalUserAgentSession?, OIDAuthState?) {
        return try await withCheckedThrowingContinuation({ continuation in
            var currentAuthFlow: OIDExternalUserAgentSession? = nil
            currentAuthFlow = OIDAuthState.authState(byPresenting: req, presenting: vc) { authState, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: (currentAuthFlow, authState))
                }
            }
        })
    }
    
    func performAction() async throws -> (String?, String?) {
        return try await withCheckedThrowingContinuation({ continuation in
            performAction { accessToken, idToken, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: (accessToken, idToken))
                }
            }
        })
    }
}
