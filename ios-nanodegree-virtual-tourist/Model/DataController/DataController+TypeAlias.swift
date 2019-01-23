//
//  DataController+TypeAlias.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/22/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import Foundation
import MapKit

// MARK: Data Controller - Type Aliases
extension DataController {
    
    // MARK: - IO
    typealias LoadHandler = (() -> Void)?
    typealias SaveHandler = (_ success: Bool) -> Void
    
    // MARK: - Photo
    typealias AddPhotoHandler = (_ photo: Photo, _ pin: Pin, _ success: Bool) -> Void
    typealias DeletePhotoHandler = (_ success: Bool) -> Void
    typealias FetchPhotosHandler = (_ success: Bool) -> Void
    
    // MARK: - Pin
    typealias AddPinHandler = (_ pin: MKPointAnnotation, _ map: MKMapView, _ success: Bool) -> Void
    typealias DeletePinHandler = (_ annotation: MKPointAnnotation, _ map: MKMapView, _ success: Bool) -> Void
}
