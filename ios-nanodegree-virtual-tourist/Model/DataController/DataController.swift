//
//  DataController.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/13/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import Foundation
import CoreData

// MARK: Data Controller
class DataController {
    
    // MARK: - Shared Instance
    static var shared = DataController()
    
    // MARK: - Persistent Container
    let persistentContainer: NSPersistentContainer
    
    // MARK: - Contexts
    var viewContext: NSManagedObjectContext { return persistentContainer.viewContext }
    
    // MARK: - Photo Results Controller
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    var indexPathsToDelete = [IndexPath]()
    var indexPathsToInsert = [IndexPath]()
    var indexPathsToUpdate = [IndexPath]()
    
    // MARK: - Initialization
    private convenience init() {
        self.init(modelName: "VirtualTourist")
    }
    
    private init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
}
