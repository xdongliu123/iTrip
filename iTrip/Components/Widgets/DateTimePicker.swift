//
//  DateTimePicker.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/28.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI

struct DateTimePicker: View {
    @Binding var dateTime: Date
    @Binding var showPicker: Bool
    @State var isDateMode = true
    let totalWidth: CGFloat
    let dateTitle: String
    let timeTitle: String
    let required: Bool
    
    var body: some View {
        VStack {
            HStack() {
                Button(action: {
                    UIApplication.shared.endEditing()
                    withAnimation {
                        if (!self.isDateMode && self.showPicker) {
                            self.isDateMode.toggle()
                        } else if (!self.isDateMode && !self.showPicker) {
                            self.isDateMode.toggle()
                            self.showPicker.toggle()
                        } else {
                            self.showPicker.toggle()
                        }
                    }
                }) {
                    valueDisplayWidget(title: dateTitle, value: dateTime.formatString(), showColorLine: self.isDateMode, width: totalWidth * 0.6, titleOffset: -47)
                }
                Spacer()
                .frame(width: totalWidth * 0.05)
                Button(action: {
                    UIApplication.shared.endEditing()
                    withAnimation {
                        if (self.isDateMode && self.showPicker) {
                            self.isDateMode.toggle()
                        } else if (self.isDateMode && !self.showPicker) {
                            self.isDateMode.toggle()
                            self.showPicker.toggle()
                        } else {
                            self.showPicker.toggle()
                        }
                    }
                }) {
                    valueDisplayWidget(title: timeTitle, value: dateTime.formatString(format: "HH:mm"), showColorLine: !self.isDateMode, width: totalWidth * 0.35, titleOffset: -10)
                }
            }
            if (showPicker) {
                DatePicker(selection: $dateTime, displayedComponents:[isDateMode ? .date : .hourAndMinute], label: { Text("") }).datePickerStyle(WheelDatePickerStyle())
            }
        }
    }
    
    func valueDisplayWidget(title: String, value: String, showColorLine: Bool, width: CGFloat, titleOffset: CGFloat) -> some View {
        return Group {
            if self.showPicker {
                VStack {
                    Text(value).font(Font.body).foregroundColor(Color.black)
                    if (showColorLine) {
                        Divider().background(Color.blue)
                    } else {
                        Divider()
                    }
                }
                .frame(width: width)
            } else {
                ZStack(alignment: .topLeading)  {
                        HStack{
                            Text(value)
                            .font(Font.body)
                            .foregroundColor(Color.black)
                            .padding(.leading, 20)
                            Spacer()
                        }
                        .padding(.vertical, 15)
                        .frame(width: width)
                        .overlay(RoundedRectangle(cornerRadius: 6)
                        .stroke(lineWidth: 0.9)
                        .foregroundColor(Color.gray.opacity(0.9)))
                        HStack(spacing: 0) {
                            Text(title)
                            .font(Font.body)
                            .foregroundColor(Color.gray.opacity(0.9))
//                            if (required) {
//                                Text("*")
//                                .padding(EdgeInsets.init(top: 4, leading: 2, bottom: 0, trailing: 0))
//                                .foregroundColor(Color.red.opacity(0.9)).font(Font.callout)
//                            }
                        }
                        .padding(.horizontal, 10)
                        .background(Color.white)
                        .alignmentGuide(.leading) { _  in -10 }
                        .alignmentGuide(.top) { d in d.height / 2}
                    }
            }
        }
    }
}
