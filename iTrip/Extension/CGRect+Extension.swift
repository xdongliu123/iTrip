//
//  CGRect+Extension.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/23.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI

extension CGRect {
    var center: CGPoint {
        return CGPoint.init(x: origin.x + size.width / 2, y: origin.y + size.height / 2)
    }
}
