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
    @Published var feeds: [Feed] = []
    let deletingFeedPublisher = PassthroughSubject<Feed, Never>()
    var subscription: AnyCancellable?
    @Published var showIndicator = false
    
    init() {
        loadFeeds()
        subscription = deletingFeedPublisher.sink { (feed) in
            self.deleteFeed(feed)
        }
    }
    
    func loadFeeds() {
        feeds = StrorageHelper.findAllObjects()
        feeds = feeds.filter { (feed) -> Bool in
            feed.owner != nil
        }
        feeds.forEach { (feed) in
            if feed.id == nil {
                feed.id = "\(UUID())"
            }
        }
    }
    
    func deleteFeed(_ feed: Feed) {
        self.showIndicator = true
        DispatchQueue.global().async {
            if let photoSet = feed.photos as? Set<FeedPhoto> {
                photoSet.forEach({ (photo) in
                    ImageController.shared.deleteImage(imageName: photo.localFileName!)
                })
            }
            StrorageHelper.delete(model: feed)
            StrorageHelper.save()
            DispatchQueue.main.async {
                self.showIndicator = false
                self.loadFeeds()
            }
        }
    }
}
