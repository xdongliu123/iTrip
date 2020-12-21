//
//  LoginViewModel.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/6/24.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import Combine
import SwiftUI

enum AuthLayerType {
    case Login, Register, SMSLogin
}

class LoginViewModel: ObservableObject {
    private var model = LoginModel()
    @Published var layerType = AuthLayerType.Login
    @Published var showLoadingIndicator = false
    @Published var showPopupView = false
    @Published var popUpTip = ""
    @Published var counter = 60
    @Published var counterMode = false
    
    var timer: AnyCancellable? = nil
    var logoTitle: String {
        switch layerType {
        case .Login:
            return "SIGN IN"
        case .Register:
            return "SIGN UP"
        case .SMSLogin:
            return "SMS SIGN IN"
        }
    }
    
    func showToast(tip: String) {
        self.popUpTip = tip
        self.showPopupView = true
    }
    
    func login(mobile: String, password: String, userModel: UserModel) {
        if mobile.count > 0 && password.count > 0 {
            if mobile.isValMobile() {
                self.showLoadingIndicator = true
                self.model.login(mobile: mobile, password: password, succsessHandler: {
                    self.showLoadingIndicator = false
                    withAnimation(.spring()) {
                        userModel.isLogin.toggle()
                    }
                }, failureHandler: {msg in
                    self.showLoadingIndicator = false
                    self.showToast(tip: msg)
                })
            } else {
                self.showToast(tip: "手机号码格式不正确")
            }
        } else {
            self.showToast(tip: "手机号码和密码不能为空")
        }
    }
    
    func smsLogin(mobile: String, code: String, userModel: UserModel) {
        if mobile.count > 0 && code.count > 0 {
            if mobile.isValMobile() {
                self.showLoadingIndicator = true
                self.model.smsLogin(mobile: mobile, code: code, succsessHandler: {
                    self.showLoadingIndicator = false
                    withAnimation(.default) {
                        userModel.isLogin.toggle()
                    }
                }, failureHandler: {msg in
                    self.showLoadingIndicator = false
                    self.showToast(tip: msg)
                })
            } else {
                self.showToast(tip: "手机号码格式不正确")
            }
        } else {
            self.showToast(tip: "手机号码和验证码不能为空")
        }
    }
    
    func register(mobile: String, password: String, confirmPass: String, code: String, userModel: UserModel) {
        if mobile.count == 0 {
            self.showToast(tip: "手机号码不能为空")
        } else if (!mobile.isValMobile()) {
            self.showToast(tip: "手机号码格式不正确")
        } else if (code.count == 0) {
            self.showToast(tip: "验证码不能为空")
        } else if (password.count == 0) {
            self.showToast(tip: "密码不能为空")
        } else if (confirmPass.count == 0) {
            self.showToast(tip: "确认密码不能为空")
        } else if (confirmPass != password) {
            self.showToast(tip: "密码和确认密码不一致")
        } else {
            self.showLoadingIndicator = true
            self.model.register(mobile: mobile, password: password, code: code, succsessHandler: {
                self.showLoadingIndicator = false
                withAnimation(.spring()) {
                    userModel.isLogin.toggle()
                }
            }, failureHandler: {msg in
                self.showLoadingIndicator = false
                self.showToast(tip: msg)
            })
        }
    }
    
    func sendCheckCode(mobile: String) {
        if mobile.count == 0 {
            self.showToast(tip: "手机号码不能为空")
        } else if (!mobile.isValMobile()) {
            self.showToast(tip: "手机号码格式不正确")
        } else {
            self.showLoadingIndicator = true
            self.model.sendCheckCode(mobile: mobile, succsessHandler: {
                self.showLoadingIndicator = false
            }) { msg in
                self.showLoadingIndicator = false
                self.showToast(tip: msg)
            }
        }
    }
    
    func startCheckCodeCounter() {
        self.counterMode = true
        timer = Timer.publish(every: 1.0, on: .main, in: .default).autoconnect().scan(0) { counter, _ in counter + 1 }.sink(receiveValue: { [weak self] counter in
            if let strongSelf = self {
                strongSelf.counter = strongSelf.counter - 1
                if (strongSelf.counter == 0) {
                    strongSelf.counter = 60
                    strongSelf.counterMode = false
                    strongSelf.timer?.cancel()
                    strongSelf.timer = nil
                }
            }
        })
    }
    
    func stopCheckCodeCounter() {
        self.counterMode = false
        self.counter = 60
        if timer != nil {
            timer?.cancel()
            timer = nil
        }
    }
}
