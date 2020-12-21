//
//  String+Utility.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/6/27.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import Foundation
import CoreLocation

extension String {
    func isValMobile() -> Bool {
        let mobileRegex = "^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$"
        let mobileTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", mobileRegex)
        return mobileTest.evaluate(with: self)
    }
    
    func isValEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    
    func convert2Location() -> CLLocationCoordinate2D? {
        guard self.contains(",") else {
            return nil
        }
        let elements = self.components(separatedBy: ",")
        guard elements.count == 2 else {
            return nil
        }
        guard let lat = Double(elements[0]), let lon = Double(elements[1]) else {
            return nil
        }
        guard lat >= -90.0 && lat <= 90 else {
            return nil
        }
        guard lon >= -180.0 && lon <= 180 else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    func isValidCooridnate() -> Bool {
        guard self.contains(",") else {
            return false
        }
        let elements = self.components(separatedBy: ",")
        guard elements.count == 2 else {
            return false
        }
        guard let lat = Double(elements[0]), let lon = Double(elements[1]) else {
            return false
        }
        guard lat >= -90.0 && lat <= 90 else {
            return false
        }
        guard lon >= -180.0 && lon <= 180 else {
            return false
        }
        return true
    }
}
