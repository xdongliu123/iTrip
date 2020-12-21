//
//  MainView.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/2.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var userModel: UserModel
    
    var body: some View {
        GeometryReader { _ in
            if !self.userModel.isLogin {
                IndexView().transition(.flightDetailsTransition)
            } else {
                WelcomeView().transition(.flightDetailsTransition)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
