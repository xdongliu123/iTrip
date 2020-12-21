//
//  TripNode+CoreDataProperties.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/9.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//
//

import Foundation
import CoreData


extension TripNode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TripNode> {
        return NSFetchRequest<TripNode>(entityName: "TripNode")
    }

    @NSManaged public var id: String?
    @NSManaged public var note: String?
    @NSManaged public var contact: String?
    @NSManaged public var phone: String?
    @NSManaged public var order: Int16
    @NSManaged public var type: Int16
    @NSManaged public var state: Int16
    @NSManaged public var feeds: NSSet?
    @NSManaged public var owner: Trip?

}

// MARK: Generated accessors for feeds
extension TripNode {

    @objc(addFeedsObject:)
    @NSManaged public func addToFeeds(_ value: Feed)

    @objc(removeFeedsObject:)
    @NSManaged public func removeFromFeeds(_ value: Feed)

    @objc(addFeeds:)
    @NSManaged public func addToFeeds(_ values: NSSet)

    @objc(removeFeeds:)
    @NSManaged public func removeFromFeeds(_ values: NSSet)

}
