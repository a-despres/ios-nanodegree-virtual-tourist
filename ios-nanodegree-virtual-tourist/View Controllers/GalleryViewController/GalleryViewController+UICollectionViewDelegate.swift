//
//  GalleryViewController+UICollectionViewDelegate.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/18/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import UIKit

extension GalleryViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GalleryCollectionViewCell

        switch isEditingGallery {
        case false: cell.favoriteIcon.isHidden = true
        case true: cell.favoriteIcon.isHidden = false
        }
        
        cell.photo.image = UIImage()
        cell.activityIndicator.startAnimating()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! GalleryCollectionViewCell
        let imageData = fetchedResultsController.object(at: indexPath).data!
        
        // hide activity indicator
        if imageData.count > 0 {
            cell.activityIndicator.stopAnimating()
            cell.photo.image = UIImage(data: imageData)
            cell.photo.contentMode = .scaleAspectFill
        } else {
            Client.downloadPhotoForIndexPath(indexPath, using: fetchedResultsController) { (data, error) in }
        }
        
        // customize how the favorite icon is displayed
        cell.favoriteIcon.image = cell.favoriteIcon.image?.withRenderingMode(.alwaysTemplate)
        cell.favoriteIcon.tintColor = UIColor(red: 1, green: 71/255, blue: 87/255, alpha: 1)

        // display the appropriate favorite icon
        if indexPathsToDelete.contains(indexPath) {
            cell.favoriteIcon.image = UIImage(named: "outline_favorite_border_black_24pt")
        } else {
            cell.favoriteIcon.image = UIImage(named: "outline_favorite_black_24pt")
        }
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
            let photo = fetchedResultsController.object(at: indexPath)
            
            switch cell.favoriteIcon.image {
            case favoriteFilled: cell.favoriteIcon.image = favoriteOutline
            case favoriteOutline: cell.favoriteIcon.image = favoriteFilled
            default: break
            }
            
            switch photosToDelete.contains(photo) {
            case false: photosToDelete.append(photo)
            case true:
                let index = photosToDelete.firstIndex(of: photo)!
                photosToDelete.remove(at: index)
            }
            
            toggleUpdateButton()
        }
    }
}
