//
//  Project.swift
//  SwiftUIStarter
//
//  Created by Carl Hinkle on 12/27/21.
//

import Foundation

struct Project: Identifiable, Codable {
    let id: String
    var displayName: String?
    var projectNumber: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case displayName
        case projectNumber
    }
}

struct Projects: Codable {
    var projects: [Project]
    
    private enum CodingKeys: String, CodingKey {
        case projects
    }
   
}
