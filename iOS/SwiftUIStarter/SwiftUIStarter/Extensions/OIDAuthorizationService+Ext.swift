//
//  OIDAuthorizationService+Ext.swift
//  SwiftUIStarter
//
//  Created by Carl Hinkle on 12/28/21.
//

import Foundation
import AppAuthCore

extension OIDAuthorizationService {
    static func discoverOidcServiceConfiguration(forIssuer issuer: URL) async throws -> OIDServiceConfiguration? {
        return try await withCheckedThrowingContinuation { continuation in
            OIDAuthorizationService.discoverConfiguration(forIssuer: issuer) { configuration, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: configuration)
                }
            }
        }
    }
}
