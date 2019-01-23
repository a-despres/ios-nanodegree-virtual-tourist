//
//  GalleryCollectionViewCell.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/18/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import UIKit

// MARK: Gallery View Controller - Cell
class GalleryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Constants
    let favoriteFilled = UIImage(named: "outline_favorite_black_24pt")
    let favoriteOutline = UIImage(named: "outline_favorite_border_black_24pt")
    let iconColor = UIColor(red: 1, green: 71/255, blue: 87/255, alpha: 1)
    
    // MARK: - IBOutlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoriteIcon: UIImageView!
    @IBOutlet weak var photo: UIImageView!
}
