//
//  ErrorHandlePlugin.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/3.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import Moya

class ErrorHandlePlugin: PluginType {
    let failureHandler: (String)->Void
    
    init(_ handler: @escaping (String)->Void) {
        self.failureHandler = handler
    }
    
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        
    }
}
