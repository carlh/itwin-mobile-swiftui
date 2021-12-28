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
    var geographicLocation: String?
    var links: Links?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case displayName
        case projectNumber
        case geographicLocation
        case links = "_links"
    }
    
    struct Links: Codable {
        var imodels: Link?
        
        private enum CodingKeys: String, CodingKey {
            case imodels
        }
        
        struct Link: Codable {
            var href: String?
            
            private enum CodingKeys: String, CodingKey {
                case href
            }
        }
    }
}

struct Projects: Codable {
    var projects: [Project]
    var links: Links?
    
    private enum CodingKeys: String, CodingKey {
        case projects
        case links = "_links"
    }
    
    struct Links: Codable {
        var `self`: Link?
        var prev: Link?
        var next: Link?
        
        private enum CodingKeys: String, CodingKey {
            case `self`
            case prev
            case next
        }
        
        struct Link: Codable {
            var href: String?
            
            private enum CodingKeys: String, CodingKey {
                case href
            }
        }
    }
   
}
