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
            let error = DataError(forType: .savePhoto)
            displayAlertForError(error)
        }
    }
    
    /**
     Completion handler for DataController.delete(photo:completion:)
     - parameter success: The boolean value indicating if the delete process was successful.
     */
    func handleDeletePhoto(success: Bool) {
        switch success {
        case false:
            let error = DataError(forType: .deletePhoto)
            displayAlertForError(error)
            
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
            let error = DataError(forType: .deletePhotos)
            displayAlertForError(error)
            
        case true:            
            let location = Location(latitude: pin.latitude, longitude: pin.longitude)
            var pageNumber = 1
            
            if pin.totalPages > 1 {
                pageNumber = Int(arc4random_uniform(UInt32(pin!.totalPages))) + 1
            }
            
            Client.downloadMetadata(for: location, with: pageNumber, completion: handleDownloadMetadata(metadata:error:))
        }
    }
    
    /**
     Completion handler for Client.downloadMetadata(for:completion:)
     - parameter metadata: A dictionary containing the `Location` and returned metadata if all of the metadata is parsed properly. (optional)
     - parameter error: An `Error` object describing how the parsing of metadata failed. (optional)
     */
    func handleDownloadMetadata(metadata: Client.Metadata?, error: Error?) {
        if let _ = error {
            let error = ClientError(forType: .downloadMetadata)
            displayAlertForError(error)
        }
        
        else if let metadata = metadata {
            pin.totalPages = Int16(metadata.response.photos.pages)
            
            let photos = metadata.response.photos.photos
            
            // parse metadata and add to Core Data
            for photo in photos {
                if let url = photo.url {
                    let photoToAdd = Photo(context: DataController.shared.viewContext)
                    photoToAdd.data = Data() // The photo data will be downloaded when the Photo object is displayed in the cell
                    photoToAdd.title = photo.title
                    photoToAdd.url = url
                    
                    DataController.add(photo: photoToAdd, to: pin, completion: handleAddPhoto(photo:pin:success:))
                }
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
            let error = DataError(forType: .loadPhotos)
            displayAlertForError(error)
        }
    }
}
