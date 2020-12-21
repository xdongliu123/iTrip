//
//  Date+Extension.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/15.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import Foundation

extension Date {
    func formatString(format: String="yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func diff(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        return end - start
    }
}
