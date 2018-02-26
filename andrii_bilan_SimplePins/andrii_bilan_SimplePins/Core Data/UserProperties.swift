//
//  User+CoreDataProperties.swift
//  andrii_bilan_SimplePins
//
//  Created by Andrii on 2/26/18.
//  Copyright © 2018 Andrii. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var photo: String?
    @NSManaged public var userID: String?
}
