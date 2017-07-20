//
//  CMRuling+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 15/04/2017.
//
//

import Foundation
import CoreData


extension CMRuling {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<CMRuling>(entityName: "CMRuling") as! NSFetchRequest<NSFetchRequestResult>
    }

    @NSManaged public var date: String?
    @NSManaged public var id: Int64
    @NSManaged public var text: String?
    @NSManaged public var card: CMCard?

}
