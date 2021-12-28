//
//  iModel.swift
//  SwiftUIStarter
//
//  Created by Carl Hinkle on 12/28/21.
//

import Foundation

struct iModels: Codable {
    let iModels: [iModel]
    let links: Links
    
    private enum CodingKeys: String, CodingKey {
        case iModels
        case links = "_links"
    }
    
    struct Links: Codable {
        let `self`: Link?
        let prev: Link?
        let next: Link?
        
        private enum CodingKeys: String, CodingKey {
            case `self`
            case prev
            case next
        }
    }
    
    struct Link: Codable {
        let href: String?
        
        private enum CodingKeys: String, CodingKey  {
            case href
        }
    }
}

struct iModel: Identifiable, Hashable, Codable {
    static func == (lhs: iModel, rhs: iModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    let id: String
    let displayName: String?
    let name: String?
    let description: String?
    let projectId: String?
    let extent: Extent?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case displayName
        case name
        case description
        case projectId
        case extent
    }
    
    struct Extent: Codable {
        let southWest: Coordinate
        let northEast: Coordinate
        
        private enum CodingKeys: String, CodingKey {
            case southWest
            case northEast
        }
    }
    
    struct Coordinate: Codable {
        let latitude: Double?
        let longitude: Double?
        
        private enum CodingKeys: String, CodingKey {
            case latitude
            case longitude
        }
    }
}
