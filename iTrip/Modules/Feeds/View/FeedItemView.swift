//
//  FeedItemView.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/11/13.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import ASCollectionView
import SwiftUI

struct FeedItemView: View
{
    @State var liked: Bool = false
    @State var bookmarked: Bool = false
    @State var captionExpanded: Bool = false
    @State var expand = false

    @Environment(\.invalidateCellLayout) var invalidateCellLayout
    var feed: Feed

    var header: some View
    {
        HStack
        {
            ASRemoteImageView(feed.avatarUrl)
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .padding(.leading)
            VStack(alignment: .leading)
            {
                Text(feed.poster ?? "").fontWeight(.bold)
                Text(feed.address?.name ?? "")
            }
            Spacer()
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    var buttonBar: some View
    {
        HStack
        {
            Image(systemName: self.liked ? "heart.fill" : "heart")
                .renderingMode(.template)
                .foregroundColor(self.liked ? .red : Color(.label))
                .onTapGesture
            {
                self.liked.toggle()
            }
            Image(systemName: "bubble.right")
            Image(systemName: "paperplane")
            Spacer()
            Image(systemName: self.bookmarked ? "bookmark.fill" : "bookmark")
                .renderingMode(.template)
                .foregroundColor(self.bookmarked ? .yellow : Color(.label))
                .onTapGesture
            {
                self.bookmarked.toggle()
            }
        }
        .font(.system(size: 20))
        .padding()
        .fixedSize(horizontal: false, vertical: true)
    }

    var textContent: some View
    {
        VStack(alignment: .leading, spacing: 10)
        {
            Text("Liked by ") + Text("apptekstudios").fontWeight(.bold) + Text(" and ") + Text("others").fontWeight(.bold)
            Group
            {
                Text("\(Lorem.fullName)   ").fontWeight(.bold) + Text(Lorem.sentences(1 ... 3))
            }
            .lineLimit(self.captionExpanded ? nil : 2)
            .truncationMode(.tail)
            .onTapGesture
            {
                self.captionExpanded.toggle()
                self.invalidateCellLayout?(false)
            }
            Text("View all 15 comments").foregroundColor(Color(.systemGray))
        }
        .padding([.leading, .trailing])
        .frame(maxWidth: .infinity, alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
    }

    var body: some View
    {
        ZStack {
            VStack
            {
                header
                ASRemoteImageView(feed.feedPhotoUrl)
                    .aspectRatio(1, contentMode: .fill)
                    .gesture(
                        TapGesture(count: 2).onEnded
                        {
                            self.liked.toggle()
                        }
                    )
                buttonBar
                textContent
                Spacer().layoutPriority(2)
            }
            .padding([.top, .bottom])
            GeometryReader {geo in
                HStack {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 0, content:  {
                        Button {
                            self.expand.toggle()
                        } label: {
                            Image(systemName: "ellipsis").padding()
                        }
                        if expand {
                            Image(systemName: "arrowtriangle.up.fill")
                                .font(Font.system(size: 11))
                                .foregroundColor(Color.gray)
                                .padding(.trailing, 11)
                                .offset(x: 0, y: -12.5)
                            VStack(spacing: 0) {
                                Button(action: {
                                    self.expand.toggle()
                                    print("delete")
                                }) {
                                    Text("Delete").padding(.vertical, 5)
                                }.foregroundColor(.white)
                                Divider()
                                Button(action: {
                                    self.expand.toggle()
                                }) {
                                    Text("Edit").padding(.vertical, 5)
                                }.foregroundColor(.white)
                                Divider()
                                Button(action: {
                                    self.expand.toggle()
                                }) {
                                    Text("Share").padding(.vertical, 5)
                                }.foregroundColor(.white)
                             }
                             .font(Font.system(size: 15))
                             .frame(width: 80)
                             .background(Color.gray)
                             .offset(x: 0, y: -13)
                             .padding(.trailing, 11)
                        }
                    })
                    .padding(.top, 5)
                    .animation(.spring())
                }
            }
        }
        .onTapGesture {
            self.expand = false
        }
    }
}
