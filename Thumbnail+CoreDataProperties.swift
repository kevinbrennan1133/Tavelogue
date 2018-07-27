//
//  Thumbnail+CoreDataProperties.swift
//  Documents Core Data Relationships
//
//  Created by Kevin Brennan on 7/27/18.
//  Copyright © 2018 Dale Musser. All rights reserved.
//
//

import Foundation
import CoreData


extension Thumbnail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Thumbnail> {
        return NSFetchRequest<Thumbnail>(entityName: "Thumbnail")
    }

    @NSManaged public var id: Double
    @NSManaged public var imageData: NSData?
    @NSManaged public var fullRes: FullRes?

}
