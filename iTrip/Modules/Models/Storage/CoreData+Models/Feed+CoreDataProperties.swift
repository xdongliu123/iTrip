//
//  Feed+CoreDataProperties.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/11/12.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//
//

import Foundation
import CoreData


extension Feed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Feed> {
        return NSFetchRequest<Feed>(entityName: "Feed")
    }

    @NSManaged public var address: TripAddress?
    @NSManaged public var content: String?
    @NSManaged public var testPhoto: String?
    @NSManaged public var posterAvatar: String?
    @NSManaged public var id: String?
    @NSManaged public var poster: String?
    @NSManaged public var postDate: Date?
    @NSManaged public var owner: TripNode?
    @NSManaged public var photos: NSSet?

}

// MARK: Generated accessors for photos
extension Feed {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: FeedPhoto)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: FeedPhoto)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}

extension Feed : Identifiable {

}
