//
//  GalleryViewController+EmptyGalleryViewDelegate.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/31/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import UIKit

extension GalleryViewController: EmptyGalleryViewDelegate {
    func emptyGalleryView(_ emptyGalleryView: EmptyGalleryView, buttonTapped button: UIButton) {
        let location = Location(latitude: pin.latitude, longitude: pin.longitude)
        var pageNumber = 1
        
        if pin.totalPages > 1 {
            pageNumber = Int(arc4random_uniform(UInt32(pin!.totalPages))) + 1
        }
        
        Client.downloadMetadata(for: location, with: pageNumber, completion: handleDownloadMetadata(metadata:error:))
    }
}
