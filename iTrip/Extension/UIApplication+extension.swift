//
//  UIApplication+extension.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/6/24.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension AppDelegate {
    func setupApplicationStyles() {
        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().selectionStyle = .none
        UITableViewHeaderFooterView.appearance().tintColor = UIColor.colorWith(rgb: 0xF5F7F9)
        UITableView.appearance().backgroundColor = UIColor.colorWith(rgb: 0xF5F7F9)
    }
}
