//
//  MapViewController+DownloadStatusViewDelegate.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/21/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import Foundation

extension MapViewController: DownloadStatusViewDelegate {
    func buttonPressed() {
        statusView.hide()
        performSegue(withIdentifier: "showGallery", sender: newPin)
    }
}
