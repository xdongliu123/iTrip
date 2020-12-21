//
//  Cruise+CoreDataClass.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/9.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Cruise)
public class Cruise: Traffic {

}

extension Cruise {
    func syncData(from vs: CruiseViewState) {
        super.syncData(from: vs.parent)
        carbin = vs.carbin
        carbinType = vs.carbinType
        company = vs.company
        cruiseLine = vs.cruiseLine
        shipName = vs.shipName
        confirmation = vs.confirmation
    }
    
    override func trafficName() -> String {
        return "Cruise"
    }
}
