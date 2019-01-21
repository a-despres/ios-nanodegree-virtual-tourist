//
//  GalleryViewController+NSFetchedResultsControllerDelegate.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/18/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import CoreData

extension GalleryViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete: indexPathsToDelete.append(indexPath!)
        case .insert: indexPathsToInsert.append(newIndexPath!)
        case .move: break // move is not used in this application
        case .update: indexPathsToUpdate.append(indexPath!)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        indexPathsToDelete = [IndexPath]()
        indexPathsToInsert = [IndexPath]()
        indexPathsToUpdate = [IndexPath]()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.performBatchUpdates(batchUpdates, completion: nil)
    }
    
    func batchUpdates() {
        collectionView.deleteItems(at: indexPathsToDelete)
        collectionView.insertItems(at: indexPathsToInsert)
        collectionView.reloadItems(at: indexPathsToUpdate)
    }
}
