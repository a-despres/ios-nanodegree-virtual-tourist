//
//  GalleryViewController+MKMapViewDelegate.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/27/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import MapKit

extension GalleryViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: false)
    }
}
