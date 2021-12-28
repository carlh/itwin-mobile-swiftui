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
    
    private static func addHeaders(to request: URLRequest) async throws -> URLRequest {
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
            return mutableRequest as URLRequest
        } catch let error {
            print("An error occurred: \(error.localizedDescription)")
            throw error
        }
    }
    
    static func allProjects() async throws -> Projects? {
        var projects: Projects? = nil
        
        let queryURL = projectsEndpoint
        
        do {
            let request = try await addHeaders(to: URLRequest(url: queryURL))
            let (data, _) = try await URLSession.shared.dataTask(with: request)
            if let data = data {
                projects = try JSONDecoder().decode(Projects.self, from: data)
            }
            
//            URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
//                if let error = error {
//                    print("Error \(error.localizedDescription)")
//                    return
//                }
//                guard let data = data else {
//                    print("Failed to get any data")
//                    return
//                }
//                do {
//                    print("Got this data: \(data.base64EncodedString() ?? "Nothing here")")
//                    let results = try JSONDecoder().decode(Projects.self, from: data)
//                    print("Fetched data: \(String(describing: results))")
//                } catch {
//                    print("Error decoding results: \(error.localizedDescription)")
//                }
//
//            }).resume()
            
            
        } catch {
            print("Failed to prepare the request: \(error.localizedDescription)")
        }
        
        return projects
    }
}
