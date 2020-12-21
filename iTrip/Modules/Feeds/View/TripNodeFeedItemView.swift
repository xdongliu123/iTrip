//
//  TripNodeFeedItemView.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/11/15.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI
import Pages
import ASCollectionView

struct TripNodeFeedItemView: View {
    @State var captionExpanded: Bool = false
    @State var commentsExpanded: Bool = false
    @State var expand = false
    @State var showAlert: Bool = false

    @Environment(\.invalidateCellLayout) var invalidateCellLayout
    var viewModel: TripNodeFeedItemViewModel

    var header: some View
    {
        VStack(alignment: .leading)
        {
            HStack {
                Image(systemName: "clock")
                Text(viewModel.feed.postDate?.formatString(format: "yyyy-MM-dd HH:mm") ?? "")
            }.padding(.bottom, 5)
            
            Text(viewModel.feed.content ?? "")
            .lineLimit(self.captionExpanded ? nil : 2)
            .truncationMode(.tail)
            .onTapGesture
            {
                self.captionExpanded.toggle()
                self.invalidateCellLayout?(false)
            }
        }
        .padding([.leading, .trailing])
        .frame(maxWidth: .infinity, alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
    }

    var footer: some View {
        HStack {
            VStack(alignment: .leading) {
                if viewModel.feed.address?.desc?.count ?? 0 > 0 {
                    HStack {
                        Image(systemName: "location")
                        Text(viewModel.feed.address?.desc ?? "").lineLimit(1).truncationMode(.tail)
                    }
                    .font(.system(size: 15))
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
            }
            Spacer()
        }
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
            .lineLimit(self.commentsExpanded ? nil : 2)
            .truncationMode(.tail)
            .onTapGesture
            {
                self.commentsExpanded.toggle()
                self.invalidateCellLayout?(false)
            }
            Text("View all 15 comments").foregroundColor(Color(.systemGray))
        }
        .padding([.leading, .trailing])
        .frame(maxWidth: .infinity, alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
    }
    
    var imageGallery: some View {
        ZStack {
            IndicatorHScrollView(pageNum: viewModel.feed.feedPhotoArray.count, pageSize: screenWidth) {
                HStack {
                    ForEach(viewModel.feed.feedPhotoArray) { photo in
                        if (photo.remoteUrl?.count ?? 0) > 0 {
                            ASRemoteImageView(URL(string: photo.remoteUrl!)!)
                                .aspectRatio(1, contentMode: .fill)
                                .frame(width: screenWidth)
                        } else if (photo.localFileName?.count ?? 0) > 0 {
                            ASLocalImageView(photo.localFileName!)
                                .aspectRatio(1, contentMode: .fill)
                                .frame(width: screenWidth)
                        }
                    }
                }
            }
        }
    }

    var body: some View
    {
        ZStack {
            VStack
            {
                header
                imageGallery
                footer
                //textContent
                Spacer().layoutPriority(2)
            }
            .padding([.top])
            
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
                                    self.expand = false
                                    self.showAlert = true
                                }) {
                                    Text("Delete").padding(.vertical, 5)
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
        .alert(isPresented: self.$showAlert, content: {
            return Alert(title: Text("Warning"), message: Text("Are you certain to delete this feed"), primaryButton: .default(Text("Confirm"), action: {
                delete()
            }), secondaryButton: .default(Text("Cancel")))
        })
        .onTapGesture {
            self.expand = false
        }
    }
    
    func delete() {
        withAnimation {
            viewModel.delete()
        }
    }
}
