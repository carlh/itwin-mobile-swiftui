//
//  URLSession+Ext.swift
//  SwiftUIStarter
//
//  Created by Carl Hinkle on 12/28/21.
//

import Foundation

extension URLSession {
    func dataTask(with request: URLRequest) async throws -> (Data?, URLResponse?) {
        return try await withCheckedThrowingContinuation({ continuation in
            URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                guard error == nil else {
                    continuation.resume(throwing: error!)
                    return
                }
                continuation.resume(returning: (data, response))
            }).resume()
        })
    }
}
