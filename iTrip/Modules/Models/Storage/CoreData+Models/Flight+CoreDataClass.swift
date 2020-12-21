//
//  Flight+CoreDataClass.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/4.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Flight)
public class Flight: Traffic {

}

extension Flight {
    func syncData(from vs: FlightViewState) {
        super.syncData(from: vs.parent)
        self.aircraft = vs.aircraft
        self.airline = vs.airline
        self.arriving_gate = vs.arriving_gate
        self.arriving_terminal = vs.arriving_terminal
        self.baggage_claim = vs.baggage_claim
        self.confirmation = vs.confirmation
        self.depart_gate = vs.depart_gate
        self.depart_terminal = vs.depart_terminal
        self.flightNo = vs.flightNo
        self.seat = vs.seat
    }
    
    override func trafficName() -> String {
        return "Flight"
    }
}
