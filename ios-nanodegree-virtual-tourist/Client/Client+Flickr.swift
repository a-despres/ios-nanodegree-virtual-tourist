//
//  Client+Flickr.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/13/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import Foundation

// MARK: Flickr API Client - Static Properties
extension Client {
    
    // MARK: - Flickr Properties
    struct Flickr {
        static let scheme = "https"
        static let host = "api.flickr.com"
        static let path = "/services/rest/"
        
        // MARK: - Query Item Keys
        struct QueryKey {
            static let apiKey = "api_key"
            static let callback = "nojsoncallback"
            static let extras = "extras"
            static let format = "format"
            static let latitude = "lat"
            static let longitude = "lon"
            static let method = "method"
            static let page = "page"
            static let perPage = "per_page"
            static let radius = "radius"
            static let radiusUnits = "radius_units"
            static let safeSearch = "safe_search"
        }
        
        // MARK: - Query Item Values
        struct QueryValue {
            static var apiKey: String { return Auth.key }
            static let callback = "1"
            static let extras = "url_n"
            static let format = "json"
            static var page: String = "1" // { return "\(Int(arc4random_uniform(100)) + 1)" } FIXME: random pages don't work properly
            static let perPage = "36"
        }
        
        // MARK: - Flickr API Methods
        enum Method {
            case search
            
            var method: String {
                switch self {
                case .search: return "flickr.photos.search"
                }
            }
        }
    }
}
