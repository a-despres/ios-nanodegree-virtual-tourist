//
//  DataController+IO.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/22/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import Foundation

// MARK: Data Controller - IO
extension DataController {
    
    /**
     Load the persistent store from Core Data.
     - parameter completion: A closure which is called when the store is successfully loaded.
     */
    func load(completion: LoadHandler = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
    /**
     Save data to the persistent store.
     - parameter completion: A closure which is called with a boolean value indicating success.
     */
    class func save(completion: @escaping SaveHandler) {
        do {
            try shared.viewContext.save()
            completion(true)
        } catch {
            completion(false)
        }
    }
}
