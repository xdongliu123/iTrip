//
//  SelectMapPointWrapper.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/1.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftUI

struct SelectMapPointWrapper: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var address: TripAddressState

    func makeUIViewController(context: Context) -> MapPointSelectViewController {
        let viewController = UIStoryboard(name: "MapSelectPointScenes", bundle: nil).instantiateViewController(withIdentifier: "mapSelectPointMainView") as! MapPointSelectViewController
        viewController.location = address.location.convert2Location()
        viewController.name = address.name
        viewController.detail = address.description
        viewController.locationReceiver = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: MapPointSelectViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject, MapPointSelectReceiver {
        var value: Binding<TripAddressState>
        
        init(value: Binding<TripAddressState>) {
            self.value = value
        }
        
        func receiveLocation(_ location: CLLocationCoordinate2D, _ name: String, _ description: String) {
            value.wrappedValue.location = "\(location.latitude.roundTo(places: 6)),\(location.longitude.roundTo(places: 6))"
            // value.wrappedValue.name = name
            value.wrappedValue.description = description
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(value: $address)
    }
}
