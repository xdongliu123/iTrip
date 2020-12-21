//
//  BottomLineTextField.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/10.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI

struct BottomLineTextField: View {
    @State var editing = false
    
    var secureDisplay: Bool
    var placeHolder: String
    @Binding var value: String
    var valid: Bool
    var onReturn: () -> Void
    
    var body: some View {
        TextField(editing ? "" : placeHolder, text: self.$value, onEditingChanged: {editing in
            withAnimation(.spring()) {
                self.editing.toggle()
            }
        }).font(.body).textFieldStyle(BottomLineTextFieldStyle(editing: self.editing, placeHolder: placeHolder, valid: valid))
    }
}
