//
//  RectifiedCircledIconView.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/17.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI
import StepperView

public struct RectifiedCircledIconView: View {
    /// icon for the step indicator
    public var image:Image
    /// width for step indicator
    public var width:CGFloat
    /// color for step indicator
    public var color:Color
    /// stroke color for step indicator
    public var strokeColor:Color
    /// detect the color scheme i.e., light or dark mode
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    /// initiazes `image` , `width` , `color` and  `strokeColor`
    public init(image:Image, width:CGFloat, color: Color = Color.black, strokeColor: Color = Colors.blue(.lightSky).rawValue) {
        self.image = image
        self.width = width
        self.color = color
        self.strokeColor = strokeColor
    }
    
    /// provides the content and behavior of this view.
    public var body: some View {
        VStack {
            Circle()
                .foregroundColor(colorScheme == .light ? Color.white : Color.black )
                .frame(width: width, height: width)
                .overlay(Circle()
                    .stroke(strokeColor, lineWidth: 1)
                    .foregroundColor(self.color)
                    .overlay(image
                        .resizable()
                        .foregroundColor(strokeColor)
                        .frame(width: width * 0.6, height: width * 0.6)
                        .aspectRatio(contentMode: .fit)))
        }
    }
}
