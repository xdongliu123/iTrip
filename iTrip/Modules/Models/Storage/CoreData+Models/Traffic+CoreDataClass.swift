//
//  Traffic+CoreDataClass.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/26.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Traffic)
public class Traffic: TripNode {

}

extension Traffic {
    func syncData(from vs: TrafficViewState) {
        super.syncData(from: vs.parent)
        self.startDate = vs.startDate
        self.endDate = vs.endDate
        if vs.startAddress.location != nil {
            startAddress = TripAddress()
            startAddress?.syncData(from: vs.startAddress)
        }
        if vs.endAddress.location != nil {
            endAddress = TripAddress()
            endAddress?.syncData(from: vs.endAddress)
        }
    }
    
    @objc func trafficName() -> String {
        return "Traffic"
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
