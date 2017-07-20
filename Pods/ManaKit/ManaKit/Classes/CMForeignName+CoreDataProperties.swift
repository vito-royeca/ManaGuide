//
//  CMForeignName+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 15/04/2017.
//
//

import Foundation
import CoreData


extension CMForeignName {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<CMForeignName>(entityName: "CMForeignName") as! NSFetchRequest<NSFetchRequestResult>
    }

    @NSManaged public var id: Int64
    @NSManaged public var multiverseid: Int64
    @NSManaged public var name: String?
    @NSManaged public var card: CMCard?
    @NSManaged public var language: CMLanguage?

}
