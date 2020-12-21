//
//  Number+Extension.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/17.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import Foundation

extension TimeInterval {
    func formatDuration() -> String {
        var reminder = self > 0 ? self : -1 * self
        reminder = reminder / 60
        var day = 0.0
        var hour = 0.0
        var minute = 0.0
        if (reminder > 1440) {
            day = floor(reminder / 1440)
        }
        reminder = reminder - day * 1440
        if (reminder > 60) {
            hour = floor(reminder / 60)
        }
        minute = reminder - hour * 60
        var result = ""
        if day > 0 {
            result += "\(Int(day)) day(s)"
        }
        if hour > 0 {
            result += " \(Int(hour)) hour(s)"
        }
        if minute > 0 {
            result += " \(Int(minute)) min(s)"
        }
        return result
    }
}
