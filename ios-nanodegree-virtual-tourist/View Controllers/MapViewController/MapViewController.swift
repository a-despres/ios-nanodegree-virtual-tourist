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
    @IBOutlet weak var statusView: DownloadStatusView!    
    @IBOutlet weak var instructionsVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var instructionsView: UIView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var longPressGestureRecognizer: UILongPressGestureRecognizer!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    var activePin: MKPointAnnotation!
    var isDownloading: Bool = true
    var isEditingMap: Bool = false
    var newPin: Pin!
    var pins: [Pin] = [Pin]()
    
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
    
    @IBAction func viewGalleryButtonTapped(_ sender: UIButton) {
        toggleDownloadStatus(animated: false)
        performSegue(withIdentifier: "showGallery", sender: newPin)
    }
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        statusView.delegate = self
        
        // Setup UI
        prepareUI()
        
        // Move instructions view off screen
        toggleInstructionsView(animated: false)
        
        // Load data using core data controller
        DataController.shared.load()
        
        if let result = DataController.fetchPins() {
            pins = result
            place(pins: pins, on: mapView)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGallery" {
            guard let galleryVC = segue.destination as? GalleryViewController else { return }
            guard let pin = sender as? Pin else { return }
            
            galleryVC.pin = pin
        }
    }
    
    // MARK: - UI
    func prepareUI() {
        statusView.hide()
        toggleDownloadStatus(animated: false)
    }
    
    func toggleDownloadStatus(animated: Bool) {
        isDownloading = !isDownloading
        
        switch isDownloading {
        case false:
            statusView.start()
        case true:
            statusView.stop()
        }
        
        if animated {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { self.view.layoutIfNeeded() }, completion: nil)
        }
    }
}
