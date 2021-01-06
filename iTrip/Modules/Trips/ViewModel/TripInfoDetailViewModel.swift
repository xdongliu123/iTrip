//
//  TripInfoDetailViewModel.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/16.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI
import Combine
import StepperView

class TripNodeListItemViewModel: ObservableObject, Identifiable, Comparable {
    let id = UUID()
    let data: TripNode
    var timerHandle: Cancellable?
    init(_ node: TripNode) {
        data = node
        updateProgressColor()
    }
    
    var title: String {
        if let traffic = data as? Traffic {
            return "\(traffic.startAddress?.name ?? "") - \(traffic.endAddress?.name ?? "")"
        } else if let activity = data as? Activity {
             return "[\(activity.activityName())]\(activity.address?.name ?? "")"
        } else {
            return ""
        }
    }
    
    @Published var progressColor: Color = Color.init(rgb: 0xC7D7DC)
    
    var icon: Image {
        let type = TripNodeType.init(rawValue: Int(data.type))
        if type == TripNodeType.flight {
            return Image("flight-icon")
        } else if type == TripNodeType.rail {
            return Image("train-icon")
        } else if type == TripNodeType.cruise {
            return Image("cruise-icon")
        } else if type == TripNodeType.coach {
            return Image("coach-icon")
        } else if type == TripNodeType.lodging {
            return Image("lodging-icon")
        } else if type == TripNodeType.mall {
            return Image("mall-icon")
        } else if type == TripNodeType.restaurant {
            return Image("restaurant-icon")
        } else if type == TripNodeType.park {
            return Image("park-icon")
        } else if type == TripNodeType.concert {
            return Image("concert-icon")
        } else if type == TripNodeType.theatre {
            return Image("theatre-icon")
        } else if type == TripNodeType.library {
            return Image("library-icon")
        } else if type == TripNodeType.bookstore {
            return Image("bookstore-icon")
        } else if type == TripNodeType.museum {
            return Image("museum-icon")
        } else {
            return Image("meeting-icon")
        }
    }
    
    var startDate: Date {
        if let traffic = data as? Traffic {
            return traffic.startDate ?? Date()
        } else if let activity = data as? Activity {
            return activity.startDate ?? Date()
        } else {
            return Date()
        }
    }
    
    func updateProgressColor() {
        let state: TripNodeState
        if let traffic = data as? Traffic {
            state = traffic.realTimeState
        } else if let activity = data as? Activity {
            state = activity.realTimeState
        } else {
            fatalError("")
        }
        if state == .notStarted {
            progressColor = Color.init(rgb: 0xC7D7DC)
        } else if state == .inProgress {
            progressColor = Color.init(rgb: 0xF59331)
        } else if state == .Completed {
            progressColor = Color.init(rgb: 0x20824D)
        }
    }
    
    static func < (lhs: TripNodeListItemViewModel, rhs: TripNodeListItemViewModel) -> Bool {
        return lhs.startDate < rhs.startDate
    }
    
    static func == (lhs: TripNodeListItemViewModel, rhs: TripNodeListItemViewModel) -> Bool {
        return lhs.startDate == rhs.startDate
    }
}

class TripNodeGroup: Identifiable {
    let id = UUID()
    let key: String
    let nodes: [TripNodeListItemViewModel]
    
    init(_ key_: String, _ nodes_: [TripNodeListItemViewModel]) {
        key = key_
        nodes = nodes_
    }
}

class TripNodesIndexViewModel: ObservableObject {
    let queue = DispatchQueue.main
    let data: Trip
    var nodes: [TripNodeListItemViewModel] = []
    @Published var groups: [TripNodeGroup] = []
    
    let editingFlightVM = FlightViewModel(nil)
    let editingRailVM = RailViewModel(nil)
    let editingCruiseVM = CruiseViewModel(nil)
    let editingCoachVM = CoachViewModel(nil)
    let editingActivityVM = ActivityViewModel(nil, TripNodeType.other_activity)
    
    let addNodeVM = TripAddNodesViewModel()
    var timerHandle: Cancellable?
    
    init(trip: Trip) {
        data = trip
        refreshNodes()
    }
    
    func startProgressTimer() {
        timerHandle = queue.schedule( after: queue.now,
        interval: .seconds(5)
        ){
            self.refreshProgressColor()
        }
    }
    
    func refreshProgressColor() {
        nodes.forEach { (node) in
            node.updateProgressColor()
        }
    }
    
    func refreshNodes() {
        if let _nodes = data.nodes as? Set<TripNode> {
            nodes = _nodes.map { (node) -> TripNodeListItemViewModel in
                TripNodeListItemViewModel(node)
            }
        }
        let dates = nodes.map { (vm) -> String in
            return vm.startDate.formatString()
        }
        let keys = Array(Set(dates)).sorted()
        groups = []
        for key in keys {
            groups.append(TripNodeGroup(key, groupNodes(key).sorted()))
        }
    }
    
    var name: String {
        return data.name ?? ""
    }
    
    var destination: String {
        return data.destination ?? ""
    }
    
    var startDate: Date? {
        return data.startDate
    }
    
    var endDate: Date? {
        return data.endDate
    }
    
    func groupNodes(_ key: String) -> [TripNodeListItemViewModel] {
        self.nodes.filter { (node) -> Bool in
            return node.startDate.formatString() == key
        }
    }
    
    func deleteTrip() -> Future<Void, Never> {
        Future<Void, Never>.init { (promise) in
            StrorageHelper.delete(model: self.data)
            promise(.success(Void()))
        }
    }
}
