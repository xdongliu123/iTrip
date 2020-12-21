//
//  BorderedViewModifier.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/1/1.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI

struct BorderedViewModifier: ViewModifier {
    let foregroundColor: Color
    func body(content: Content) -> some View {
        content.padding(EdgeInsets(top: 6, leading: 5, bottom: 6, trailing: 5)).background(Color.white).overlay(
          RoundedRectangle(cornerRadius: 4).stroke(lineWidth: 1).foregroundColor(foregroundColor))
    .shadow(color: Color.gray.opacity(0.4), radius: 3, x: 1, y: 2)
    }
}

extension View {
    func bordered(foregroundColor: Color = .blue) -> some View {
        ModifiedContent(content: self, modifier: BorderedViewModifier(foregroundColor: foregroundColor))
    }
}
