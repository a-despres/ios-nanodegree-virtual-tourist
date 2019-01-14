//
//  Client+QueryItems.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/13/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import Foundation
import MapKit

extension Client {
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
    
    internal class func queryItems(for location: CLLocationCoordinate2D) -> [String: String] {
        let queryItems: [String: String] = [
            Flickr.QueryKey.latitude: "\(location.latitude)",
            Flickr.QueryKey.longitude: "\(location.longitude)"
        ]
        
        return queryItems
    }
}
