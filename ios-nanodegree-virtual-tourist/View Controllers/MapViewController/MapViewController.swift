//
//  MapViewController.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/7/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var instructionsVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var instructionsView: UIView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet var longPressGestureRecognizer: UILongPressGestureRecognizer!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    var activePin: MKPointAnnotation!
    var isEditingMap: Bool = false
    
    // MARK: - IBActions
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        toggleEditingState()
    }
    
    @IBAction func handleLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: mapView)
        
        switch sender.state {
        case .began:
            activePin = MKPointAnnotation()
            add(pin: activePin, to: mapView, at: point)
            
        case .changed:
            move(pin: activePin, on: mapView, to: point)
            
        case .ended:
            drop(pin: activePin, on: mapView, at: point)
            activePin = nil
            
        default: break
        }
    }
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Move instructions view off screen
        toggleInstructionsView(animated: false)
    }
}