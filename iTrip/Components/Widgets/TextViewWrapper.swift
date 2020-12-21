//
//  TextViewWrapper.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/10.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI

struct TextViewWrapper: UIViewRepresentable {
    typealias UIViewType = UITextView
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = UIColor.colorWith(rgb: 0xF4F2F7)
        textView.delegate = context.coordinator
        textView.contentInset = UIEdgeInsets.init(top: 2, left: 5, bottom: 2, right: 5)
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = text
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    
    class Coordinator: NSObject, UITextViewDelegate {
        var value: Binding<String>
        
        init(value: Binding<String>) {
            self.value = value
        }
        
        func textViewDidChange(_ textView: UITextView) {
            value.wrappedValue = textView.text
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(value: $text)
    }
}
