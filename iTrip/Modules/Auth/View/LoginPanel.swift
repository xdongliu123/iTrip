//
//  LoginPanel.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/6/27.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI

struct LoginPanel: View {
    @State var mobile: String = ""
    @State var password: String = ""
    @State var mobileValid = false
    @State var passwordValid = false
    
    @EnvironmentObject var userModel: UserModel
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack {
            // Avatar
            Image(systemName: "person.circle").font(Font.system(size: 70)).padding(.top, 50).padding(.bottom, 20)
            
            // Phone Number Field
            RoundCornerTextField(secureDisplay: false, title: "Phone Number", placeHolder: "", value: self.$mobile, valid: self.mobileValid, onReturn: {
                UIApplication.shared.endEditing()
            })
            .padding(.horizontal, 30).offset(x: 0, y: 10)
            
            // Password Field
            RoundCornerTextField(secureDisplay: true, title: "Password", placeHolder: "", value: self.$password, valid: self.passwordValid, onReturn: {
                UIApplication.shared.endEditing()
            })
            .padding(.horizontal, 30)
            
            // Links to 'sign up' or 'sms login'
            HStack {
                Button(action: {
                    self.restoreStates()
                    self.viewModel.layerType = .SMSLogin
                }) { () in
                    Text("SMS Login").font(Font.system(size: 12)).fontWeight(.medium).foregroundColor(.blue)
                }
                Spacer()
                Button(action: {
                    self.restoreStates()
                    self.viewModel.layerType = .Register
                }) { () in
                    Text("Sign Up").font(Font.system(size: 12)).fontWeight(.medium).foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 30).padding(.bottom, 5)
            
            // Login Button
            Button(action: {
                self.viewModel.login(mobile: self.mobile, password: self.password, userModel: self.userModel)
            }) { () in
                Text("LOGIN").font(Font.system(size: 20)).fontWeight(.medium)
            }
            .padding(.bottom, 30)
        }
    }
    
    func restoreStates() {
        self.mobile = ""
        self.password = ""
    }
}
