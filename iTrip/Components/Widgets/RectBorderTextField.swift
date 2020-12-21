//
//  RectBorderTextField.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/11.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI

struct RectBorderTextField: View {
    @State var editing = false
    var valid: Bool
    var errorTip: String = "format invalid"
    @Binding var value: String
    var required: Bool
    var secureDisplay: Bool
    var title: String
    var placeHolder: String

    var onReturn: () -> Void
    
    var body: some View {
        TextField(editing ? "" : placeHolder, text: self.$value, onEditingChanged: {editing in
            withAnimation(.spring()) {
                self.editing.toggle()
            }
            if (!editing) {
                self.onReturn()
            }
        }).font(.body).textFieldStyle(RectBorderTextFieldStyle(placeHolder: title, editing: self.editing, valid: valid, errorTip: self.errorTip, value: self.value, required: required))
    }
}

