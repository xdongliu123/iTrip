//
//  ShowAddressListWrapper.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/11/20.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI
import SwiftLocation

struct SelectAddressWrapper: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var address: TripAddressState
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let addressVC = SelectAddressViewController()
        addressVC.selectAddressCallback = { location in
            address.location = "\(location.coordinates.latitude),\(location.coordinates.longitude)"
            address.description = location.info[GeoLocation.Keys.formattedAddress]! ?? ""
        }
        let nav = UINavigationController(rootViewController: addressVC)
        return nav
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
}
