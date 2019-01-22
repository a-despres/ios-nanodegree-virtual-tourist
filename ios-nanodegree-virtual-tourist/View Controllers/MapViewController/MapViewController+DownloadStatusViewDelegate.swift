//
//  MapViewController+DownloadStatusViewDelegate.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/21/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import UIKit

// MARK: Map View Controller - Download Status View Delegate
extension MapViewController: DownloadStatusViewDelegate {
    
    func downloadStatusView(_ downloadStatusView: DownloadStatusView, buttonTapped button: UIButton) {
        statusView.setVisible(false, animated: false)
        performSegue(withIdentifier: "showGallery", sender: newPin)
    }
}
