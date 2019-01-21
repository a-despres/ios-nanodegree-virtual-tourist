//
//  URLComponents+Extension.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/20/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import UIKit

extension URLComponents {
    
    /**
     Add key-value pairs as URLQueryItems.
     - parameter queryItems: A dictionary of key-value pairs to add as URLQueryItems.
     */
    mutating func addQueryItems(_ queryItems: [String: String]) {
        for (key, value) in queryItems {
            let queryItem = URLQueryItem(name: key, value: value)
            self.queryItems?.append(queryItem)
        }
    }
}
