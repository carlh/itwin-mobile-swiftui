//
//  AuthHelpers.swift
//  SwiftUIStarter
//
//  Created by Carl Hinkle on 12/27/21.
//

import UIKit
import AppAuthCore
import AppAuth
import SafariServices



// Note that in this app the user needs to sign in every time the app launches.  In a real app you'd want to use the Keychain to store the
// token and use that if it's valid.  Maybe if I have time I'll figure out how to make it work.
@MainActor struct AppAuthHelper {
    private static let issuer = URL(string: "https://ims.bentley.com")
    
    private static var authState: OIDAuthState?
    static var currentAuthorizationFlow: OIDExternalUserAgentSession?
    
    static func authenticate() async throws {
        let config = try await OIDAuthorizationService.discoverConfiguration(forIssuer: issuer!)
        
        let req = OIDAuthorizationRequest(configuration: config,
                                          clientId: "native-9RSE1tR1Z3N3Wi21i81ABxWXA",
                                          scopes: Array("email openid profile organization itwinjs imodels:modify imodels:read projects:read projects:modify".split(separator: " ").map({String($0)})),
                                          redirectURL: URL(string: "imodeljs://app/signin-callback")!,
                                          responseType: OIDResponseTypeCode,
                                          additionalParameters: nil
        )
        
        guard  let rootViewController = UIApplication.shared.rootViewController else {
            print("No root view controller.")
            return
        }
        (currentAuthorizationFlow, authState) = try await OIDAuthState.authState(byPresenting: req, presenting: rootViewController)
    }
    
    static func logOut() {
        authState = nil
    }
    
    static func accessToken() async throws -> String? {
        guard let authState = authState else {
            throw AuthenticationError.tokenRefreshFailed
        }
        return try await authState.performAction().0 // .0 is the access token, .1 is the id token
    }
    
    static func isAuthorized() -> Bool {
        guard let authState = authState else { return false }
        return authState.isAuthorized
    }
}
