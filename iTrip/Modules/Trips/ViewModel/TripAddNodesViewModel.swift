//
//  TripAddNodesViewModel.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/27.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import Combine

class TripAddNodesViewModel: ObservableObject {
    private let publisher = PassthroughSubject<TripNodeType, Never>()
    
    var nodeTypePublisher: AnyPublisher<TripNodeType, Never> {
        return publisher.eraseToAnyPublisher()
    }
    
    func sendEvent(_ type: TripNodeType) {
        publisher.send(type)
    }
}
