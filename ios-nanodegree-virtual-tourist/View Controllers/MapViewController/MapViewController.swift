//
//  MapViewController.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/7/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var downloadStatusActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var downloadStatusGalleryButton: UIButton!
    @IBOutlet weak var downloadStatusLocationName: UILabel!
    @IBOutlet weak var downloadStatusLocationNameVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var downloadStatusPhotoCount: UILabel!
    @IBOutlet weak var downloadStatusPhotoCountVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var downloadStatusVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var downloadStatusView: UIView!
    
    @IBOutlet weak var instructionsVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var instructionsView: UIView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet var longPressGestureRecognizer: UILongPressGestureRecognizer!
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
        
        // Setup UI
        prepareUI()
        
        // Move instructions view off screen
        toggleInstructionsView(animated: false)
        
        // Load data using core data controller
        DataController.shared.load()
        
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        
        if let result = try? DataController.shared.viewContext.fetch(fetchRequest) {
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
        downloadStatusGalleryButton.layer.cornerRadius = downloadStatusGalleryButton.frame.height / 2
        downloadStatusView.layer.cornerRadius = downloadStatusView.frame.height / 2
        toggleDownloadStatus(animated: false)
    }
    
    func toggleDownloadStatus(animated: Bool) {
        isDownloading = !isDownloading
        
        switch isDownloading {
        case false:
            downloadStatusPhotoCount.alpha = 1
            downloadStatusPhotoCountVerticalConstraint.constant = 8
            downloadStatusLocationNameVerticalConstraint.constant = -8
            downloadStatusVerticalConstraint.constant = -96
        case true:
            downloadStatusVerticalConstraint.constant = 48
        }
        
        if animated {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { self.view.layoutIfNeeded() }, completion: nil)
        }
    }
    
    func hidePhotoCount() {
        
        downloadStatusLocationNameVerticalConstraint.constant = 0
        downloadStatusPhotoCountVerticalConstraint.constant = 16
        downloadStatusPhotoCount.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
