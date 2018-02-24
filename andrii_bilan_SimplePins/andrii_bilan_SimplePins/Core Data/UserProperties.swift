//
//  User+CoreDataProperties.swift
//  andrii_bilan_SimplePins
//
//  Created by Andrii on 2/24/18.
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
    @NSManaged public var relationship: NSSet?

}

// MARK: Generated accessors for relationship
extension User {

    @objc(addRelationshipObject:)
    @NSManaged public func addToRelationship(_ value: Place)

    @objc(removeRelationshipObject:)
    @NSManaged public func removeFromRelationship(_ value: Place)

    @objc(addRelationship:)
    @NSManaged public func addToRelationship(_ values: NSSet)

    @objc(removeRelationship:)
    @NSManaged public func removeFromRelationship(_ values: NSSet)

}
