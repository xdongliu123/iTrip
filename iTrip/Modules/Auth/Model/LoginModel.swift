//
//  LoginModel.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/6/24.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import Foundation
import KeychainAccess
import Combine
import Moya

final internal class LoginModel {
    func login(mobile: String, password: String, succsessHandler: @escaping ()->Void, failureHandler: @escaping (String)->Void) {
        let provider = MoyaProvider<AuthTarget>()
        provider.request(.login(mobile: mobile, password: password)) { result in
            if let ret = NetworkHelper.retrieveRetData(result: result, failureHandler: failureHandler) as? [String: Any] {
                guard let token = ret["token"] as? String else  {
                    return
                }
                self.saveToke(token)
                succsessHandler()
            }
        }
    }
    
    func smsLogin(mobile: String, code: String, succsessHandler: @escaping ()->Void, failureHandler: @escaping (String)->Void) {
        let provider = MoyaProvider<AuthTarget>()
        provider.request(.smslogin(mobile: mobile, code: code)) { result in
            if let ret = NetworkHelper.retrieveRetData(result: result, failureHandler: failureHandler) as? [String: Any] {
                guard let token = ret["token"] as? String else  {
                    return
                }
                self.saveToke(token)
                succsessHandler()
            }
        }
    }
    
    func register(mobile: String, password: String, code: String, succsessHandler: @escaping ()->Void, failureHandler: @escaping (String)->Void) {
        let provider = MoyaProvider<AuthTarget>()
        provider.request(.register(mobile: mobile, password: password, code: code)) { result in
            if let ret = NetworkHelper.retrieveRetData(result: result, failureHandler: failureHandler) as? [String: Any] {
                guard let token = ret["token"] as? String else  {
                    return
                }
                self.saveToke(token)
                succsessHandler()
            }
        }
    }
    
    func sendCheckCode(mobile: String, succsessHandler: @escaping ()->Void, failureHandler: @escaping (String)->Void) {
        let provider = MoyaProvider<AuthTarget>()
        provider.request(.authcode(mobile: mobile)) { result in
            if let ret = NetworkHelper.retrieveRetData(result: result, failureHandler: failureHandler) as? [String: Any] {
                guard let code = ret["code"] as? String else  {
                    return
                }
                print(code)
                succsessHandler()
            }
        }
    }
    
    // private methods
    func saveToke(_ token: String) {
        let keychain = Keychain(service: "com.iTrip.app")
        keychain["user-token"] = token
    }
}
