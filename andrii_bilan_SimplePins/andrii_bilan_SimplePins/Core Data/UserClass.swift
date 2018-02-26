//
//  User+CoreDataClass.swift
//  andrii_bilan_SimplePins
//
//  Created by Andrii on 2/26/18.
//  Copyright © 2018 Andrii. All rights reserved.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "User"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
