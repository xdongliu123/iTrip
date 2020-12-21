//
//  RectBorderLocationField.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/1.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI

struct RectBorderLocationField: View {
    @State var editing = false
    var valid: Bool
    var value: Binding<String>
    var required: Bool
    
    var title: String
    var placeHolder: String = "Click right icon to select location"
    var mapClick: () -> Void
    var onReturn: () -> Void
    
    var body: some View {
        TextField(editing ? "" : placeHolder, text: self.value, onEditingChanged: {editing in
            withAnimation(.spring()) {
                self.editing.toggle()
            }
            if (!editing) {
                self.onReturn()
            }
        })
        .font(.body)
        .textFieldStyle(RectBorderLocationFieldStyle(title: title, mapClick: {
                self.mapClick()
            }, editing: editing, valid: valid))
    }
}
