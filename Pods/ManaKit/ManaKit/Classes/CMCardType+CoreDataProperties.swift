//
//  CMCardType+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 15/04/2017.
//
//

import Foundation
import CoreData


extension CMCardType {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<CMCardType>(entityName: "CMCardType") as! NSFetchRequest<NSFetchRequestResult>
    }

    @NSManaged public var name: String?
    @NSManaged public var cards: NSSet?
    @NSManaged public var cardSubtypes: NSSet?
    @NSManaged public var cardSupertypes: NSSet?
    @NSManaged public var cardTypes: NSSet?

}

// MARK: Generated accessors for cards
extension CMCardType {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CMCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CMCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}

// MARK: Generated accessors for cardSubtypes
extension CMCardType {

    @objc(addCardSubtypesObject:)
    @NSManaged public func addToCardSubtypes(_ value: CMCard)

    @objc(removeCardSubtypesObject:)
    @NSManaged public func removeFromCardSubtypes(_ value: CMCard)

    @objc(addCardSubtypes:)
    @NSManaged public func addToCardSubtypes(_ values: NSSet)

    @objc(removeCardSubtypes:)
    @NSManaged public func removeFromCardSubtypes(_ values: NSSet)

}

// MARK: Generated accessors for cardSupertypes
extension CMCardType {

    @objc(addCardSupertypesObject:)
    @NSManaged public func addToCardSupertypes(_ value: CMCard)

    @objc(removeCardSupertypesObject:)
    @NSManaged public func removeFromCardSupertypes(_ value: CMCard)

    @objc(addCardSupertypes:)
    @NSManaged public func addToCardSupertypes(_ values: NSSet)

    @objc(removeCardSupertypes:)
    @NSManaged public func removeFromCardSupertypes(_ values: NSSet)

}

// MARK: Generated accessors for cardTypes
extension CMCardType {

    @objc(addCardTypesObject:)
    @NSManaged public func addToCardTypes(_ value: CMCard)

    @objc(removeCardTypesObject:)
    @NSManaged public func removeFromCardTypes(_ value: CMCard)

    @objc(addCardTypes:)
    @NSManaged public func addToCardTypes(_ values: NSSet)

    @objc(removeCardTypes:)
    @NSManaged public func removeFromCardTypes(_ values: NSSet)

}
