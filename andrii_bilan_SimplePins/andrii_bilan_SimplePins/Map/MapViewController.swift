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
import FBSDKLoginKit
class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIPopoverPresentationControllerDelegate {
    var selectedAnnotation: CustomAnnotation?
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var pressCoordinate: Location?
    var placeArray:[Place] = []
    var fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "Place", keyForSort: "name")
    
    @IBOutlet weak var proffileButtonImage: MyButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func currentLocation(_ sender: UIButton) {
        guard locationManager != nil else {
            return
        }
        guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        currentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        let regionRadius: CLLocationDistance = 200
        let coordinateRegion = MKCoordinateRegionMakeWithDistance((currentLocation?.coordinate)!,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func showUserInfo(_ sender: UIButton) {
        let popOverVC = UIStoryboard(name: "user", bundle: nil).instantiateViewController(withIdentifier: "popUpID") as! UserInfoViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    @IBAction func addPlace(_ sender: UILongPressGestureRecognizer) {
        locationManager.stopUpdatingLocation()
        sender.minimumPressDuration = 1
        switch sender.state {
        case UIGestureRecognizerState.began:
            let pointAfterPress = sender.location(in: mapView)
            let location = mapView.convert(pointAfterPress, toCoordinateFrom: mapView)
            let addPlaceAlertController = UIAlertController(title: "New Place", message: "Do you want add new place?", preferredStyle: .alert)
            addPlaceAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                self.pressCoordinate = Location(latitude: location.latitude, longitude: location.longitude)
                self.performSegue(withIdentifier: "showNewPlace", sender: self.pressCoordinate)
            }))
            addPlaceAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(addPlaceAlertController, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func locationManagerConfigurate() {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
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
        fetchPlaceData()
        addAnnotations(coords: placeArray)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
    }
    
    func fetchPlaceData() {
        let fetchRequest = fetchedResultsController.fetchRequest
        let predicate = NSPredicate(format: "userID == %@", FBSDKAccessToken.current().userID)
        fetchRequest.predicate = predicate
        do {
            placeArray = (try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest) as? [Place])!
            print(placeArray.debugDescription)
        } catch {
            print("Error fetch")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedAnnotation = view.annotation as? CustomAnnotation
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        var viewAnnotation: MKPinAnnotationView
        viewAnnotation =  MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        if annotation is MKUserLocation {
            let annotation = "Current Location"
            viewAnnotation = MKPinAnnotationView(annotation: annotation as? MKAnnotation, reuseIdentifier: identifier)
            viewAnnotation.canShowCallout = true
            viewAnnotation.calloutOffset = CGPoint(x: -5, y: 5)
            viewAnnotation.leftCalloutAccessoryView = UIButton(type: .contactAdd) as UIView
            viewAnnotation.pinTintColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            return viewAnnotation
        } else {
            if let annotation = annotation as? CustomAnnotation {
                viewAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                viewAnnotation.canShowCallout = true
                viewAnnotation.calloutOffset = CGPoint(x: -5, y: 5)
                viewAnnotation.pinTintColor = #colorLiteral(red: 0.9201840758, green: 0.2923389375, blue: 0.4312838316, alpha: 1)
                let longGesture = UILongPressGestureRecognizer()
                longGesture.addTarget(self, action:  #selector(MapViewController.deletePin))
                viewAnnotation.addGestureRecognizer(longGesture)
                return viewAnnotation
            }
            return viewAnnotation
        }
    }
    
    func addAnnotations(coords: [Place]) {
        var annotations = [CustomAnnotation]()
        for each in coords {
            let annotation : CustomAnnotation = CustomAnnotation(place: each)
            annotations.append(annotation as CustomAnnotation)
        }
        mapView.addAnnotations(annotations)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.leftCalloutAccessoryView {
            guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
            pressCoordinate = Location(latitude: locValue.latitude, longitude: locValue.longitude)
            performSegue(withIdentifier: "showNewPlace", sender: pressCoordinate)
        }
    }
    
    @objc func deletePin() {
        let deleteAlertController = UIAlertController(title: "Delete Place", message: "Do you want delete Place?", preferredStyle: .alert)
        deleteAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.fetchPinForDelete(name: (self.selectedAnnotation?.title)!)
            self.fetchPlaceData()
            self.addAnnotations(coords: self.placeArray)
        }))
        deleteAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(deleteAlertController, animated: true, completion: nil)
    }

    func fetchPinForDelete(name: String) {
        let fetchRequest = fetchedResultsController.fetchRequest
        let predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.predicate = predicate
        var pinForDelete: [Place] = []
        do {
            pinForDelete = (try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest) as? [Place])!
            print(placeArray.debugDescription)
        } catch {
            print("Error fetch")
        }
        deletefromData(places: pinForDelete)
    }
    
    func deletefromData(places: [Place]) {
        for place in places {
            CoreDataManager.instance.managedObjectContext.delete(place)
            CoreDataManager.instance.saveContext()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        fetchPlaceData()
        updateMap()
    }
    
    func updateMap() {
        mapView.removeAnnotations(self.mapView.annotations)
        addAnnotations(coords: placeArray)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showNewPlace":
                let newPlaceVC = segue.destination as! AddNewPlaceTableVC
                newPlaceVC.placesLocation = pressCoordinate
            default: break
            }
        }
    }
}
