//
//  MapViewController.swift
//  andrii_bilan_SimplePins
//
//  Created by Andrii on 2/23/18.
//  Copyright © 2018 Andrii. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIPopoverPresentationControllerDelegate {
    var fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "User", keyForSort: "name")
    
    @IBAction func currentLocation(_ sender: UIButton) {
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        locationManager.stopUpdatingLocation()
        guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        let homeLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        let regionRadius: CLLocationDistance = 200
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(homeLocation.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
//        if (CLLocationManager.locationServicesEnabled()) {
//            if locationManager == nil {
//                locationManager = CLLocationManager()
//            }
//            locationManager?.requestWhenInUseAuthorization()
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.requestAlwaysAuthorization()
//            locationManager.startUpdatingLocation()
//        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func showUserInfo(_ sender: UIButton) {
        let popOverVC = UIStoryboard(name: "user", bundle: nil).instantiateViewController(withIdentifier: "popUpID") as! UserInfoViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    
    var region: MKCoordinateRegion?
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
       
        //Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
             }
        //Zoom to user location
//        let noLocation = CLLocationCoordinate2D()
//        let viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 200, 200)
//        mapView.setRegion(viewRegion, animated: false)

        //DispatchQueue.main.async {
        //    self.locationManager.startUpdatingLocation()
       // }
//
//
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addPlace(_ sender: UILongPressGestureRecognizer) {
        let addPlaceAlertController = UIAlertController(title: "New Place", message: "Do you want add new place?", preferredStyle: .alert)
        
        addPlaceAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            self.performSegue(withIdentifier: "showNewPlace", sender: nil)
            print("OK")
        }))
        addPlaceAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in
            print("Cancel")
        }))
        self.present(addPlaceAlertController, animated: true, completion: nil)
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    
//        let location = locations.last
//        let center = CLLocationCoordinate2D(latitude: 56, longitude: 34)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        self.mapView.setRegion(region, animated: true)
//        if self.mapView.annotations.count != 0 {
//        //    annotation = self.mapView.annotations[0]
//        //    self.mapView.removeAnnotation(annotation)
//        }
//        let pointAnnotation = MKPointAnnotation()
//        pointAnnotation.coordinate = location!.coordinate
//        pointAnnotation.title = ""
//        mapView.addAnnotation(pointAnnotation)
    }
    
 
}
