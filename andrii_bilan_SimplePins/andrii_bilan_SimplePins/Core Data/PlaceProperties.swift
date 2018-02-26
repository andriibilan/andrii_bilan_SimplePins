//
//  Place+CoreDataProperties.swift
//  andrii_bilan_SimplePins
//
//  Created by Andrii on 2/25/18.
//  Copyright © 2018 Andrii. All rights reserved.
//
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var userID: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var descriptions: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var photo: String?

}
