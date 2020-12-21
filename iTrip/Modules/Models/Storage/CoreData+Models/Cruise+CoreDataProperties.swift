//
//  Cruise+CoreDataProperties.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/9.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//
//

import Foundation
import CoreData


extension Cruise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cruise> {
        return NSFetchRequest<Cruise>(entityName: "Cruise")
    }

    @NSManaged public var shipName: String?
    @NSManaged public var cruiseLine: String?
    @NSManaged public var confirmation: String?
    @NSManaged public var carbinType: String?
    @NSManaged public var carbin: String?
    @NSManaged public var company: String?

}
