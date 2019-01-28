//
//  DownloadStatusView+Status.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/21/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import Foundation

extension DownloadStatusView {
    enum Status {
        case complete
        case downloading
        case gettingLocation
        case noMetadata
        case noPhotos
        case preparingDownload
        case unknownLocation
    }
}
