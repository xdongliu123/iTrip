//
//  KeyboardResponder.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/6/24.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import UIKit
import Combine

final class KeyboardResponder: ObservableObject {
    let didChange = PassthroughSubject<CGFloat, Never>()
    private var _center: NotificationCenter
    @Published private(set) var keyboardShown: Bool = false
    @Published private(set) var keyboardHeight: CGFloat = 0.0

    init(center: NotificationCenter = .default) {
        _center = center
        _center.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        _center.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        _center.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardShown = true
            keyboardHeight = keyboardSize.size.height
        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        keyboardShown = false
        keyboardHeight = 0
    }
}
