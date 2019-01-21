//
//  Client.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/13/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import Foundation

// MARK: Flickr API Client
class Client {
    
    // MARK: - Properties
    private static let decoder = JSONDecoder()
    
    // MARK: - Class Methods
    /**
     Download metadata for a given location. This is the first step in downloading photos for a location.
     The metadata provides associated urls for a batch of photos.
     - parameter location: The `CLLocationCoordinate2D` to be used for downloading associated photos.
     - parameter completion: A closure which is called with optional metadata, and an optional error.
     */
    class func downloadMetadata(for location: Location, completion: @escaping DownloadMetadataHandler) {
        print("Downloading Metadata...\n")
        
        // create URL from URL Components
        var components = URLComponents()
        components.scheme = Flickr.scheme
        components.host = Flickr.host
        components.path = Flickr.path
        components.queryItems = [URLQueryItem]()
        components.addQueryItems(queryItems(for: .search))
        components.addQueryItems(queryItems(for: location))
        
        // download meta data for location
        taskForGETRequest(url: components.url!) { (data, error) in
            
            // send error to view if one exists
            if let error = error {
                completion(nil, error)
            }
            
            // no errors yet... so let's try to to parse the data
            guard let data = data else { return completion(nil, nil) }

            do {
                // decode data
                let response = try decoder.decode(SearchResponse.self, from: data)
                let metadata: Metadata = (location: location, response: response)
                
                print("Current Page:", response.photos.page)
                print("Total Page:", response.photos.pages)
                print("Total Photos:", response.photos.total)
                                
                // send metadata back to view
                DispatchQueue.main.async { completion(metadata, nil) }
            } catch {
                // send error back to view
                DispatchQueue.main.async { completion(nil, error) }
            }
        }
    }
    
    /**
     Download a photo from a given URL.
     - parameter url: The `URL` where the photo can be found.
     - parameter completion: A closure which is called with optional data, and an optional error.
     */
    class func downloadPhoto(from url: URL, completion: @escaping DownloadPhotoHandler) {
        taskForGETRequest(url: url) { (data, error) in
            if let error = error { completion(false, nil, error) }
            else if let data = data { completion(true, data, nil) }
        }
    }
    
    // MARK: - HTTP Methods (Private)
    private class func taskForGETRequest(url: URL, completion: @escaping RequestHandler) {
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
