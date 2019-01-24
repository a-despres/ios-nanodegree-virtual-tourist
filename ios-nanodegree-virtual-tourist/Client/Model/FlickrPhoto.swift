//
//  FlickrPhoto.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/13/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import Foundation

struct FlickrPhoto: Codable {
    let title: String
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case url = "url_n"
    }
}
