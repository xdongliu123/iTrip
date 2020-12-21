//
//  Double+Extension.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/12/20.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
