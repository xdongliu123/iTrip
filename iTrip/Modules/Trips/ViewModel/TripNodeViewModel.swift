//
//  TripNodeViewModel.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/27.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import Combine
import Foundation

class TripNodeViewModel: ObservableObject {
    static let advancedWarnMinuteNum: Double = 10
    var isEdit: Bool
    var data: TripNode
    var owner: Trip?
    let publisher = PassthroughSubject<Bool, Never>()
    var nodeChangePublisher: AnyPublisher<Bool, Never> {
        return publisher.eraseToAnyPublisher()
    }
    
    init(_ _data: TripNode, _ _isEdit: Bool) {
        data = _data
        isEdit = _isEdit
    }
    
    func deleteNode() -> Future<Void, Never> {
        Future<Void, Never>.init { (promise) in
            // delete feed local photos
            if let feeds = self.data.feeds as? Set<Feed> {
                for feed in feeds {
                    if let photos = feed.photos as? Set<FeedPhoto> {
                        for photo in photos {
                            if photo.localFileName != nil {
                                ImageController.shared.deleteImage(imageName: photo.localFileName!)
                            }
                        }
                    }
                }
            }
            self.deleteLocalPushs()
            StrorageHelper.delete(model: self.data)
            self.publisher.send(true)
            promise(.success(Void()))
        }
    }
    
    func save() {
        // new node
        if !self.isEdit {
            self.data.id = UUID().uuidString
        }
        self.configureLocalPush()
        if !self.isEdit {
            owner?.addToNodes(self.data)
        }
        StrorageHelper.save()
        self.publisher.send(self.isEdit)
    }
    
    func configureLocalPush() {
        deleteLocalPushs()
        if let startDate = data.startDate() {
            data.startTipPushId = LocalNotificationManager.registerLocalNotification(title: data.localPushTitle(), body: data.localPushBody(), dateTime: startDate - TripNodeViewModel.advancedWarnMinuteNum * 60, nodeId: data.id!)
        }
        if let endDate = data.endDate() {
            data.endTipPushId = LocalNotificationManager.registerLocalNotification(title: data.localPushTitle(false), body: data.localPushBody(false), dateTime: endDate - TripNodeViewModel.advancedWarnMinuteNum * 60, nodeId: data.id!)
        }
    }
    
    func deleteLocalPushs() {
        let pushIds = [data.startTipPushId, data.endTipPushId]
        LocalNotificationManager.removeLocalPendingNotifications(ids: pushIds.compactMap { $0 })
    }
}

protocol GenerateConcreteNodeViewState {
    func viewState() -> ConcreteNodeViewState
}

class ActivityViewModel: TripNodeViewModel, GenerateConcreteNodeViewState {
    var type: TripNodeType
    init(_ _data: Activity?, _ _type: TripNodeType) {
        var tmp: Activity? = nil
        if _data == nil {
            tmp = StrorageHelper.createEntity()
        } else {
            tmp = _data
        }
        type = _type
        super.init(tmp!, _data != nil)
    }
    
    var title: String {
        switch type {
        case .lodging:
            return "Lodging"
        case .mall:
            return "Mall"
        case .restaurant:
            return "Restaurant"
        case .park:
            return "Park"
        case .concert:
            return "Concert"
        case .theatre:
            return "Theatre"
        case .library:
            return "Library"
        case .bookstore:
            return "Bookstore"
        case .museum:
            return "Museum"
        default:
            return "Other"
        }
    }
    
    func viewState() -> ConcreteNodeViewState {
        return ActivityViewState(data as! Activity)
    }
    
    func save(_ vs: ActivityViewState) -> Future<Void, FormEditError> {
        let error = vs.integrityCheck()
        return Future<Void, FormEditError>.init { (promise) in
            if (error != nil) {
                promise(.failure(error!))
            } else {
                (self.data as! Activity).syncData(from: vs)
                self.data.type = Int16(self.type.rawValue)
                self.save()
                promise(.success(Void()))
            }
        }
    }
}

class TrafficViewModel: TripNodeViewModel {
    var editDepart = true
}

class FlightViewModel: TrafficViewModel, GenerateConcreteNodeViewState {
    init(_ _data: Flight?) {
        var tmp: Flight? = nil
        if _data == nil {
            tmp = StrorageHelper.createEntity()
            tmp?.type = Int16(TripNodeType.flight.rawValue)
        } else {
            tmp = _data
        }
        super.init(tmp!, _data != nil)
    }
    
    func viewState() -> ConcreteNodeViewState {
        return FlightViewState(data as! Flight)
    }
    
    func save(_ vs: FlightViewState) -> Future<Void, FormEditError> {
        let error = vs.integrityCheck()
        return Future<Void, FormEditError>.init { (promise) in
            if (error != nil) {
                promise(.failure(error!))
            } else {
                (self.data as! Flight).syncData(from: vs)
                self.save()
                promise(.success(Void()))
            }
        }
    }
}

class RailViewModel: TrafficViewModel, GenerateConcreteNodeViewState {
    init(_ _data: Rail?) {
        var tmp: Rail? = nil
        if _data == nil {
            tmp = StrorageHelper.createEntity()
            tmp?.type = Int16(TripNodeType.rail.rawValue)
        } else {
            tmp = _data
        }
        super.init(tmp!, _data != nil)
    }
    
    func viewState() -> ConcreteNodeViewState {
        return RailViewState(data as! Rail)
    }
    
    func save(_ vs: RailViewState) -> Future<Void, FormEditError> {
        let error = vs.integrityCheck()
        return Future<Void, FormEditError>.init { (promise) in
            if (error != nil) {
               promise(.failure(error!))
            } else {
                (self.data as! Rail).syncData(from: vs)
                self.save()
                promise(.success(Void()))
            }
        }
    }
}

class CruiseViewModel: TrafficViewModel, GenerateConcreteNodeViewState {
    init(_ _data: Cruise?) {
        var tmp: Cruise? = nil
        if _data == nil {
            tmp = StrorageHelper.createEntity()
            tmp?.type = Int16(TripNodeType.cruise.rawValue)
        } else {
            tmp = _data
        }
        super.init(tmp!, _data != nil)
    }
    
    func viewState() -> ConcreteNodeViewState {
        return CruiseViewState(data as! Cruise)
    }
    
    func save(_ vs: CruiseViewState) -> Future<Void, FormEditError> {
        let error = vs.integrityCheck()
        return Future<Void, FormEditError>.init { (promise) in
            if (error != nil) {
                promise(.failure(error!))
            } else {
                (self.data as! Cruise).syncData(from: vs)
                self.save()
                promise(.success(Void()))
            }
        }
    }
}

class CoachViewModel: TrafficViewModel, GenerateConcreteNodeViewState {
    init(_ _data: Coach?) {
        var tmp: Coach? = nil
        if _data == nil {
            tmp = StrorageHelper.createEntity()
            tmp?.type = Int16(TripNodeType.coach.rawValue)
        } else {
            tmp = _data
        }
        super.init(tmp!, _data != nil)
    }
    
    func viewState() -> ConcreteNodeViewState {
        return CoachViewState(data as! Coach)
    }
    
    func save(_ vs: CoachViewState) -> Future<Void, FormEditError> {
        let error = vs.integrityCheck()
        return Future<Void, FormEditError>.init { (promise) in
            if (error != nil) {
                promise(.failure(error!))
            } else {
                (self.data as! Coach).syncData(from: vs)
                self.save()
                promise(.success(Void()))
            }
        }
    }
}

