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
        case gettingLocation
        case noMetadata
        case noPhotos
        case preparingDownload
        case unknownLocation
        
        var stringValue: String {
            switch self {
            case .downloading(let current, let total): return "\(current) of \(total) Photos Downloaded"
            case .gettingLocation: return "Downloading Location Information"
            case .noMetadata: return "Could Not Download Photo Metadata"
            case .noPhotos: return "No Photos Available"
            case .preparingDownload: return "Retrieving Gallery Information"
            case .unknownLocation: return "Could Not Download Location Information"
            }
        }
    }
}
