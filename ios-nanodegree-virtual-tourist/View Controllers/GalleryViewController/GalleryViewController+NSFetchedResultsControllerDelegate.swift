//
//  GalleryViewController+NSFetchedResultsControllerDelegate.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/18/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import CoreData

// MARK: Gallery View Controller - NSFetchResultsController Delegate
extension GalleryViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete: DataController.shared.indexPathsToDelete.append(indexPath!)
        case .insert: DataController.shared.indexPathsToInsert.append(newIndexPath!)
        case .move: break // move is not used in this application
        case .update: DataController.shared.indexPathsToUpdate.append(indexPath!)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DataController.shared.indexPathsToDelete = [IndexPath]()
        DataController.shared.indexPathsToInsert = [IndexPath]()
        DataController.shared.indexPathsToUpdate = [IndexPath]()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.performBatchUpdates(batchUpdates, completion: nil)
    }
    
    func batchUpdates() {
        collectionView.deleteItems(at: DataController.shared.indexPathsToDelete)
        collectionView.insertItems(at: DataController.shared.indexPathsToInsert)
        collectionView.reloadItems(at: DataController.shared.indexPathsToUpdate)
    }
}
