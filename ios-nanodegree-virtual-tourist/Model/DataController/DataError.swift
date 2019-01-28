//
//  DataError.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/27/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import Foundation

struct DataError: Error {
    enum ErrorType {
        case deletePhoto
        case deletePhotos
        case deletePin
        case loadPhotos
        case savePhoto
        
        var message: String {
            switch self {
            case .deletePhoto: return "There was a problem deleting a photo for this location. Please try again."
            case .deletePhotos: return "There was a problem deleting the photos for this location. Please try again."
            case .deletePin: return "There was a problem deleting the pin from the device. Please try again."
            case .loadPhotos: return "There was a problem loading the photos for this location. Please try again."
            case .savePhoto: return "There was a problem saving photo data to the device. Please try again."
            }
        }
    }
    
    var message = ""
    
    init (forType type: ErrorType) {
        self.message = type.message
    }
}
