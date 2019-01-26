//
//  DownloadStatusView+StatusString.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/21/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import Foundation

extension DownloadStatusView {
    enum StatusString {
        case downloading(Int, Int)
        case noPhotos
        case preparing
        
        var stringValue: String {
            switch self {
            case .downloading(let current, let total): return "\(current) of \(total) Photos Downloaded"
            case .noPhotos: return "No Photos Available"
            case .preparing: return "Retrieving Gallery Information"
            }
        }
    }
}
