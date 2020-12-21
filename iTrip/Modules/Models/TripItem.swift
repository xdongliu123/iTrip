//
//  TripItem.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/10.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import Foundation

class TripItem {
    var name: String
    var destination: String
    var startDate: Date
    var endDate: Date
    var description: String
    
    init(_name: String, _description: String, _destination: String, _startDate: Date, _endDate: Date) {
        name = _name
        description = _description
        destination = _destination
        startDate = _startDate
        endDate = _endDate
    }
}

extension TripItem: Identifiable {
    
}
