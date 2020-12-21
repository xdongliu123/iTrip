//
//  Color+Extension.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/11.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI
import UIKit

extension Color {
    init(rgb: Int) {
        self.init(red: Double((rgb >> 16) & 0xFF) / 255,
             green: Double((rgb >> 8) & 0xFF) / 255,
             blue: Double(rgb & 0xFF) / 255
        )
    }
}

extension UIColor {
    static func colorWith(rgb: Int) -> UIColor {
        return UIColor.init(red: CGFloat(Double((rgb >> 16) & 0xFF) / 255),
                            green: CGFloat(Double((rgb >> 8) & 0xFF) / 255),
                            blue: CGFloat(Double(rgb & 0xFF) / 255), alpha: 1.0)
    }
    
    static func random() -> UIColor {
        return UIColor(
           red: CGFloat(arc4random()) / CGFloat(UInt32.max),
           green: CGFloat(arc4random()) / CGFloat(UInt32.max),
           blue: CGFloat(arc4random()) / CGFloat(UInt32.max),
           alpha: 1.0
        )
    }
}
