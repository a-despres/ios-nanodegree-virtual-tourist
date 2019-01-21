//
//  MapViewController+MKMapViewDelegate.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/7/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import MapKit

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        // Enable the edit button if disabled
        if !editButton.isEnabled { editButton.isEnabled = true }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        switch isEditingMap {
        case false:
            view.isSelected = false
            if let pin = DataController.fetchPin(with: view.annotation!.coordinate.toLocation()) {
                performSegue(withIdentifier: "showGallery", sender: pin)
            }
        case true:
            remove(pin: view.annotation as! MKPointAnnotation, from: mapView)
        }
    }
}
