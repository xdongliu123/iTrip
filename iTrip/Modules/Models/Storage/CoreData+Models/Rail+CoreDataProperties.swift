//
//  Rail+CoreDataProperties.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/9.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//
//

import Foundation
import CoreData


extension Rail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rail> {
        return NSFetchRequest<Rail>(entityName: "Rail")
    }

    @NSManaged public var train_number: String?
    @NSManaged public var coach: String?
    @NSManaged public var seat_class: String?
    @NSManaged public var seat_number: String?
    @NSManaged public var carrier: String?
    @NSManaged public var confirmation: String?

}
