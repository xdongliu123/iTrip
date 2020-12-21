//
//  Flight+CoreDataProperties.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/4.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//
//

import Foundation
import CoreData


extension Flight {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Flight> {
        return NSFetchRequest<Flight>(entityName: "Flight")
    }

    @NSManaged public var airline: String?
    @NSManaged public var flightNo: String?
    @NSManaged public var confirmation: String?
    @NSManaged public var seat: String?
    @NSManaged public var depart_terminal: String?
    @NSManaged public var depart_gate: String?
    @NSManaged public var arriving_terminal: String?
    @NSManaged public var arriving_gate: String?
    @NSManaged public var baggage_claim: String?
    @NSManaged public var aircraft: String?

}
