//
//  DatePickerWidget.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/11.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI

struct DatePickerWidget: View {
    @Binding var value: Date
    @Binding var showPicker: Bool
    
    var strValue: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: value)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation {
                        self.showPicker.toggle()
                    }
                }) {
                    Text(strValue)
                    Spacer()
                }
            }
            if (showPicker) {
                DatePicker(selection: $value, label: { Text("") })
            }
        }
    }
}

struct DatePickerWidget_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerWidget(value: .constant(Date()), showPicker: .constant(true))
    }
}
