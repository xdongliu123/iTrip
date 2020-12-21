//
//  View+Extension.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/28.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI

typealias CallBack = ()->Void

extension View {
    func whiteNavBarWithOnlyBackItem(_ title: String, backTitle: String="Cancel", backAction: @escaping CallBack) -> some View {
        ZStack {
            HStack {
                Text(title)
                .bold()
            }
            HStack {
                btnItem(title: backTitle, action: backAction)
                Spacer()
            }
        }
        .padding(.horizontal, 20).padding(.top, 25).padding(.bottom, 10)
    }
    
    func whiteNavBar(_ title: String, backTitle: String="Cancel", backAction: @escaping CallBack, rightTitle: String, rightAction: @escaping CallBack) -> some View {
        ZStack {
            HStack {
                Text(title).bold()
            }
            HStack {
                btnItem(title: backTitle, action: backAction)
                Spacer()
                btnItem(title: rightTitle, isBack: false, action: rightAction)
            }
        }
        .padding(.horizontal, 20).padding(.top, 25).padding(.bottom, 10)
    }
    
    func whiteNavBar(_ title: String, backTitle: String="Cancel", backAction: @escaping CallBack, rightImage: Image, rightAction: @escaping CallBack) -> some View {
        ZStack {
            HStack {
                Text(title)
                .bold()
            }
            HStack {
                btnItem(title: backTitle, action: backAction)
                Spacer()
                Button(action: {
                    rightAction()
                 }) {
                    rightImage.font(Font.system(size: 20)).foregroundColor(Color.black)
                }
            }
        }
        .padding(.horizontal, 20).padding(.top, 25).padding(.bottom, 10)
    }
    
    func customNavBar(_ title: String, backAction: @escaping CallBack, rightImage: Image, rightAction: @escaping CallBack) -> some View {
        HStack {
            Button(action: {
               backAction()
            }) {
                Image(systemName: "arrow.left")
                .font(Font.system(size: 20))
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color.white)
            }
            Spacer()
            Text(title).bold()
            Spacer()
            Button(action: {
                rightAction()
             }) {
                rightImage.font(Font.system(size: 20)).foregroundColor(Color.white)
            }
        }
    }
    
    func tripNodeEditSectionHeader(_ title: String, topPadding: CGFloat=15) -> some View {
        return HStack{
            Text("\(title)")
            Spacer()
        }
        .padding(.horizontal, FieldOffset)
        .padding(.top, topPadding)
    }
    
    func btnItem(title: String, isBack: Bool=true, action: @escaping ()->Void) -> some View {
        Button(action: {
           action()
        }) {
            if (isBack) {
                Image(systemName: "arrow.left")
                .font(Font.system(size: 20))
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color.black)
            } else {
                Text(title)
                    .fontWeight(Font.Weight.heavy)
                    .foregroundColor(.black)
            }
        }
    }
}
