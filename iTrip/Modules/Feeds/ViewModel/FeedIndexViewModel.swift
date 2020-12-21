//
//  FeedIndexViewModel.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/11/13.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI
import Combine

class FeedIndexViewModel: ObservableObject {
    @Published var feeds: [Feed] = Feed.feedsForInstaSection()
}
