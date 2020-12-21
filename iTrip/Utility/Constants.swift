//
//  Constants.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/8.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI

let FieldOffset: CGFloat = 20.0
let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let grayMaskGadient = LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.3), Color.gray.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
let colorMaskGadient = LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.green.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing)
let gray2WhiteMaskGadient = LinearGradient(gradient: Gradient(colors: [Color(rgb: 0xC1C7C7), Color.white.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomLeading)

