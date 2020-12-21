//
//  FeedPhoto+CoreDataProperties.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/11/13.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//
//

import Foundation
import CoreData


extension FeedPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedPhoto> {
        return NSFetchRequest<FeedPhoto>(entityName: "FeedPhoto")
    }

    @NSManaged public var localFileName: String?
    @NSManaged public var remoteUrl: String?
    @NSManaged public var owner: Feed?

}

extension FeedPhoto : Identifiable {

}
