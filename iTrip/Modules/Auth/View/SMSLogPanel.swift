//
//  SMSLogPanel.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/6/27.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI

struct SMSLogPanel: View {
    @EnvironmentObject var userModel: UserModel
    @State var mobile: String = ""
    @State var code: String = ""
    @State var mobileValid = false
    @State var smsCodeValid = false
    
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
            
            // SMS Code Field
            HStack(alignment: .lastTextBaseline, spacing: 10) {
                RoundCornerTextField(secureDisplay: false, title: "SMS Code", placeHolder: "", value: self.$code, valid: self.smsCodeValid, onReturn: {
                    UIApplication.shared.endEditing()
                })
                if (viewModel.counterMode) {
                    Text(" \(viewModel.counter) ").fixedSize(horizontal: true, vertical: true).frame(width: 20, height: 20, alignment: .center).font(.system(size: 15)).foregroundColor(.blue).bordered()
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
            .padding(.horizontal, 30)
            
            // Link to normal 'sign in'
            HStack {
                Button(action: {
                    self.restoreStates()
                    self.viewModel.layerType = .Login
                }) { () in
                    Text("Sign In").font(Font.system(size: 12)).fontWeight(.medium).foregroundColor(.blue)
                }
                Spacer()
            }
            .padding(.horizontal, 30).padding(.vertical, 5)
            
            // Login Button
            Button(action: {
                self.viewModel.smsLogin(mobile: self.mobile, code: self.code, userModel: self.userModel)
            }) { () in
                Text("LOGIN").font(Font.system(size: 20)).fontWeight(.medium)
            }
            .padding(.bottom, 30)
        }
    }
    
    func restoreStates() {
        self.mobile = ""
        self.code = ""
        self.viewModel.stopCheckCodeCounter()
    }
}
