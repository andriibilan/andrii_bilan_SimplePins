//
//  Location.swift
//  andrii_bilan_SimplePins
//
//  Created by Andrii on 2/25/18.
//  Copyright © 2018 Andrii. All rights reserved.
//
import Foundation
import CoreLocation

struct Location {
    var latitude: Double
    var longitude: Double
    
    /// Gets user's current location
    static var currentLocation: Location {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        let location = manager.location
        if location != nil {
            return Location(latitude: location!.coordinate.latitude,
                            longitude: location!.coordinate.longitude)
        }
        else {
            return Location(latitude: 49.841856, longitude: 24.031530)
        }
    }
}
