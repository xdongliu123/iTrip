//
//  UserModel.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/8.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import Foundation
import KeychainAccess

class UserModel {
    @Published var isLogin: Bool
    init() {
        let keychain = Keychain(service: "com.iTrip.app")
        if let token = keychain["user-token"], token.count > 0 {
            isLogin = true
        } else  {
            isLogin = false
        }
    }
}

extension UserModel: ObservableObject {
    
}
