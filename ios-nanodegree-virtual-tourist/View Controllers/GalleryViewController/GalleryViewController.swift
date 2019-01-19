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
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    var indexPathsToDelete = [IndexPath]()
    var pin: Pin!

    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
//        if let result = try? fetchedResultsController.performFetch() {
//            photos = result
//            print("Number of photos:", photos.count)
//        }
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
