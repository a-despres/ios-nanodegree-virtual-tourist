//
//  MapViewController+PinAnnotations.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/7/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import MapKit

// MARK: Map View Controller - Pin Annotations
extension MapViewController {
    
    /**
     Add an annotation to the `MKMapView` at a specified point.
     
     This is the first method in a series of methods for adding and respositioning annotations in an `MKMapView`.
     This method places a `MKPointAnnotation` view in an `MKMapView` at a specified location.
     
     - parameter annotation: An `MKPointAnnotation` to be placed in the `MKMapView`.
     - parameter map: The `MKMapView` in which to place the `MKPointAnnotation`.
     - parameter point: The position at which to place the `MKPointAnnotation`.
     */
    func add(annotation: MKPointAnnotation, to map: MKMapView, at point: CGPoint) {
        annotation.coordinate = map.convert(point, toCoordinateFrom: map)
        mapView.addAnnotation(annotation)
    }
    
    /**
     Move an annotation in the `MKMapView` to a specified point.
     
     This is the second method in a series of methods for adding and repositioning annotations in an `MKMapView`.
     This method is used to move an existing `MKPointAnnotation` view within an `MKMapView`.
     
     - parameter annotation: The `MKPointAnnotation` to be repositioned in the `MKMapView`.
     - parameter map: The `MKMapView` containing the `MKPointAnnotation`.
     - parameter point: The position at which to place the `MKPointAnnotation`.
     */
    func move(annotation: MKPointAnnotation, on map: MKMapView, to point: CGPoint) {
        annotation.coordinate = map.convert(point, toCoordinateFrom: map)
    }
    
    /**
     Drop an annotation in the `MKMapView` at a specified point.
     
     This the last method in a series of methods for adding and repositioning annotations in an `MKMapView`.
     This method does not add the `MKPointAnnotation` view to `MKMapView`, but instead positions an
     existing `MKPointAnnotation` view and fetches the locality by geocoding its coordinates.
     
     If a placename can be determined the download process for metadata and images will then commence.
     
     - parameter annotation: An `MKPointAnnotation` to be placed in the `MKMapView`.
     - parameter map: The `MKMapView` containing the `MKPointAnnotation`.
     - parameter point: The position at which to place the `MKPointAnnotation`.
     */
    func drop(annotation: MKPointAnnotation, on map: MKMapView, at point: CGPoint) {
        annotation.coordinate = map.convert(point, toCoordinateFrom: map)
        geocode(annotation: annotation, on: map, completion: handleGeocodeLocation(annotation:name:error:))
    }
    
    /**
     Place existing Pins in the `MKMapView` as annotations.
     - parameter pins: An array of `Pin` objects to iterate through and position on the map.
     - parameter map: The `MKMapView` to contain the annotations.
     */
    func place(pins: [Pin], on map: MKMapView) {
        for pin in pins {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            map.addAnnotation(annotation)
        }
    }
    
    /**
     Removes a `MKPointAnnotation` from the specified `MKMapView`.
     
     This method is used to remove a `MKPointAnnotation` from a `MKMapView`. After a the annotation
     has been removed, the method checks the number of annotations remaining on `MKMapView`.
     If all annotations have been removed the Editing state is set to `false` and the UI is updated.
     
     - parameter annotation: The `MKPointAnnotation` to be removed.
     - parameter map: The `MKMapView` containing the `MKPointAnnotation`.
     */
    func remove(annotation: MKPointAnnotation, from map: MKMapView) {
        // create location object
        let location = Location(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        
        // remove from map and persistent store
        if let pinToDelete = DataController.fetchPin(with: location) {
            DataController.delete(pin: pinToDelete, with: annotation, from: map, completion: handleDeletePin(annotation:map:success:))
        }

        if map.annotations.count == 0 {
            toggleEditingState()
            editButton.isEnabled = false
        }
    }
    
    /**
     Determine the placename by geocoding location coordinates.
     
     This method takes a `CLLocation` and returns and a closure with an option `String` or `Error`.
     The purpose of this method is to lookup the placename of a location given a pair of coordinates.
     If a placename can be found the palcename is returned as a `String` otherwise an `Error` is returned.
     
     - parameter location: The `CLLocation` to be geocoded.
     - parameter completion: A closure containing an optional `String` or `Error`.
     */
    func geocode(annotation: MKPointAnnotation, on map: MKMapView, completion: @escaping GeocodeHandler) {
        let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                completion(annotation, nil, error)
            } else {
                // add annotation to persistent store as a Pin, otherwise remove annotation from map
                DataController.add(pin: annotation, from: map, completion: self.handleAddPin(annotation:map:success:))
                completion(annotation, placemarks?.first?.locality, nil)
            }
        }
    }
}

