//
//  Place+CoreDataClass.swift
//  andrii_bilan_SimplePins
//
//  Created by Andrii on 2/24/18.
//  Copyright © 2018 Andrii. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Place)
public class Place: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "Place"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
