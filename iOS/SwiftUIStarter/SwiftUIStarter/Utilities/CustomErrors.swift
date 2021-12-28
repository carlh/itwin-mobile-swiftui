//
//  CustomErrors.swift
//  SwiftUIStarter
//
//  Created by Carl Hinkle on 12/28/21.
//

import Foundation


enum URLError: Error, CustomStringConvertible {
    case headerError
    
    var description: String {
        switch self {
            case .headerError:
                return "Failed to add header"
        }
    }
}

enum AuthenticationError: Error, CustomStringConvertible {
    case tokenRefreshFailed
    
    var description: String {
        switch self {
            case .tokenRefreshFailed:
                return "An error occurred while refreshing access token."
        }
    }
}
