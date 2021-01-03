//
//  TripNodeFeedView.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/11/15.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI
import Combine
import ASCollectionView

struct TripNodeFeedView: View {
    @ObservedObject var viewModel: TripNodeFeedViewModel
    @State var addNewFeed: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
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
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnItem(title: "", action: {
                self.presentationMode.wrappedValue.dismiss()
            }), trailing: Button(action: {
                self.addNewFeed = true
            }) {
                Image(systemName: "plus").font(Font.system(size: 20, weight: .bold  ,design: .default))
            })
            .onReceive(viewModel.newFeedPublisher.eraseToAnyPublisher()) { () in
                viewModel.loadFeeds()
            }
            .sheet(isPresented: $addNewFeed) {
                NewfeedEditView(viewModel: NewfeedEditViewModel(tripNode: viewModel.tripNode, publisher: viewModel.newFeedPublisher))
            }
            disabled(self.viewModel.showIndicator)
        }
    }
    
    func onCellEventPosts(_ event: CellEvent<Feed>) {

    }
}
