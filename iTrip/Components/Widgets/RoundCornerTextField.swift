//
//  RoundCornerTextField.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/6/27.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI

struct RoundCornerTextField: View {
    var secureDisplay: Bool
    var title: String
    var placeHolder: String
    @Binding var value: String
    var valid: Bool
    var onReturn: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .fontWeight(.medium)
                Spacer()
            }.offset(x: 0, y: 10)
            ZStack {
                if (secureDisplay) {
                    SecureField(placeHolder, text: self.$value, onCommit: onReturn).textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    TextField(placeHolder, text: self.$value, onCommit: onReturn).font(.headline).textFieldStyle(RoundedBorderTextFieldStyle()).keyboardType(.numberPad)
                }
                HStack {
                    Spacer()
                    Image(systemName: "checkmark").font(Font.system(size: 20).bold()).foregroundColor(Color(.systemYellow)).padding(.trailing, 10).rotationEffect(Angle.degrees(valid ? 720 : 0)).scaleEffect(valid ? 1 : 0.01).animation(Animation.default)
                }
            }
        }
    }
}
