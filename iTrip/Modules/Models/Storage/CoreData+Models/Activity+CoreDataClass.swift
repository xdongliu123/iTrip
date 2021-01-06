//
//  Activity+CoreDataClass.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/11.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Activity)
public class Activity: TripNode {

}

extension Activity {
    func syncData(from vs: ActivityViewState) {
        super.syncData(from: vs.parent)
        self.startDate = vs.startDate
        self.endDate = vs.endDate
        if vs.address.location.count > 0 {
            address = TripAddress()
            address?.syncData(from: vs.address)
        }
    }
    
    func activityName() -> String {
        let activityType = TripNodeType.init(rawValue: Int(type))
        switch activityType {
        case .bookstore:
            return "BookStore"
        case .museum:
            return "Museum"
        case .library:
            return "Library"
        case .theatre:
            return "Theatre"
        case .concert:
            return "Concert"
        case .park:
            return "Park"
        case .lodging:
            return "Lodging"
        case .mall:
            return "Mall"
        case .restaurant:
            return "Restaurant"
        default:
            return ""
        }
    }
    
    var realTimeState: TripNodeState {
        let now = Date()
        if now.distance(to: startDate!) > 0 {
            return .notStarted
        } else if now.distance(to: startDate!) < 0 && now.distance(to: endDate!) > 0 {
            return .inProgress
        } else if now.distance(to: endDate!) < 0 {
            return .Completed
        } else {
            fatalError("weird thing")
        }
    }
}