// MARK: - Helper and Completion Handler Functions
extension MapViewController {
    
    /**
     Download the photos for the given Pin.
     - parameter pin: The `Pin` object the photos will be associated with after downloading.
     */
    func downloadPhotos(for pin: Pin) {
        
        // Pass the total number of photos to the DownloadStatusView
        statusView.setTotal(pin.photos!.count)
        
        // Iterate through the photo URLs and download the data
        for case let photo as Photo in pin.photos! {
            if let url = URL(string: photo.url!) {
                Client.downloadPhoto(from: url, for: photo, in: pin, completion: handleDownloadPhoto(associated:response:error:))
            } else {
                // TODO: Handle Error
                print("Error: Invalid URL")
            }
        }
    }
    
    /**
     Completion handler for DataController.delete(pin:)
     - parameter annotation: The annotation associated with the `Pin` object.
     - parameter map: The `MKMapView` containing the annotation.
     - parameter success: The boolean value indicating if the delete process was successful.
     */
    func handleDeletePin(annotation: MKPointAnnotation, map: MKMapView, success: Bool) {
        switch success {
        case false:
            // TODO: Handle Error
            print("Error: Pin not deleted.")
            
        case true:
            map.removeAnnotation(annotation)
        }
    }
    
    /**
     Completion handler for Client.downloadMetadata(for:completion:)
     - parameter metadata: The metadata returned by the download process. (optional)
     - parameter error: The `Error` object describing how the download failed. (optional)
     */
    func handleDownloadMetadata(metadata: Client.Metadata?, error: Error?) {
        if let error = error {
            // TODO: Handle Error
            print("Error:", error)
        }
        
        else if let metadata = metadata {
            guard let pin = DataController.fetchPin(with: metadata.location) else { return }
            pin.name = statusView.location.text
            pin.totalPages = Int16(metadata.response.photos.pages)
            
            let photos = metadata.response.photos.photos
            
            // parse metadata and add to Core Data
            for photo in photos {
                let photoToAdd = Photo(context: DataController.shared.viewContext)
                photoToAdd.data = Data()
                photoToAdd.title = photo.title
                photoToAdd.url = photo.url

                DataController.add(photo: photoToAdd, to: pin, completion: handleAddPhoto(photo:pin:success:))
            }
            
            // download images
            downloadPhotos(for: pin)
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
     Completion handler for DataController.add(pin:from:completion:)
     - parameter annotation: The annotation that was parsed to create the pin.
     - parameter map: The `MKMapView` containing the annotation.
     - parameter success: The boolean value indicating if the pin has been saved in Core Data.
     */
    func handleAddPin(annotation: MKPointAnnotation, map: MKMapView, success: Bool) {
        if !success { remove(annotation: annotation, from: map) }
    }
    
    /**
     Completion handler for DataController.add(photo:to:completion:)
     - parameter success: The boolean value indicating if the photo has been saved in Core Data.
     */
    func handleAddPhoto(photo: Photo, pin: Pin, success: Bool) {
        switch success {
        case false:
            // TODO: Handle Error
            print("Error: Photo data not saved.")
            
        case true:
            if photo.data!.count > 0 {
                statusView.incrementDownloaded()
            }
            
            if statusView.downloaded == statusView.total {
                statusView.setStatus(.complete, animated: true)
                newPin = pin
            }
        }
    }
    
    /**
     Completion handler for geocode(pin:on:completion:)
     - parameter annotation: The annotation that was used in the geocoding process.
     - parameter name: The locality name returned by the geocoding process. (optional)
     - parameter error: The `Error` object describing how the geocoding process failed. (optional)
     */
    func handleGeocodeLocation(annotation: MKPointAnnotation, name: String?, error: Error?) {
        if let error = error {
            // TODO: Handle Error
            print("Error:", error)
        }
        
        else if let name = name {
            // show download status modal
            statusView.setLocationName(name)
            statusView.setVisible(true, animated: true)
            statusView.setStatus(.preparing, animated: true)
            
            // download image data
            Client.downloadMetadata(for: annotation.coordinate.toLocation(), completion: handleDownloadMetadata(metadata:error:))
        }
    }
}
