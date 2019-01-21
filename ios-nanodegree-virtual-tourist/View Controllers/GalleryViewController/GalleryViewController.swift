//
//  GalleryViewController.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/7/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class GalleryViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var editPane: UIView!
    @IBOutlet weak var editPaneVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var updateButton: UIButton!
    
    // MARK: - Properties
    var favoriteFilled = UIImage(named: "outline_favorite_black_24pt")
    var favoriteOutline = UIImage(named: "outline_favorite_border_black_24pt")
    
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    var indexPathsToDelete = [IndexPath]()
    var indexPathsToInsert = [IndexPath]()
    var indexPathsToUpdate = [IndexPath]()
    
    var isEditingGallery = false
    var photosToDelete = [Photo]()
    var pin: Pin!
    
    // MARK: - IBActions
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        toggleEditingState()
    }
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        for photo in photosToDelete {
            DataController.delete(photo: photo) { [unowned self] success in
                switch success {
                case false: print("error") // TODO: add proper error handling
                case true:
                    self.photosToDelete = [Photo]()
                    self.toggleUpdateButton()
                }
            }
        }
    }
    
    @IBAction func newGalleryTapped(_ sender: UIButton) {
        guard let photos = fetchedResultsController.fetchedObjects else { return }
        guard let latitude = Double(pin.latitude!) else { return }
        guard let longitude = Double(pin.longitude!) else { return }
        
        // remove all existing photos
        DataController.delete(photos: photos) { success in
            // download new photo set
            let location = Location(latitude: latitude, longitude: longitude)
            Client.downloadMetadata(for: location, completion: { (metadata, error) in
                
            })
        }
    }
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Move edit pane off screen
        toggleEditPane(animated: false)
        
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.sortDescriptors = []
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        // get pins latitude and longitude
        guard let latitude = Double(pin.latitude!) else { return }
        guard let longitude = Double(pin.longitude!) else { return }
        
        // create point annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        // center map on pin
        mapView.addAnnotation(annotation)
        mapView.setCenter(annotation.coordinate, animated: false)
        mapView.camera.altitude = 32768
    }
}
