//
//  GalleryViewController.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/7/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import UIKit
import MapKit

class GalleryViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    var annotation: MKPointAnnotation!

    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // center map on pin
        mapView.addAnnotation(annotation)
        mapView.setCenter(annotation.coordinate, animated: false)
        mapView.camera.altitude = 32768
    }
}
