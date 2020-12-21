//
//  Rail+CoreDataClass.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/9.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Rail)
public class Rail: Traffic {

}

extension Rail {
    func syncData(from vs: RailViewState) {
        super.syncData(from: vs.parent)
        coach = vs.coach
        train_number = vs.train_number
        seat_number = vs.seat_number
        seat_class = vs.seat_class
        carrier = vs.carrier
        confirmation = vs.confirmation
    }
    
    override func trafficName() -> String {
        return "Rail"
    }
}

