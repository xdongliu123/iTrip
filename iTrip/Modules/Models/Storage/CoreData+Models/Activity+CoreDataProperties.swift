//
//  Activity+CoreDataProperties.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/11.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var address: TripAddress?
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?

}
