//
//  CMSetBooster+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 15/04/2017.
//
//

import Foundation
import CoreData


extension CMSetBooster {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<CMSetBooster>(entityName: "CMSetBooster") as! NSFetchRequest<NSFetchRequestResult>
    }

    @NSManaged public var count: Int32
    @NSManaged public var id: Int64
    @NSManaged public var booster: CMBooster?
    @NSManaged public var set: CMSet?

}
