//
//  TextFieldStyleModifier.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/10.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI

struct BottomLineTextFieldStyle: TextFieldStyle {
    let editing: Bool
    let placeHolder: String
    let valid: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        VStack() {
            if (editing) {
                HStack {
                    Text(placeHolder).foregroundColor(Color.blue).font(Font.system(size: 15))
                    Spacer()
                }
            }
            HStack {
                configuration
                HStack {
                    Spacer()
                    Image(systemName: "checkmark").font(Font.system(size: 18).bold()).foregroundColor(Color(.systemGreen)).padding(.trailing, 10).rotationEffect(Angle.degrees(valid ? 720 : 0)).scaleEffect(valid ? 1 : 0.01).animation(Animation.default)
                }
            }
            Rectangle()
                .frame(height: 0.5, alignment: .bottom)
                .foregroundColor(Color.blue.opacity(0.8))
            Rectangle()
                .frame(height: 0.5, alignment: .bottom)
                .foregroundColor(Color.white.opacity(0.8))
        }
    }
}

struct RectBorderTextFieldStyle: TextFieldStyle {
    let placeHolder: String
    let editing: Bool
    let valid: Bool
    let errorTip: String
    let value: String
    let required: Bool
    
    func borderColor() -> Color {
        if (!editing && value.count > 0 && !valid) {
            return Color.red.opacity(0.9)
        } else {
            return Color.gray.opacity(0.0);
        }
    }
    
    func backgroundColor() -> Color {
        if (!editing && value.count > 0 && !valid) {
            return Color(rgb:0xFEFFF2)
        } else {
            return Color(rgb:0xF4F2F7)
        }
    }
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        VStack(spacing: 2) {
            if (!editing && value.count > 0 && !valid) {
                HStack {
                    Text(self.errorTip).foregroundColor(Color.red).font(Font.footnote).bold()
                        .padding(EdgeInsets.init(top: 0, leading: 10, bottom: 0, trailing: 10))
                    .background(Color.clear)
                    Spacer()
                }
            }
            ZStack() {
                configuration
                .padding(EdgeInsets(top: editing ? 10 : 20, leading: 20, bottom: 10, trailing: 20))
                .background(backgroundColor())
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 0.5).foregroundColor(borderColor()))
                if (!editing) {
                    HStack(spacing: 0) {
                        Text(self.placeHolder).foregroundColor(Color(rgb: 0xB2AFBB)).font(Font.footnote).bold()
                            .padding(EdgeInsets.init(top: 0, leading: 10, bottom: 0, trailing: 10))
                        .background(Color.clear)
                        Spacer()
                    }
                    .offset(x: 10, y: -15)
                }
                HStack {
                    Spacer()
                    Image(systemName: "checkmark").font(Font.system(size: 18).bold()).foregroundColor(Color(.systemGreen)).padding(.trailing, 10).rotationEffect(Angle.degrees(valid ? 720 : 0)).scaleEffect(valid ? 1 : 0.01).animation(Animation.default)
                }
            }
        }
    }
}

struct RectBorderLocationFieldStyle: TextFieldStyle {
    let title: String
    let mapClick: ()->Void
    let editing: Bool
    let valid: Bool
    
    func borderColor() -> Color {
        return editing ? Color(rgb: 0x7B5DEC).opacity(0.9) : (valid ? Color.gray.opacity(0.9) : Color.red.opacity(0.9));
    }
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack() {
            configuration.padding(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 50)).overlay(
                RoundedRectangle(cornerRadius: 6).stroke(lineWidth: 0.9).foregroundColor(borderColor()))
            HStack(spacing: 0) {
                Text(self.title)
                .foregroundColor(Color.gray.opacity(0.9)).font(Font.body)
                    .padding(EdgeInsets.init(top: 0, leading: 10, bottom: 0, trailing: 10))
                .background(Color.white)
                Spacer()
            }
            .offset(x: 10, y: -25)
            HStack {
                Spacer()
                Button(action: {
                    self.mapClick()
                }) {
                    Image(systemName: "map").font(Font.system(size: 18).bold()).foregroundColor(Color(valid ? .systemGreen : .gray)).padding(.trailing, 10)
                }
            }
        }
    }
}
