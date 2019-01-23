//
//  GalleryCollectionViewCell+Photo.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/22/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import UIKit

// MARK: Gallery Collection View Cell - Photo
extension GalleryCollectionViewCell {
    
    /**
     Display the photo using the provided data.
     - parameter data: The photo data to display.
     */
    func displayPhoto(data: Data) {
        activityIndicator.stopAnimating()
        photo.image = UIImage(data: data)
        photo.contentMode = .scaleAspectFill
    }
    
    /// Display an image placeholder with animating activity indicator.
    func displayPlaceholder() {
        photo.image = UIImage()
        activityIndicator.startAnimating()
    }
}
