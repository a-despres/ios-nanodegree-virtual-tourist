//
//  GalleryViewController+CompletionHandlers.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/22/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import Foundation

// MARK: Gallery View Controller - Completion Handlers
extension GalleryViewController {
    
    /**
     Completion handler for DataController.add(photo:to:completion:)
     - parameter success: The boolean value indicating if the photo has been saved in Core Data.
     */
    func handleAddPhoto(photo: Photo, pin: Pin, success: Bool) {
        if !success {
            // TODO: Handle Error
            print("Error: Photo data not saved.")
        }
    }
    
    /**
     Completion handler for DataController.delete(photo:completion:)
     - parameter success: The boolean value indicating if the delete process was successful.
     */
    func handleDeletePhoto(success: Bool) {
        switch success {
        case false:
            // TODO: Handle Error
            print("Error: Could not delete photo")
            
        case true:
            self.photosToDelete = [Photo]()
            self.toggleUpdateButton()
        }
    }
    
    /**
     Completion handler for DataController.delete(photos:completion:)
     - parameter success: The boolean value indicating if the delete process was successful.
     */
    func handleDeletePhotos(success: Bool) {
        switch success {
        case false:
            // TODO: Handle Error
            print("Error: Cound not delete photo")
            
        case true:            
            let location = Location(latitude: pin.latitude, longitude: pin.longitude)
            Client.downloadMetadata(for: location, completion: handleDownloadMetadata(metadata:error:))
        }
    }
    
    /**
     Completion handler for Client.downloadMetadata(for:completion:)
     - parameter metadata: A dictionary containing the `Location` and returned metadata if all of the metadata is parsed properly. (optional)
     - parameter error: An `Error` object describing how the parsing of metadata failed. (optional)
     */
    func handleDownloadMetadata(metadata: Client.Metadata?, error: Error?) {
        if let error = error {
            // TODO: Handle Error
            print("Error:", error)
        }
        
        else if let metadata = metadata {
            let photos = metadata.response.photos.photos
            
            // parse metadata and add to Core Data
            for photo in photos {
                let photoToAdd = Photo(context: DataController.shared.viewContext)
                photoToAdd.data = Data() // The photo data will be downloaded when the Photo object is displayed in the cell
                photoToAdd.title = photo.title
                photoToAdd.url = photo.url
                
                DataController.add(photo: photoToAdd, to: pin, completion: handleAddPhoto(photo:pin:success:))
            }
        }
    }
    
    /**
     Completion handler for Client.downloadPhoto(from:for:in:completion:)
     _ parameter associated: The `Photo` and `Pin` objects associated with the photo being downloaded.
     - parameter response: A tuple containing the photo data being returned from the download (optional) and the boolean value indicating if the download was successful.
     - parameter error: The `Error` object describing how the download failed. (optional)
     */
    func handleDownloadPhoto(associated: (photo: Photo, pin: Pin), response: (data: Data?, success: Bool), error: Error?) {
        if response.success {
            associated.photo.data = response.data
            DataController.add(photo: associated.photo, to: associated.pin, completion: handleAddPhoto(photo:pin:success:))
        }
    }
    
    /**
     Completion handler for DataController.fetchPhotos(for:using:completion:)
     - parameter success: The boolean value indicating if the photos were fetched successfully.
     */
    func handleFetchPhotos(success: Bool) {
        if !success {
            // TODO: Handle Error
            print("Error: Failed to load photos.")
        }
    }
}
