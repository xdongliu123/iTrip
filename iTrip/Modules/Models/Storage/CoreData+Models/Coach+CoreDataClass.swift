//
//  Coach+CoreDataClass.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/10.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Coach)
public class Coach: Traffic {

}

extension Coach {
    func syncData(from vs: CoachViewState) {
        super.syncData(from: vs.parent)
        company = vs.company
        confirmation = vs.confirmation
        entrance = vs.entrance
        coachbrand = vs.coachbrand
    }
    
    override func trafficName() -> String {
        return "Coach"
    }
}
