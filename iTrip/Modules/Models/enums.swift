//
//  enums.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/27.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import Foundation

enum TripNodeType: Int {
    // traffic
    case flight
    case rail
    case cruise
    case coach
    // activity
    case lodging
    case mall
    case restaurant
    case park
    case concert
    case theatre
    case library
    case bookstore
    case museum
    case other_activity
}

enum TripNodeState: Int {
    case notStarted
    case inProgress
    case Completed
}
