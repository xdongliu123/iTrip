//
//  Traffic+CoreDataProperties.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/26.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//
//

import Foundation
import CoreData


extension Traffic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Traffic> {
        return NSFetchRequest<Traffic>(entityName: "Traffic")
    }

    @NSManaged public var startAddress: TripAddress?
    @NSManaged public var endAddress: TripAddress?
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
}
