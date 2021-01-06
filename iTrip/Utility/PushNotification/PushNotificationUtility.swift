//
//  PushNotificationUtility.swift
//  Recipient
//
//  Created by Zoe Liu on 2019/5/14.
//  Copyright © 2019 Everbridge, Inc. All rights reserved.
//

import UserNotifications

class PushNotificationUtility: NSObject {
    
    @objc static func handleRemoteDeviceToken(token: Data) {
        let deviceToken = token.reduce("") { $0 + String(format: "%02x", $1) }
        let oldToken = UserDefaults.standard.string(forKey: "deviceToken")
        guard oldToken != deviceToken else {
            return
        }
        UserDefaults.standard.setValue(deviceToken, forKey: "deviceToken")
        UserDefaults.standard.synchronize()
        PushNotificationManager.default.deviceToken = deviceToken
        
        // send deviceToken to Provider
    }
    
    @objc static func registerPushNotifications() {
        registerMessagePushNotification()
    }
    
    static func registerMessagePushNotification() {
        PushNotificationManager.default.registerRemotePush("NotificationPush", condition: { (userInfo) -> Bool in
            if let _ = userInfo["messageId"] as? String {
                if let resourceType = userInfo["resourceType"] as? String, resourceType == "crisisTaskList" {
                    return false
                }
                if let resourceType = userInfo["resourceType"] as? String, resourceType == "crisisDocument" {
                    return false
                }
                if let resourceType = userInfo["resourceType"] as? String, resourceType == "crisisDashboard" {
                    return false
                }
                return true
            }
            return false
        }, willPresent: { (userInfo) -> UNNotificationPresentationOptions in
            return [.badge, .alert, .sound]
        }) { (userInfo) in
            
        }
    }
}
