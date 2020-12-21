//
//  RegPanel.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/6/27.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI

struct RegPanel: View {
    @State var mobile: String = ""
    @State var code: String = ""
    @State var password: String = ""
    @State var confirmPass: String = ""
    
    @State var mobileValid = false
    @State var smsCodeValid = false
    @State var passwordValid = false
    @State var confirmPassValid = false
    
    @EnvironmentObject var userModel: UserModel
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack {
            // Phone Number Field
            RoundCornerTextField(secureDisplay: false, title: "Phone Number", placeHolder: "", value: self.$mobile, valid: self.mobileValid, onReturn: {
                UIApplication.shared.endEditing()
            })
            .padding(.horizontal, 30).padding(.top, 50).offset(x: 0, y: 10)
            
            // SMS Code Field
            HStack(alignment: .lastTextBaseline, spacing: 10) {
                RoundCornerTextField(secureDisplay: false, title: "SMS Code", placeHolder: "", value: self.$code, valid: self.smsCodeValid, onReturn: {
                    UIApplication.shared.endEditing()
                })
                if (self.viewModel.counterMode) {
                    Text(" \(self.viewModel.counter) ").fixedSize(horizontal: true, vertical: true).frame(width: 20, height: 20, alignment: .center).font(.system(size: 15)).foregroundColor(.blue).bordered()
                } else {
                    Button(action: {
                        self.viewModel.sendCheckCode(mobile: self.mobile)
                    }) { () in
                        HStack {
                            Image(systemName: "paperplane").font(Font.system(size: 10))
                            Text("Send").font(.system(size: 15))
                        }
                    }.bordered()
                }
            }
            .padding(.horizontal, 30).padding(.vertical, -10).offset(x: 0, y: 10)
            
            // Password Field
            RoundCornerTextField(secureDisplay: true, title: "Password", placeHolder: "", value: self.$password, valid: self.passwordValid, onReturn: {
                UIApplication.shared.endEditing()
            }).padding(.horizontal, 30).offset(x: 0, y: 10)
            
            // Confirm Password Field
            RoundCornerTextField(secureDisplay: true, title: "Confirm Password", placeHolder: "", value: self.$confirmPass, valid: self.confirmPassValid, onReturn: {
                UIApplication.shared.endEditing()
            }).padding(.horizontal, 30)
            
            // Go to sign in
            HStack {
                Spacer()
                Button(action: {
                    self.restoreStates()
                    self.viewModel.layerType = .Login
                }) { () in
                    Text("SIGN IN").font(Font.system(size: 12)).fontWeight(.medium).foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 30).padding(.bottom, 5)
            
            // Register action
            Button(action: {
                self.viewModel.register(mobile: self.mobile, password: self.password, confirmPass: self.confirmPass, code: self.code, userModel: self.userModel)
            }) { () in
                Text("REGISTER").font(Font.system(size: 20)).fontWeight(.medium)
            }
            .padding(.bottom, 30)
        }
    }
    
    func restoreStates() {
        self.mobile = ""
        self.code = ""
        self.password = ""
        self.confirmPass = ""
        self.viewModel.stopCheckCodeCounter()
    }
}
