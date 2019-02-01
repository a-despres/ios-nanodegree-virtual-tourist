//
//  GalleryViewController+UICollectionViewDelegate.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/18/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import UIKit

// MARK: Gallery View Controller - UICollectionView Delegate
extension GalleryViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = DataController.shared.fetchedResultsController.fetchedObjects?.count ?? 0
        if count == 0 {
            editButton.isEnabled = false
            emptyView.isHidden = false
            toggleEmptyViewButton()
        }
        else {
            editButton.isEnabled = true
            emptyView.isHidden = true
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GalleryCollectionViewCell
        cell.setFavoriteIconVisibility(isEditingGallery)
        cell.displayPlaceholder()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! GalleryCollectionViewCell
        let photoData = DataController.shared.fetchedResultsController.object(at: indexPath).data!
        
        // hide activity indicator and show image, otherwise download image data
        if photoData.count > 0 { cell.displayPhoto(data: photoData) }
        else { downloadPhoto(for: indexPath) }

        // display the appropriate favorite icon
        if DataController.shared.indexPathsToDelete.contains(indexPath) { cell.setFavoriteIconState(.readyToDelete) }
        else { cell.setFavoriteIconState(.normal) }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // cast layout as flow layout
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize(width: 50, height: 50) }
        
        // set cell size to three per row
        let spacing = flowLayout.minimumInteritemSpacing
        let width = (collectionView.frame.width - spacing * 2) / 3
        let size = CGSize(width: width, height: width)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isEditingGallery {
            let cell = collectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell
            let photo = DataController.shared.fetchedResultsController.object(at: indexPath)
            
            cell.toggleFavoriteIcon()
            
            switch photosToDelete.contains(photo) {
            case false:
                photosToDelete.append(photo)
                
            case true:
                let index = photosToDelete.firstIndex(of: photo)!
                photosToDelete.remove(at: index)
            }
            
            toggleUpdateButton()
        }
    }
}

// MARK: - Helper Functions
extension GalleryViewController {
    
    /**
     Download the photo for the given IndexPath.
     - parameter indexPath: The IndexPath of the specified cell and Photo object.
     */
    func downloadPhoto(for indexPath: IndexPath) {
        let photo = DataController.shared.fetchedResultsController.object(at: indexPath)
        if let url = URL(string: photo.url!) {
            Client.downloadPhoto(from: url, for: photo, in: pin, completion: handleDownloadPhoto(associated:response:error:))
        }
    }
}
