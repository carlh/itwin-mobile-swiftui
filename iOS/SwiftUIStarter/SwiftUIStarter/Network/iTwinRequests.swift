//
//  iTwinRequests.swift
//  SwiftUIStarter
//
//  Created by Carl Hinkle on 12/27/21.
//

import Foundation



struct ITwinRequests {
    static let baseUrl = URL(string: "https://api.bentley.com/")!
    
    static let projectsEndpoint = baseUrl.appendingPathComponent("projects/")
    
    /**
     * This function always adds the auth headers to the request, and optionally any additional headers
     * (such as Prefer)
     */
    private static func addHeaders(to request: URLRequest, with additionalHeaders: [String:String] = [:]) async throws -> URLRequest {
        do {
            let accessToken = try await AppAuthHelper.accessToken()
            guard let accessToken = accessToken else {
                throw AuthenticationError.tokenRefreshFailed
            }
            
            guard let mutableRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
                throw URLError.headerError
            }
            
            mutableRequest.allHTTPHeaderFields = [
                "Authorization": "Bearer \(accessToken)",
                "Accept": "application/vnd.bentley.itwin-platform.v1+json",
                "Prefer": "return=minimal"
            ]
            
            // Include the additional headers.  Any duplicate keys will replace the defaults.
            mutableRequest.allHTTPHeaderFields?.merge(additionalHeaders) { current, new in
                new
            }
            
            return mutableRequest as URLRequest
        } catch let error {
            print("An error occurred: \(error.localizedDescription)")
            throw error
        }
    }
    
    private static func fetchAndDecode<T>(from url: URL, additionalHeaders: [String: String] = [:]) async throws  -> T? where T: Codable {
        var results: T? = nil
        do {
            let request = try await addHeaders(to: URLRequest(url: url), with: additionalHeaders)
            let (data, _) = try await URLSession.shared.dataTask(with: request)
            if let data = data {
                results = try JSONDecoder().decode(T.self, from: data)
            }
        } catch {
            print("Failed get get recent projects")
        }
        return results
    }
    
    static func allProjects() async throws -> Projects? {
        let queryURL = projectsEndpoint
        return try await fetchAndDecode(from: queryURL, additionalHeaders: ["Prefer": "return=representation"])
    }
    
    static func recentProjects(count: Int?) async throws -> Projects? {
        var queryURL = projectsEndpoint.appendingPathComponent("recents")
        queryURL = queryURL.appendingQueryItem("$top", value: "\(count ?? 10)")
        return try await fetchAndDecode(from: queryURL, additionalHeaders: ["Prefer": "return=representation"])
    }
    
    static func favoriteProjects() async throws -> Projects? {
        let queryURL = projectsEndpoint.appendingPathComponent("favorites")
        return try await fetchAndDecode(from: queryURL, additionalHeaders: ["Prefer": "return=representation"])
    }
    
    static func fetchObjects<T>(url: String) async -> T? where T: Codable {
        var results: T? = nil
        
        do {
            guard let requestUrl = URL(string: url) else { return results }
            let request = try await addHeaders(to: URLRequest(url: requestUrl), with: ["Prefer": "return=representation"])
            let (data, _) = try await URLSession.shared.dataTask(with: request)
            if let data = data {
                results = try JSONDecoder().decode(T.self, from: data)
            }
            return results
        } catch {
            print("Failed to fetch objects for \(url) with error \(error.localizedDescription)")
            return results
        }
    }
}
