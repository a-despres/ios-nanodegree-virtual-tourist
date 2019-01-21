//
//  Client+QueryItems.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/13/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import Foundation

// MARK: Flickr API Client - Query Items
extension Client {
    
    /**
     Return a dictionary of query keys and values for the Flickr API.
     - parameter method: The Flickr API method being used.
     */
    internal class func queryItems(for method: Flickr.Method) -> [String: String] {
        let queryItems: [String: String] = [
            Flickr.QueryKey.method: method.method,
            Flickr.QueryKey.apiKey: Flickr.QueryValue.apiKey,
            Flickr.QueryKey.callback: Flickr.QueryValue.callback,
            Flickr.QueryKey.extras: Flickr.QueryValue.extras,
            Flickr.QueryKey.format: Flickr.QueryValue.format,
            Flickr.QueryKey.page: Flickr.QueryValue.page,
            Flickr.QueryKey.perPage: Flickr.QueryValue.perPage
        ]
        return queryItems
    }
    
    /**
     Return a dictionary of query keys and values for to a location.
     - parameter location: The latitude and longitude to be searched.
     */
    internal class func queryItems(for location: Location) -> [String: String] {
        let queryItems: [String: String] = [
            Flickr.QueryKey.latitude: "\(location.latitude)",
            Flickr.QueryKey.longitude: "\(location.longitude)"
        ]
        return queryItems
    }
}
