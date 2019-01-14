//
//  Client.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/13/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import Foundation
import MapKit

class Client {
    private static let decoder = JSONDecoder()
    
    private class func downloadPhoto(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        taskForGETRequest(url: url) { (data, error) in
            if let error = error { completion(nil, error) }
            if let data = data { completion(data, nil) }
        }
    }
    
    class func downloadPhotosForLocation(_ location: CLLocationCoordinate2D) {
        // Create URL from URL components
        var components = URLComponents()
        components.scheme = Flickr.scheme
        components.host = Flickr.host
        components.path = Flickr.path
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in queryItems(for: .search) {
            let queryItem = URLQueryItem(name: key, value: value)
            components.queryItems?.append(queryItem)
        }
        
        for (key, value) in queryItems(for: location) {
            let queryItem = URLQueryItem(name: key, value: value)
            components.queryItems?.append(queryItem)
        }
        
        // download photos for location
        taskForGETRequest(url: components.url!) { (data, error) in
            if let data = data {
                do {
                    let response = try decoder.decode(SearchResponse.self, from: data)
                    for photo in response.photos.photos {
                        let url = URL(string: photo.url)!
                        downloadPhoto(from: url) { (data, error) in
                            // print data to console -- this is only temporary until the data is properly handled
                            print(data)
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private class func taskForGETRequest(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            completion(data, nil)
        }
        task.resume()
    }
}
