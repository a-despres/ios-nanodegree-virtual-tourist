//
//  Client+TypeAlias.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/20/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import Foundation

// MARK: Flickr API Client - Type Aliases for Completion Handlers
extension Client {
    
    /**
     - parameter data: The `Data` returned by the URLSessionDataTask. (optional)
     - parameter error: The `Error` object returned by the URLSessionDataTask. (optional)
     */
    typealias RequestHandler = (_ data: Data?, _ error: Error?) -> Void
    
    /**
     _ parameter associated: The `Photo` and `Pin` objects associated with the photo being downloaded.
     - parameter response: A tuple containing the photo data being returned from the download (optional) and the boolean value indicating if the download was successful.
     - parameter error: The `Error` object describing how the download failed. (optional)
     */
    typealias DownloadPhotoHandler = (_ associated: (Photo, Pin), _ response: (PhotoData?, Bool), _ error: Error?) -> Void
    
    /**
     - parameter metadata: A dictionary containing the `Location` and returned metadata if all of the metadata is parsed properly. (optional)
     - parameter error: An `Error` object describing how the parsing of metadata failed. (optional)
     */
    typealias DownloadMetadataHandler = (_ metadata: Metadata?, _ error: Error?) -> Void
    
    /// An alias used to describe photo data.
    typealias PhotoData = Data
    
    /// An alias used to describe photo metadata.
    typealias Metadata = (location: Location, response: SearchResponse)
}
