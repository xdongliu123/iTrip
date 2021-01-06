//
//  TripNodeViewState.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/8.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import Foundation
import CoreLocation

struct TripAddressState {
    var location: String
    var name: String
    var description: String
    
    static func defaultState() -> TripAddressState {
        return TripAddressState(location: "", name: "", description: "")
    }
    
    static func buildViewState(from address: TripAddress) -> TripAddressState {
        return TripAddressState(location: "\(address.lat),\(address.lon)",
                                name: address.name!,
                                description: address.desc ?? "")
    }
}

protocol ConcreteNodeViewState {
     
}

struct TripNodeViewState: ConcreteNodeViewState {
    var id = ""
    var note = ""
    var contact = ""
    var phone = ""
    var order = 0
    var type = TripNodeType.flight
    var state = TripNodeState.notStarted
    
    init(_ node: TripNode) {
        id = node.id ?? ""
        note = node.note ?? ""
        contact = node.contact ?? ""
        phone = node.phone ?? ""
        order = Int(node.order)
        type = TripNodeType(rawValue: Int(node.type)) ?? TripNodeType.flight
        state = TripNodeState(rawValue: Int(node.state)) ?? TripNodeState.notStarted
    }
    
    init() {
        
    }
}

struct ActivityViewState: ConcreteNodeViewState {
    var parent: TripNodeViewState
    var address = TripAddressState.defaultState()
    var startDate = Date()
    var endDate = Date()
    
    init(_ activity: Activity) {
        parent = TripNodeViewState(activity)
        address = TripAddressState.defaultState()
        if let address_ = activity.address {
            address = TripAddressState.buildViewState(from: address_)
        }
        startDate = activity.startDate ?? Date()
        endDate = activity.endDate ?? Date()
    }
    
    init() {
        parent = TripNodeViewState()
    }
    
    func integrityCheck() -> FormEditError? {
        if address.location.count == 0 {
            return FormEditError(_description: "Address not set")
        }
        if startDate.distance(to: endDate) <= 0 {
            return FormEditError(_description: "Start time must be earlier than end time")
        }
        return nil
    }
}

struct TrafficViewState {
    var parent: TripNodeViewState
    var startAddress = TripAddressState.defaultState()
    var endAddress = TripAddressState.defaultState()
    var startDate = Date()
    var endDate = Date()
    
    init(_ traffic: Traffic) {
        parent = TripNodeViewState(traffic)
        startAddress = TripAddressState.defaultState()
        if let start = traffic.startAddress {
            startAddress = TripAddressState.buildViewState(from: start)
        }
        endAddress = TripAddressState.defaultState()
        if let end = traffic.endAddress {
            endAddress = TripAddressState.buildViewState(from: end)
        }
        startDate = traffic.startDate ?? Date()
        endDate = traffic.endDate ?? Date()
    }
    
    init() {
        parent = TripNodeViewState()
    }
    
    func integrityCheck() -> FormEditError? {
        if startAddress.location.count == 0 {
            return FormEditError(_description: "Depart address not set")
        }
        if !startAddress.location.isValidCooridnate() {
            return FormEditError(_description: "Depart address not valid")
        }
        if endAddress.location.count == 0 {
            return FormEditError(_description: "Arriving address not set")
        }
        if !endAddress.location.isValidCooridnate() {
            return FormEditError(_description: "Arriving address not valid")
        }
        if startDate.distance(to: endDate) <= 0 {
            return FormEditError(_description: "Arriving date must be earlier than depart date")
        }
        return nil
    }
}

struct FlightViewState: ConcreteNodeViewState {
    var parent: TrafficViewState
    var aircraft = ""
    var airline = ""
    var flightNo = ""
    var seat = ""
    var arriving_gate = ""
    var arriving_terminal = ""
    var depart_gate = ""
    var depart_terminal = ""
    var baggage_claim = ""
    var confirmation = ""
    
    init(_ flight: Flight) {
        parent = TrafficViewState(flight)
        aircraft = flight.aircraft ?? ""
        airline = flight.airline ?? ""
        flightNo = flight.flightNo ?? ""
        seat = flight.seat ?? ""
        arriving_gate = flight.arriving_gate ?? ""
        arriving_terminal = flight.arriving_terminal ?? ""
        depart_gate = flight.depart_gate ?? ""
        depart_terminal = flight.depart_terminal ?? ""
        baggage_claim = flight.baggage_claim ?? ""
        confirmation = flight.confirmation ?? ""
    }
    
    init() {
        parent = TrafficViewState()
    }
    
    func integrityCheck() -> FormEditError? {
        if let error = parent.integrityCheck() {
            return error
        }
        return nil
    }
}

struct RailViewState: ConcreteNodeViewState {
    var parent: TrafficViewState
    var train_number = ""
    var coach = ""
    var seat_class = ""
    var seat_number = ""
    var carrier = ""
    var confirmation = ""
    
    init(_ rail: Rail) {
        parent = TrafficViewState(rail)
        coach = rail.coach ?? ""
        train_number = rail.train_number ?? ""
        seat_number = rail.seat_number ?? ""
        seat_class = rail.seat_class ?? ""
        carrier = rail.carrier ?? ""
        confirmation = rail.confirmation ?? ""
    }
    
    init() {
        parent = TrafficViewState()
    }
    
    func integrityCheck() -> FormEditError? {
        if let error = parent.integrityCheck() {
            return error
        }
        return nil
    }
}

struct CruiseViewState: ConcreteNodeViewState {
    var parent: TrafficViewState
    var carbin = ""
    var carbinType = ""
    var company = ""
    var cruiseLine = ""
    var shipName = ""
    var confirmation = ""
    
    init(_ cruise: Cruise) {
        parent = TrafficViewState(cruise)
        carbin = cruise.carbin ?? ""
        carbinType = cruise.carbinType ?? ""
        company = cruise.company ?? ""
        cruiseLine = cruise.cruiseLine ?? ""
        shipName = cruise.shipName ?? ""
        confirmation = cruise.confirmation ?? ""
    }
    
    init() {
        parent = TrafficViewState()
    }
    
    func integrityCheck() -> FormEditError? {
        if let error = parent.integrityCheck() {
            return error
        }
        return nil
    }
}

struct CoachViewState: ConcreteNodeViewState {
    var parent: TrafficViewState
    var confirmation = ""
    var coachbrand = ""
    var entrance = ""
    var company = ""
    
    init(_ coach: Coach) {
        parent = TrafficViewState(coach)
        confirmation = coach.confirmation ?? ""
        coachbrand = coach.coachbrand ?? ""
        entrance = coach.entrance ?? ""
        company = coach.company ?? ""
    }
    
    init() {
        parent = TrafficViewState()
    }
    
    func integrityCheck() -> FormEditError? {
        if let error = parent.integrityCheck() {
            return error
        }
        return nil
    }
}
