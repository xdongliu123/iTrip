//
//  NetworkHelper.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/3.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import Foundation
import Moya

enum NetworkRetDataType {
    case json
    case binary
    case image
    case string
}

class NetworkHelper {
    static func retrieveRetData(result: Result<Moya.Response, MoyaError>, type: NetworkRetDataType = .json, failureHandler: (String)->Void) -> Any? {
        switch result {
        case let .success(reponse):
            if type == .image {
                if let image = try? reponse.mapImage() {
                    return image
                }
            } else if (type == .string) {
                if let str = try? reponse.mapString() {
                    return str
                }
            } else if (type == .binary) {
                return reponse.data
            } else if (type == .json) {
                if let retJson = try? reponse.mapJSON() as? [String: Any] {
                    if let status = retJson["status"] as? Int, status == 0 {
                        return retJson["data"]
                    } else {
                        failureHandler((retJson["message"] as? String) ?? "")
                        handleErrorStatus(ret: retJson)
                    }
                }
            }
        case let .failure(error):
            failureHandler(error.errorDescription ?? "")
        }
        return nil
    }

    private static func handleErrorStatus(ret: [String: Any] ) {
        if let status = ret["status"] {
            print(status);
        }
    }
}
