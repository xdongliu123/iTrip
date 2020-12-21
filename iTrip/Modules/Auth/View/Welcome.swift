//
//  Welcome.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/2.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI
import Combine
import PopupView
import ActivityIndicatorView

struct WelcomeView: View {
    static let logoHeightScale: CGFloat = 0.45
    @ObservedObject private var keyboardListener = KeyboardResponder()
    @ObservedObject private var viewModel: LoginViewModel = LoginViewModel()
}

extension WelcomeView {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Logo Background
                VStack {
                    Color(.systemYellow).edgesIgnoringSafeArea(.all).frame(width: geometry.size.width, height: geometry.size.height * WelcomeView.logoHeightScale)
                    Spacer()
                }
                
                // Logo
                Text(self.viewModel.logoTitle).font(Font.title.weight(.heavy))
                .position(x: geometry.size.width / 2, y: 200)
                
                // SMS Login
                SMSLogPanel(viewModel: self.viewModel)
                    .authCardStyle(keyboardShown: self.keyboardListener.keyboardShown, hideMode: self.viewModel.layerType != .SMSLogin).disabled(self.viewModel.showLoadingIndicator)
                
                // Register
                RegPanel(viewModel: self.viewModel)
                    .authCardStyle(keyboardShown: self.keyboardListener.keyboardShown, hideMode: self.viewModel.layerType != .Register).disabled(self.viewModel.showLoadingIndicator)
                
                // Login
                LoginPanel(viewModel: self.viewModel)
                    .authCardStyle(keyboardShown: self.keyboardListener.keyboardShown, hideMode: self.viewModel.layerType != .Login).disabled(self.viewModel.showLoadingIndicator)
                
                // Loading indicator
                ActivityIndicatorView(isVisible: self.$viewModel.showLoadingIndicator, type: .default).frame(width: 40, height: 40).zIndex(4)
            }
            .gesture(TapGesture().onEnded({ () in
                UIApplication.shared.endEditing()
            }))
            .popup(isPresented: self.$viewModel.showPopupView, autohideIn: 3) {
                HStack {
                    Text(self.viewModel.popUpTip)
                }
                .frame(width: 200, height: 60)
                .background(Color(red: 0.85, green: 0.8, blue: 0.95))
                .cornerRadius(30.0)
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
