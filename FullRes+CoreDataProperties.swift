//
//  FullRes+CoreDataProperties.swift
//  Documents Core Data Relationships
//
//  Created by Kevin Brennan on 7/27/18.
//  Copyright © 2018 Dale Musser. All rights reserved.
//
//

import Foundation
import CoreData


extension FullRes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FullRes> {
        return NSFetchRequest<FullRes>(entityName: "FullRes")
    }

    @NSManaged public var imageData: NSData?
    @NSManaged public var thumbnail: Thumbnail?

}
