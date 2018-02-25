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
    var region: MKCoordinateRegion?
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var managerOfLocation: CLLocationManager!
    var pressCoordinate: Location?
    var fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "User", keyForSort: "name")
    
    @IBAction func currentLocation(_ sender: UIButton) {
//        self.locationManager.requestAlwaysAuthorization()
//        self.locationManager.requestWhenInUseAuthorization()
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
//        }
//        locationManager.stopUpdatingLocation()
        guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        currentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        let regionRadius: CLLocationDistance = 200
        let coordinateRegion = MKCoordinateRegionMakeWithDistance((currentLocation?.coordinate)!,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func showUserInfo(_ sender: UIButton) {
        let popOverVC = UIStoryboard(name: "user", bundle: nil).instantiateViewController(withIdentifier: "popUpID") as! UserInfoViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
  
    func locationManagerConfigurate() {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            //locationManager.requestLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                locationManager.startUpdatingLocation()
            } else {
                locationManager!.requestWhenInUseAuthorization()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManagerConfigurate()
        
//        if (CLLocationManager.locationServicesEnabled()) {
//            locationManager = CLLocationManager()
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.requestAlwaysAuthorization()
//            locationManager.requestWhenInUseAuthorization()
//        }
    }
    
    @IBAction func addPlace(_ sender: UILongPressGestureRecognizer) {
        locationManager.stopUpdatingLocation()
        let pointAfterPress = sender.location(in: mapView)
        let location = mapView.convert(pointAfterPress, toCoordinateFrom: mapView)
        print("location: \(location.latitude) and \(location.longitude)")
        let addPlaceAlertController = UIAlertController(title: "New Place", message: "Do you want add new place?", preferredStyle: .alert)
        
        addPlaceAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            self.pressCoordinate = Location(latitude: location.latitude, longitude: location.longitude)
            self.performSegue(withIdentifier: "showNewPlace", sender: self.pressCoordinate)
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
//        _ = locations.last as! CLLocation
//        let currentLocation: CLLocation = locations[0] as CLLocation
//        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
//        myAnnotation.coordinate = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
//        myAnnotation.title = "Current Location"
//        mapView.addAnnotation(myAnnotation)

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if let identifier = segue.identifier {
            switch identifier {
            case "showNewPlace":
                let newPlaceVC = segue.destination as! AddNewPlaceTableVC
                newPlaceVC.placesLocation = pressCoordinate as! Location
            default: break
            }
        }
    }
}
