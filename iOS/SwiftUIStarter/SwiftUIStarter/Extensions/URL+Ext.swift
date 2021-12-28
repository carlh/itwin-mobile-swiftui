//
//  URL+Ext.swift
//  SwiftUIStarter
//
//  Created by Carl Hinkle on 12/28/21.
//

import Foundation

extension URL {
    /**
     Appends a query parameter to self and returns a new URL.
     Shamelessly taken from https://stackoverflow.com/a/50990443/856786 
     */
    func appendingQueryItem(_ queryItem: String, value: String?) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        
        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        
        let queryItem = URLQueryItem(name: queryItem, value: value)
        
        queryItems.append(queryItem)
        
        urlComponents.queryItems = queryItems
        
        return urlComponents.url!
    }
}
