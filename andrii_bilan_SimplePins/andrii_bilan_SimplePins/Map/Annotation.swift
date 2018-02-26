//
//  Annotation.swift
//  andrii_bilan_SimplePins
//
//  Created by Andrii on 2/25/18.
//  Copyright © 2018 Andrii. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var title: String?
     var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var image: UIImage?
    var place: Place?
    var date : NSDate?
    let fileManager = FileManagers()

    init(place: Place) {
        self.coordinate = CLLocationCoordinate2DMake(place.latitude, place.longitude)
        self.place = place
        self.title = place.name
        self.subtitle = place.descriptions
        self.date = place.date

    }
}

