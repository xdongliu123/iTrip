//
//  TripNodeFeedViewModel.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/11/15.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI
import Combine
import Foundation

class TripNodeFeedItemViewModel {
    let feed: Feed
    let deletingFeedPublisher: PassthroughSubject<Feed, Never>
    init(feed: Feed, deletingFeedPublisher: PassthroughSubject<Feed, Never>) {
        self.feed = feed
        self.deletingFeedPublisher = deletingFeedPublisher
    }
    
    func delete() {
        deletingFeedPublisher.send(feed)
    }
}

class TripNodeFeedViewModel: ObservableObject {
    let tripNode: TripNode
    @Published var feeds: [Feed] = Feed.feedsForInstaSection()
    let newFeedPublisher = PassthroughSubject<Void, Never>()
    let deletingFeedPublisher = PassthroughSubject<Feed, Never>()
    var subscription: AnyCancellable?
    @Published var showIndicator = false
    
    init(_ tripNode: TripNode) {
        self.tripNode = tripNode
        reloadFeeds()
        subscription = deletingFeedPublisher.sink { (feed) in
            self.deleteFeed(feed)
        }
    }
    
    func reloadFeeds() {
        if let feedSet = tripNode.feeds as? Set<Feed> {
            feedSet.forEach { (feed) in
                feed.id = "\(UUID())"
            }
            feeds = Array(feedSet)
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
            self.tripNode.removeFromFeeds(feed)
            StrorageHelper.save()
            DispatchQueue.main.async {
                self.showIndicator = false
                self.reloadFeeds()
            }
        }
    }
}
