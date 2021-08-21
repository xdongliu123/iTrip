//
//  LoginCardViewModifier.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/6/24.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI

struct AuthCardViewModifier: ViewModifier {
    var keyboardShown: Bool
    var hideMode: Bool
    var zIndex: Double
    
    func body(content: Content) -> some View {
        content.background(Color(.white))
        .mask(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 5, x:0, y: 20)
        .padding(.horizontal)
        .zIndex(zIndex)
        .offset(x: 0, y: keyboardShown ? (hideMode ? -100 : -100) : (hideMode ? 50 : 0))
        .opacity(hideMode ? 0.5 : 1.0)
        .scaleEffect(x: hideMode ? 0.6 : 1.0, y: hideMode ? 0.6 : 1.0)
        .animation(Animation.spring(response: 0.55, dampingFraction: 0.45, blendDuration: 0))
    }
}

extension View {
    func authCardStyle(keyboardShown: Bool, hideMode: Bool) -> some View {
        ModifiedContent(content: self, modifier: AuthCardViewModifier(keyboardShown: keyboardShown, hideMode: hideMode, zIndex: hideMode ? 2 : 3))
    }
}
