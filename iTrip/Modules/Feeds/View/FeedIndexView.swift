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
    var postsSection: ASTableViewSection<Int>
    {   ASTableViewSection(
        id: 0,
        data: viewModel.feeds,
            onCellEvent: onCellEventPosts(_:))
        { item, _ in
          FeedItemView(feed: item)
        }
        .tableViewSetEstimatedSizes(headerHeight: 50) // Optional: Provide reasonable estimated heights for this section
    }

    var body: some View {
        NavigationView {
            ASTableView {
                postsSection
            }
            .separatorsEnabled(false)
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
