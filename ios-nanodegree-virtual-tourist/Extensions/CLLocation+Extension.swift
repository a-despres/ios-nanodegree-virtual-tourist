//
//  CLLocation+Extension.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/20/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D {
    
    /// Convert a `CLLocationCoordinate2D` object into a `Location` object.
    func toLocation() -> Location {
        return Location(latitude: self.latitude, longitude: self.longitude)
    }
}
