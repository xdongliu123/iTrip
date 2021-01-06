//
//  TripNode+CoreDataClass.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/26.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//
//

import Foundation
import CoreData

@objc(TripNode)
public class TripNode: NSManagedObject {

}

extension TripNode {
    func syncData(from vs: TripNodeViewState) {
        self.order = Int16(vs.order)
        self.note = vs.note
        self.contact = vs.contact
        self.phone = vs.phone
        self.type = Int16(vs.type.rawValue)
        self.state = Int16(vs.state.rawValue)
    }
    
    func localPushTitle(_ isStart: Bool=true) -> String {
        return "Tips"
    }
    
    func localPushBody(_ isStart: Bool=true) -> String {
        if let activity = self as? Activity {
            return "\(activity.activityName()) at \(activity.address?.name ?? "") will \(isStart ? "start" : "end") in 10 minutes."
        } else if let traffic = self as? Traffic {
            return "\(traffic.trafficName()) from \(traffic.startAddress?.name ?? "") to \(traffic.endAddress?.name ?? "") will \(isStart ? "depart" : "arrive") in 10 minutes."
        } else {
            return ""
        }
    }
    
    func startDate() -> Date? {
        if let activity = self as? Activity {
            return activity.startDate
        } else if let traffic = self as? Traffic {
            return traffic.startDate
        } else {
            return nil
        }
    }
    
    func endDate() -> Date? {
        if let activity = self as? Activity {
            return activity.endDate
        } else if let traffic = self as? Traffic {
            return traffic.endDate
        } else {
            return nil
        }
    }
}

