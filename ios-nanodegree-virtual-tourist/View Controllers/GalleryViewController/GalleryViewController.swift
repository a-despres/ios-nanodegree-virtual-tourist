//
//  GalleryViewController.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/7/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import UIKit
import MapKit

// MARK: Gallery View Controller
class GalleryViewController: UIViewController {
    
    // MARK: - Properties
    var isEditingGallery = false
    var photosToDelete = [Photo]()
    var pin: Pin!
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var editPane: UIView!
    @IBOutlet weak var editPaneVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var updateButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        toggleEditingState()
    }
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        for photo in photosToDelete {
            DataController.delete(photo: photo, completion: handleDeletePhoto(success:))
        }
    }
    
    @IBAction func newGalleryTapped(_ sender: UIButton) {
        guard let photos = DataController.shared.fetchedResultsController.fetchedObjects else { return }
        DataController.delete(photos: photos, completion: handleDeletePhotos(success:))
    }
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // move edit pane off screen
        toggleEditPane(animated: false)
        
        // fetch the photos for the gallery
        DataController.fetchPhotos(for: pin, using: self, completion: handleFetchPhotos(success:))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // create point annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        
        // center map on pin
        mapView.addAnnotation(annotation)
        mapView.setCenter(annotation.coordinate, animated: false)
        mapView.camera.altitude = 32768
    }
}
