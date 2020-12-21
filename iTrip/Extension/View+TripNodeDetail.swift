//
//  View+TripNodeDetail.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/9/17.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI

extension View {
    func nodeDetailSectionHeader(title: String) -> AnyView {
        AnyView(
            HStack{
                Text(title).font(Font.callout)
                Spacer()
            }.padding(.top, 8)
             .padding(.bottom, 5)
        )
    }
    
    func nodeDetailTextItemView(title: String, value: String, vertical: Bool=true) -> AnyView {
        if vertical {
            return AnyView(
                VStack {
                    HStack(spacing: 0) {
                        Text(title).foregroundColor(Color(rgb: 0x5d6569)).font(Font.callout).bold()
                            .padding(EdgeInsets.init(top: 0, leading: 0, bottom: 5, trailing: 10))
                        .background(Color.clear)
                        Spacer()
                    }
                    HStack{
                        Text(value)
                        .font(Font.callout)
                        Spacer()
                    }
                    Spacer().frame(height: 10)
                }
            )
        } else {
            return AnyView(
                HStack(alignment: .bottom, spacing: 10) {
                    Text(title).foregroundColor(Color(rgb: 0x5d6569)).font(Font.callout).bold()
                    .background(Color.clear)
                    Text(value)
                    .font(Font.callout)
                    Spacer()
                }
            )
        }
    }
}
