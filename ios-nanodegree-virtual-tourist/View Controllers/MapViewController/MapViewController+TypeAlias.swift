//
//  MapViewController+TypeAlias.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/21/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import MapKit

// MARK: Map View Controller - Type Aliases for Completion Handlers
extension MapViewController {
    
    /**
     - parameter annotation: The annotation that was used in the geocoding process.
     - parameter name: The locality name returned by the geocoding process. (optional)
     - parameter error: The `Error` object describing how the geocoding process failed. (optional)
     */
    typealias GeocodeHandler = (_ annotation: MKPointAnnotation, _ name: String?, _ error: Error?) -> Void
}
