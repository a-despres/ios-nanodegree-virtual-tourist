//
//  FlickrPhotos.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/13/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import Foundation

struct FlickrPhotos: Codable {
    let page: Int
    let pages: Int
    let photos: [FlickrPhoto]
    let total: String
    
    enum CodingKeys: String, CodingKey {
        case page
        case pages
        case photos = "photo"
        case total
    }
}
