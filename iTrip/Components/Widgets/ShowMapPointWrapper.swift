//
//  ShowMapPointWrapper.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/9/17.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftUI

struct ShowMapPointWrapper: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    var address: TripAddressState

    func makeUIViewController(context: Context) -> MapPointViewController {
        let viewController = MapPointViewController()
        viewController.location = address.location.convert2Location()
        viewController.name = address.name
        viewController.detail = address.description
        return viewController
    }

    func updateUIViewController(_ uiViewController: MapPointViewController, context: Context) {
        
    }
}
