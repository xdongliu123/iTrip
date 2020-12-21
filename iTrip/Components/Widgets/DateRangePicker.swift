//
//  DateRangePicker.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/11.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI

struct DateRangePicker: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    let totalWidth: CGFloat
    @Binding var showPicker: Bool
    @State var isStartState = true
    let required: Bool
    
    var body: some View {
        VStack {
            HStack() {
                Button(action: {
                    UIApplication.shared.endEditing()
                    withAnimation {
                        if (!self.isStartState && self.showPicker) {
                            self.isStartState.toggle()
                        } else if (!self.isStartState && !self.showPicker) {
                            self.isStartState.toggle()
                            self.showPicker.toggle()
                        } else {
                            self.showPicker.toggle()
                        }
                    }
                }) {
                    valueDisplayWidget(title: "Start Date", value: startDate.formatString(), showColorLine: self.isStartState)
                }
                Spacer()
                Button(action: {
                    UIApplication.shared.endEditing()
                    withAnimation {
                        if (self.isStartState && self.showPicker) {
                            self.isStartState.toggle()
                        } else if (self.isStartState && !self.showPicker) {
                            self.isStartState.toggle()
                            self.showPicker.toggle()
                        } else {
                            self.showPicker.toggle()
                        }
                    }
                }) {
                    valueDisplayWidget(title: "End Date", value: endDate.formatString(), showColorLine: !self.isStartState)
                }
            }
            if (showPicker) {
                DatePicker(selection: isStartState ? $startDate : $endDate, displayedComponents:[.date], label: { Text("") })
            }
        }
    }
    
    func valueDisplayWidget(title: String, value: String, showColorLine: Bool) -> some View {
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
            } else {
                ZStack()  {
                    Text(value)
                    .font(Font.body)
                    .foregroundColor(Color.black)
                    .offset(x: -15, y: 0)
                    .padding(.vertical, 20)
                    .frame(width: totalWidth / 2 - 5)
                    .overlay(RoundedRectangle(cornerRadius: 6)
                             .stroke(lineWidth: 0.9)
                             .foregroundColor(Color.gray.opacity(0.9)))
                    HStack(spacing: 0) {
//                        if (required) {
//                            Text("*")
//                            .padding(EdgeInsets.init(top: 4, leading: 0, bottom: 0, trailing: 2))
//                            .foregroundColor(Color.red.opacity(0.9)).font(Font.headline)
//                        }
                        Text(title)
                        .font(Font.body)
                        .foregroundColor(Color.gray.opacity(0.9))
                    }
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .offset(x: -25, y: -30)
                }
            }
        }
    }
}
