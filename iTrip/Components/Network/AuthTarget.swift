//
//  AuthTarget.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/3.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import Moya
import Foundation

enum AuthTarget {
    case login(mobile: String, password: String)
    case smslogin(mobile: String, code: String)
    case register(mobile: String, password: String, code: String)
    case authcode(mobile: String)
}

extension AuthTarget: TargetType {
    var sampleData: Data {
        return Data()
    }
    
    var baseURL: URL {
        return URL(string: "http://127.0.0.1:8000/auth/")!
    }
    
    var path: String {
        switch self {
        case .login(_, _):
            return "login/"
        case .smslogin(_, _):
            return "smslogin/"
        case .register(_, _, _):
            return "register/"
        case .authcode(_):
            return "authcode/"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Task {
        switch self {
        case let .login(mobile, password):
            return .requestParameters(parameters: ["mobile": mobile, "password": password], encoding: JSONEncoding.default)
        case let .smslogin(mobile, code):
            return .requestParameters(parameters: ["mobile": mobile, "code": code], encoding: JSONEncoding.default)
        case let .register(mobile, password, code):
            return .requestParameters(parameters: ["mobile": mobile, "password": password, "code": code], encoding: JSONEncoding.default)
        case let .authcode(mobile):
            return .requestParameters(parameters: ["mobile": mobile], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Accept": "application/json", "Content-Type": "application/json"]
    }
}
