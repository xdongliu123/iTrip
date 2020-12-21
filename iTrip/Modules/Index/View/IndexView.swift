//
//  IndexView.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/2.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI

struct IndexView: View {
    @State var selectTab = 1
    var body: some View {
        TabView(selection: $selectTab) {
            TripsView().tabItem {
                Image(systemName: "folder").font(Font.system(size: 20))
                Text("Trips")
            }.tag(1)
            FeedIndexView(viewModel: FeedIndexViewModel()).tabItem {
                Image(systemName: "sun.min").font(Font.system(size: 20))
                Text("Feeds")
            }.tag(2)
            Text("Tab Content 2").tabItem {
                Image(systemName: "person.circle").font(Font.system(size: 20))
                Text("Profile") }.tag(3)
        }
    }
}

struct IndexView_Previews: PreviewProvider {
    static var previews: some View {
        IndexView()
    }
}
