//
//  DataController+Pin.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/22/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import CoreData
import MapKit

// MARK: Data Controller - Pin
extension DataController {
    
    /**
     Add a `Pin` object to the persistent store.
     - parameter pin: An `MKPointAnnotation` to be parsed for coordinates.
     - parameter map: The `MKMapView` containing the `MKPointAnnotation`.
     - parameter completion: A closure which is called with the original `MKPointAnnotation` object, the `MKMapView` and a boolean indicating success or failure.
     */
    class func add(pin: MKPointAnnotation, from map: MKMapView, completion: @escaping AddPinHandler) {
        let pinToAdd = Pin(context: shared.viewContext)
        pinToAdd.latitude = Double(pin.coordinate.latitude)
        pinToAdd.longitude = Double(pin.coordinate.longitude)
        
        save { success in
            switch success {
            case false: completion(pin, map, false)
            case true: completion(pin, map, true)
            }
        }
    }
    
    /**
     Delete the specified `Pin` object from the persistent store.
     - parameter pin: The `Pin` to be deleted from the peristent store.
     - parameter annotation: The `MKPointAnnotation` representing the `Pin` on an `MKMapView`.
     - parameter map: The `MKMapView` containing the `MKPointAnnotation`.
     - parameter completion: A closure which is called with the original `MKPointAnnotation` object, the `MKMapView` and a boolean indicating success or failure.
     */
    class func delete(pin: Pin, with annotation: MKPointAnnotation, from map: MKMapView, completion: @escaping DeletePinHandler) {
        shared.viewContext.delete(pin)
        save { success in
            switch success {
            case false: completion(annotation, map, false)
            case true: completion(annotation, map, true)
            }
        }
    }
    
    /**
     Fetch a `Pin` using the specified coordinates as a predicate.
     - parameter coordinates: The `Location` object containing the latitude and longitude to be used as a predicate.
     */
    class func fetchPin(with coordinates: Location) -> Pin? {
        let predicate = NSPredicate(format: "latitude == %@ AND longitude == %@", "\(coordinates.latitude)", "\(coordinates.longitude)")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        fetchRequest.predicate = predicate
        
        do {
            let pin = try DataController.shared.viewContext.fetch(fetchRequest) as? [Pin]
            return pin?.first
        } catch {
            return nil
        }
    }
    
    /**
     Fetch all `Pin` objects stored in the persistent store.
     - returns: An array of `Pin` objects. (optional)
     */
    class func fetchPins() -> [Pin]? {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        
        do {
            let pins = try shared.viewContext.fetch(fetchRequest)
            return pins
        } catch {
            return nil
        }
    }
}
