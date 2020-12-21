//
//  TripNode+CoreDataClass.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/26.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//
//

import Foundation
import CoreData

@objc(TripNode)
public class TripNode: NSManagedObject {

}

extension TripNode {
    func syncData(from vs: TripNodeViewState) {
        self.order = Int16(vs.order)
        self.note = vs.note
        self.contact = vs.contact
        self.phone = vs.phone
        self.type = Int16(vs.type.rawValue)
        self.state = Int16(vs.state.rawValue)
    }
}

