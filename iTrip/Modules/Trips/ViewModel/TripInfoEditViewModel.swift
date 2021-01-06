//
//  TripInfoEditViewModel.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/12.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI
import Combine

class TripBasicInfoEditViewModel: ObservableObject {
    var data: Trip?
    @Published var showPopupView = false
    @Published var popUpTip = ""
    
    init(_ model: Trip?) {
        data = model
    }
    
    func validName(_ name: String) -> Bool {
        return name.count > 5
    }
    
    func validDestination(_ dest: String) -> Bool {
        return dest.count > 2
    }
    
    func save(tripItem: [String: Any]) -> Bool {
        guard let name = tripItem["name"] as? String, name.count > 2 else {
            showPopupView = true
            popUpTip = "Name length must be greater than 2"
            return false
        }
        guard let dest = tripItem["destination"] as? String, dest.count > 2 else {
            showPopupView = true
            popUpTip = "Destination length must be greater than 2"
            return false
        }
        guard let startDate = tripItem["startDate"] as? Date else {
            showPopupView = true
            popUpTip = "Start Date must be set"
            return false
        }
        guard let endDate = tripItem["endDate"] as? Date else {
            showPopupView = true
            popUpTip = "End Date must be set"
            return false
        }
        guard startDate.distance(to: endDate) >= 0 else {
            showPopupView = true
            popUpTip = "End Date must be later than Start Date"
            return false
        }
        if data == nil {
            data = StrorageHelper.createEntity()
            data?.id = UUID().uuidString
        }
        data?.updateModel(with: tripItem)
        return true
    }
}
