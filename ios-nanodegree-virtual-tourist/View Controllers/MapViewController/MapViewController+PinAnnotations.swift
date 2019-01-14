//
//  MapViewController+PinAnnotations.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/7/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import UIKit
import MapKit

// MARK: - Pin Annotations
extension MapViewController {
    
    /**
     Add a pin to the `MKMapView` at a specified point.
     
     This is the first method in a series of methods for adding and respositioning pins in an `MKMapView`.
     This method places a `MKPointAnnotation` view in an `MKMapView` at a specified location.
     
     - parameter pin: An `MKPointAnnotation` to be placed in the `MKMapView`.
     - parameter map: The `MKMapView` in which to place the `MKPointAnnotation`.
     - parameter point: The position at which to place the `MKPointAnnotation`.
     */
    func add(pin: MKPointAnnotation, to map: MKMapView, at point: CGPoint) {
        pin.coordinate = map.convert(point, toCoordinateFrom: map)
        mapView.addAnnotation(pin)
    }
    
    /**
     Move a pin in the `MKMapView` to a specified point.
     
     This is the second method in a series of methods for adding and repositioning pins in an `MKMapView`.
     This method is used to move an existing `MKPointAnnotation` view within an `MKMapView`.
     
     - parameter pin: The `MKPointAnnotation` to be repositioned in the `MKMapView`.
     - parameter map: The `MKMapView` containing the `MKPointAnnotation`.
     - parameter point: The position at which to place the `MKPointAnnotation`.
     */
    func move(pin: MKPointAnnotation, on map: MKMapView, to point: CGPoint) {
        pin.coordinate = map.convert(point, toCoordinateFrom: map)
    }
    
    /**
     Drop a pin in the `MKMapView` at a specified point and display the annotation title.
     
     This the last method in a series of methods for adding and repositioning pins in an `MKMapView`.
     This method does not add the `MKPointAnnotation` view to `MKMapView`, but instead positions an
     existing `MKPointAnnotation` view and sets the title property to a Geo-coded placename.
     
     - parameter pin: An `MKPointAnnotation` to be placed in the `MKMapView`.
     - parameter map: The `MKMapView` containing the `MKPointAnnotation`.
     - parameter point: The position at which to place the `MKPointAnnotation`.
     */
    func drop(pin: MKPointAnnotation, on map: MKMapView, at point: CGPoint) {
        pin.coordinate = map.convert(point, toCoordinateFrom: map)
        
        let location = CLLocation(latitude: pin.coordinate.latitude, longitude: pin.coordinate.longitude)
        geocodeLocation(location) { (placename, error) in
            if let error = error {
                // TODO: Handle error appropriately
                print("Error:", error)
            } else if let placename = placename {
                pin.title = placename
                
                // Download image data
                Client.downloadPhotosForLocation(pin.coordinate)
            }
        }
    }
    
    /**
     Removes a `MKPointAnnotation` from the specified `MKMapView`.
     
     This method is used to remove a `MKPointAnnotation` from a `MKMapView`. After a the annotation
     has been removed, the method checks the number of annotations remaining on `MKMapView`.
     If all annotations have been removed the Editing state is set to `false` and the UI is updated.
     
     - parameter pin: The `MKPointAnnotation` to be removed.
     - parameter map: The `MKMapView` containing the `MKPointAnnotation`.
     */
    func remove(pin: MKPointAnnotation, from map: MKMapView) {
        map.removeAnnotation(pin)
        
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
    func geocodeLocation(_ location: CLLocation, completion: @escaping (String?, Error?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                completion(nil, error)
            } else {
                completion(placemarks?.first?.name, nil)
            }
        }
    }
}
