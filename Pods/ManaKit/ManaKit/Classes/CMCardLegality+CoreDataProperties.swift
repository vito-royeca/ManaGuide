//
//  CMCardLegality+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 15/04/2017.
//
//

import Foundation
import CoreData


extension CMCardLegality {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<CMCardLegality>(entityName: "CMCardLegality") as! NSFetchRequest<NSFetchRequestResult>
    }

    @NSManaged public var id: Int64
    @NSManaged public var card: CMCard?
    @NSManaged public var format: CMFormat?
    @NSManaged public var legality: CMLegality?

}
