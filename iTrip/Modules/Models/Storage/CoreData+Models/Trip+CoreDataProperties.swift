//
//  Trip+CoreDataProperties.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/9.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var cover: Data?
    @NSManaged public var desc: String?
    @NSManaged public var destination: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var synch: Bool
    @NSManaged public var nodes: NSSet?

}

// MARK: Generated accessors for nodes
extension Trip {

    @objc(addNodesObject:)
    @NSManaged public func addToNodes(_ value: TripNode)

    @objc(removeNodesObject:)
    @NSManaged public func removeFromNodes(_ value: TripNode)

    @objc(addNodes:)
    @NSManaged public func addToNodes(_ values: NSSet)

    @objc(removeNodes:)
    @NSManaged public func removeFromNodes(_ values: NSSet)

}
