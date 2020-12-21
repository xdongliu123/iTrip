//
//  RoundCornerBorderModifier.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/10.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI

struct RoundCornerBorderModifier: ViewModifier {
    let padding: EdgeInsets
    func body(content: Content) -> some View {
        content.padding(padding).overlay(
          RoundedRectangle(cornerRadius: 4).stroke(lineWidth: 1).foregroundColor(.blue))
    }
}

extension View {
    func roundCornerBordered(_ padding: EdgeInsets=EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)) -> some View {
        ModifiedContent(content: self, modifier: RoundCornerBorderModifier(padding: padding))
    }
}
