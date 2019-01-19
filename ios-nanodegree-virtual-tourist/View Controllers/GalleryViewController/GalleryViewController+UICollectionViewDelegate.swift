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
        cell.photo.image = UIImage(data: fetchedResultsController.object(at: indexPath).data!)
        cell.photo.contentMode = .scaleAspectFill
        
        cell.favoriteIcon.image = cell.favoriteIcon.image?.withRenderingMode(.alwaysTemplate)
        cell.favoriteIcon.tintColor = UIColor(red: 1, green: 71/255, blue: 87/255, alpha: 1)
        
        if indexPathsToDelete.contains(indexPath) {
            cell.favoriteIcon.image = UIImage(named: "outline_favorite_border_black_24pt")
        } else {
            cell.favoriteIcon.image = UIImage(named: "outline_favorite_black_24pt")
        }
        
        return cell
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
        let cell = collectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell
        cell.favoriteIcon.image = UIImage(named: "outline_favorite_border_black_24pt")
        
        indexPathsToDelete.append(indexPath)
        print(indexPathsToDelete)
    }
}
