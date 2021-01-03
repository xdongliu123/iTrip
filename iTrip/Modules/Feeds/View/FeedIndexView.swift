//
//  FeedIndexView.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/11/12.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI
import Combine
import ASCollectionView

struct FeedIndexView: View {
    @ObservedObject var viewModel: FeedIndexViewModel
//    var postsSection: ASTableViewSection<Int>
//    {   ASTableViewSection(
//        id: 0,
//        data: viewModel.feeds,
//            onCellEvent: onCellEventPosts(_:))
//        { item, _ in
//          FeedItemView(feed: item)
//        }
//        .tableViewSetEstimatedSizes(headerHeight: 50) // Optional: Provide reasonable estimated heights for this section
//    }

    var postsSection: ASTableViewSection<Int>
    {   ASTableViewSection(
        id: 0,
        data: viewModel.feeds,
            onCellEvent: onCellEventPosts(_:))
        { item, _ in
        TripNodeFeedItemView(viewModel: TripNodeFeedItemViewModel(feed: item, deletingFeedPublisher: viewModel.deletingFeedPublisher))
        }
        .tableViewSetEstimatedSizes(headerHeight: 50) // Optional: Provide reasonable estimated heights for this section
    }
    
    var content: some View {
        if #available(iOS 14.0, *) {
            return AnyView (
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.feeds.sorted(by: { (f1, f2) -> Bool in
                            f1.postDate ?? Date() > f2.postDate ?? Date()
                        })) { feed in
                            TripNodeFeedItemView(viewModel: TripNodeFeedItemViewModel(feed: feed, deletingFeedPublisher: viewModel.deletingFeedPublisher))
                        }
                    }
                }
            )
        } else {
            return  AnyView(ASTableView {
                                postsSection
                            }
                            .separatorsEnabled(false))
        }
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                content
                // deleting indicator
                ActivityIndicator(isAnimating: self.$viewModel.showIndicator, style: .large)
                
            }
            .navigationBarTitle("Feeds", displayMode: .inline)
        }
    }
    
    func onCellEventPosts(_ event: CellEvent<Feed>)
    {
        switch event
        {
        case let .onAppear(item):
            ASRemoteImageManager.shared.load(item.avatarUrl)
            ASRemoteImageManager.shared.load(item.feedPhotoUrl)
        case let .onDisappear(item):
            ASRemoteImageManager.shared.cancelLoad(for: item.avatarUrl)
            ASRemoteImageManager.shared.cancelLoad(for: item.feedPhotoUrl)
        case let .prefetchForData(data):
            for item in data
            {
                ASRemoteImageManager.shared.load(item.feedPhotoUrl)
                ASRemoteImageManager.shared.load(item.avatarUrl)
            }
        case let .cancelPrefetchForData(data):
            for item in data
            {
                ASRemoteImageManager.shared.cancelLoad(for: item.avatarUrl)
                ASRemoteImageManager.shared.cancelLoad(for: item.feedPhotoUrl)
            }
        }
    }
}
