//
//  Array+Extension.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/11/18.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import Foundation

struct IdentifiableArray<Element>: Identifiable {
    let id = UUID()
    var elements: [Element] = []
}

extension Array {
    func chunked(into size:Int) -> [IdentifiableArray<Element>] {
        if count == 0 {
            return []
        }
        return stride(from: 0, to: count, by: size).map {
            IdentifiableArray<Element>(elements: Array(self[$0 ..< Swift.min($0 + size, count)]))
        }
    }
}
