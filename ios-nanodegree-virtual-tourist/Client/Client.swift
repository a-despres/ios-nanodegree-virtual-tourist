//
//  Client.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/13/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class Client {
    private static let decoder = JSONDecoder()
    
    class func downloadMetaDataForLocation(_ location: CLLocationCoordinate2D, completion: @escaping (Data?, Error?) -> Void) {
        // get pin for location
        guard let pin = DataController.fetchPin(with: location) else { return }
        
        // create URL from URL Components
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
        
        // download meta data for location
        taskForGETRequest(url: components.url!) { (data, error) in
            if let data = data {
                do {
                    let response = try decoder.decode(SearchResponse.self, from: data)
                    
                    for photo in response.photos.photos {
                        let newPhoto = Photo(context: DataController.shared.viewContext)
                        newPhoto.data = Data()
                        newPhoto.title = photo.title
                        newPhoto.url = photo.url
                            
                        DataController.add(photo: newPhoto, toPin: pin) { success in
                            switch success {
                            case false: print("hmm... something's not quite right. photo meta data saved.")
                            case true: print("success! photo meta data saved.")
                            }
                        }
                    }
                    
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private class func downloadPhoto(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        taskForGETRequest(url: url) { (data, error) in
            if let error = error { completion(nil, error) }
            if let data = data { completion(data, nil) }
        }
    }
    
    class func downloadPhotoForIndexPath(_ indexPath: IndexPath, using controller: NSFetchedResultsController<Photo>, completion: @escaping (Data?, Error?) -> Void) {
        let photo = controller.object(at: indexPath)
        let url = URL(string: photo.url!)!
        
        downloadPhoto(from: url) { (data, error) in
            if let data = data {
                photo.data = data
                DataController.save(completion: { (success) in
                    completion(data, nil)
                })
            }
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
                            
                            guard let pin = DataController.fetchPin(with: location) else { return }
                            
                            let newPhoto = Photo(context: DataController.shared.viewContext)
                            newPhoto.data = data
                            newPhoto.title = photo.title
                            newPhoto.url = photo.url
                            
                            DataController.add(photo: newPhoto, toPin: pin) { success in
                                switch success {
                                case false: print("hmm... something's not quite right. photo not saved.")
                                case true: print("success! photo saved.")
                                }
                            }
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
