//
//  ClientError.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/27/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import Foundation

struct ClientError: Error {
    enum ErrorType {
        case downloadMetadata
        case url
        
        var message: String {
            switch self {
            case .downloadMetadata: return "There was a problem downloading the photo metadata for this location. Please try again."
            case .url: return "There was a problem with a photo's URL. Delete the pin for this location and try again."
            }
        }
    }
    
    var message = ""
    
    init (forType type: ErrorType) {
        self.message = type.message
    }
}
