//
//  Coach+CoreDataProperties.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/10.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//
//

import Foundation
import CoreData


extension Coach {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Coach> {
        return NSFetchRequest<Coach>(entityName: "Coach")
    }

    @NSManaged public var company: String?
    @NSManaged public var confirmation: String?
    @NSManaged public var coachbrand: String?
    @NSManaged public var entrance: String?

}
