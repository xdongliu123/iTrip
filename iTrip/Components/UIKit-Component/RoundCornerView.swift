//
//  RoundCornerView.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/2.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import UIKit
import Foundation

class RoundCornerView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundCorners([.topLeft, .topRight], radius: 10)
    }
}
