//
//  DataController+Photo.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/22/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import CoreData

// MARK: Data Controller - Photo
extension DataController {
    
    /**
     Add a `Photo` to a specified `Pin`.
     - parameter photo: The `Photo` to add to the specified `Pin`.
     - parameter pin: The `Pin` in which to associate with the `Photo`.
     - parameter completion: A closure which is called with the updated `Photo` object, the original `Pin` object, and a boolean indicating success or failure.
     */
    class func add(photo: Photo, to pin: Pin, completion: @escaping AddPhotoHandler) {
        photo.pin = pin
        
        save { success in
            switch success {
            case false: completion(photo, pin, false)
            case true: completion(photo, pin, true)
            }
        }
    }
    
    /**
     Delete a `Photo` from its associated `Pin`.
     - parameter photo: The `Photo` to delete.
     - parameter completion: A closure which is called with a boolean indicating success or failure.
     */
    class func delete(photo: Photo, completion: @escaping DeletePhotoHandler) {
        shared.viewContext.delete(photo)
        
        save { success in
            switch success {
            case false: completion(false)
            case true: completion(true)
            }
        }
    }
    
    /**
     Delete all `Photo` objects from their associated `Pin`.
     - parameter photos: The array of `Photo` objects to delete.
     - parameter completion: A closure which is called with a boolean indicating success or failure.
     */
    class func delete(photos: [Photo], completion: @escaping DeletePhotoHandler) {
        for photo in photos {
            delete(photo: photo) { success in
                if !success { completion(false) }
            }
        }
        
        completion(true)
    }
    
    /**
     Fetch all `Photo` objects for a specified `Pin`.
     - parameter pin: The `Pin` associated with the `Photo` objects being fetched.
     - parameter viewController: The `GalleryViewController` displaying the photos.
     */
    class func fetchPhotos(for pin: Pin, using viewController: GalleryViewController, completion: @escaping FetchPhotosHandler) {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.sortDescriptors = []
        
        shared.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        shared.fetchedResultsController.delegate = viewController
        
        do {
            try shared.fetchedResultsController.performFetch()
            completion(true)
        } catch {
            completion(false)
        }
    }
}
