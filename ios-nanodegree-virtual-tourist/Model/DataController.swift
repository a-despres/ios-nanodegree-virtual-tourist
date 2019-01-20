//
//  DataController.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/13/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class DataController {
    // MARK: - Properties
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext { return persistentContainer.viewContext }
    
    // MARK: - Shared Instance
    static var shared = DataController()
    
    private convenience init() {
        self.init(modelName: "VirtualTourist")
    }
    
    private init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
    class func save(completion: @escaping (_ success: Bool) -> Void) {
        do {
            try DataController.shared.viewContext.save()
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    // MARK: - Photo Helper Functions
    
    class func add(photo: Photo, toPin pin: Pin, completion: @escaping (_ success: Bool) -> Void) {
        photo.pin = pin
                
        save { success in
            switch success {
            case false: completion(false)
            case true: completion(true)
            }
        }
    }
    
    class func delete(photo: Photo, completion: @escaping (_ success: Bool) -> Void) {
        shared.viewContext.delete(photo)
        save { success in
            switch success {
            case false: completion(false)
            case true: completion(true)
            }
        }
    }
    
    class func delete(photos: [Photo], completion: @escaping (_ success: Bool) -> Void) {
        for photo in photos {
            delete(photo: photo) { success in
                if !success { completion(false) }
            }
        }
        
        completion(true)
    }
    
    
    // MARK: - Pin Helper Functions
    
    class func addPin(with coordinates: CLLocationCoordinate2D, completion: @escaping (_ success: Bool) -> Void) {
        let pin = Pin(context: DataController.shared.viewContext)
        pin.latitude = "\(coordinates.latitude)"
        pin.longitude = "\(coordinates.longitude)"
        
        save { success in
            switch success {
            case false: completion(false)
            case true: completion(true)
            }
        }
    }
    
    class func delete(pin: Pin, completion: @escaping (_ success: Bool) -> Void) {
        shared.viewContext.delete(pin)
        save { success in
            switch success {
            case false: completion(false)
            case true: completion(true)
            }
        }
    }
    
    class func fetchPin(with coordinates: CLLocationCoordinate2D) -> Pin? {
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
}
