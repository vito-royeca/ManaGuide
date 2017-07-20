//
//  CMColor+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 15/04/2017.
//
//

import Foundation
import CoreData


extension CMColor {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<CMColor>(entityName: "CMColor") as! NSFetchRequest<NSFetchRequestResult>
    }

    @NSManaged public var name: String?
    @NSManaged public var symbol: String?
    @NSManaged public var cardColors: NSSet?
    @NSManaged public var cardIdentities: NSSet?

}

// MARK: Generated accessors for cardColors
extension CMColor {

    @objc(addCardColorsObject:)
    @NSManaged public func addToCardColors(_ value: CMCard)

    @objc(removeCardColorsObject:)
    @NSManaged public func removeFromCardColors(_ value: CMCard)

    @objc(addCardColors:)
    @NSManaged public func addToCardColors(_ values: NSSet)

    @objc(removeCardColors:)
    @NSManaged public func removeFromCardColors(_ values: NSSet)

}

// MARK: Generated accessors for cardIdentities
extension CMColor {

    @objc(addCardIdentitiesObject:)
    @NSManaged public func addToCardIdentities(_ value: CMCard)

    @objc(removeCardIdentitiesObject:)
    @NSManaged public func removeFromCardIdentities(_ value: CMCard)

    @objc(addCardIdentities:)
    @NSManaged public func addToCardIdentities(_ values: NSSet)

    @objc(removeCardIdentities:)
    @NSManaged public func removeFromCardIdentities(_ values: NSSet)

}
