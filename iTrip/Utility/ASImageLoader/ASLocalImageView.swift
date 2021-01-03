//
//  ASLocalImageView.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/11/23.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI

struct ASLocalImageView: View {
    init(_ filename: String)
    {
        self.filename = filename
        imageLoader = ASLocalImageLoader(filename)
        imageLoader.startLoad()
    }

    let filename: String
    @ObservedObject var imageLoader: ASLocalImageLoader

    var content: some View
    {
        ZStack
        {
            Color(.secondarySystemBackground)
            Image(systemName: "photo")
            self.imageLoader.image.map
            { image in
                Image(uiImage: image)
                    .resizable()
            }.transition(AnyTransition.opacity.animation(Animation.default))
        }
        .compositingGroup()
    }

    var body: some View
    {
        content.onAppear {
//            if imageLoader.image == nil {
//                imageLoader.startLoad()
//            }
        }
    }
}
