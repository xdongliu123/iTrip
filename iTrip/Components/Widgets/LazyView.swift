//
//  LazyView.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/9/27.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI

struct LazyView<Content: View>: View {
    private let build: () -> Content
    public init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    public var body: Content {
        build()
    }
}
