//
//  IndicatorHScrollView.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/12/18.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//
/// Contains the gap between the smallest value for the y-coordinate of
/// the frame layer and the content layer.
private struct OffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = .zero
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

import SwiftUI

struct IndicatorHScrollView<Content: View>: View {
    let content: () -> Content
    let pageSize: CGFloat
    let pageNum: Int
    @State var currentIndex = 0
    
  init(
      pageNum: Int,
      pageSize: CGFloat,
      @ViewBuilder content: @escaping () -> Content) {
      self.pageNum = pageNum
      self.pageSize = pageSize
      self.content = content
  }

  var body: some View {
        ZStack {
            ScrollView(.horizontal) {
              // offsetReader
              content()
                .background(GeometryReader { proxy in
                    Color.clear
                      .preference(
                        key: OffsetPreferenceKey.self,
                        value: proxy.frame(in: .named("frameLayer")).minX
                      )
                  })
              // 👆🏻 this places the real content as if our `offsetReader` was not there.
            }
            if pageNum > 1 {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ForEach(0..<pageNum) { index in
                            Circle()
                                .frame(width: 6)
                                .foregroundColor(currentIndex == index ? Color.red : Color.white)
                        }
                        Spacer()
                    }
                    .frame(height: 30, alignment: .center)
                }
            }
        }
        .coordinateSpace(name: "frameLayer")
        .onPreferenceChange(OffsetPreferenceKey.self) { offset in
            let newIndex = Int(ceil((-offset / pageSize) - 0.5))
            if newIndex != self.currentIndex {
                self.currentIndex = newIndex
            }
        }
  }

  // no use
  var offsetReader: some View {
    GeometryReader { proxy in
      Color.red
        .preference(
          key: OffsetPreferenceKey.self,
          value: proxy.frame(in: .named("frameLayer")).minX
        )
    }
    .frame(width: 0)
    // this makes sure that the reader doesn't affect the content height
  }
}
