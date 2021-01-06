//
//  PushNotificationManager.swift
//  Recipient
//
//  Created by Zoe Liu on 2019/5/13.
//  Copyright © 2019 Everbridge, Inc. All rights reserved.
//

import UserNotifications
import UIKit
import PushKit

typealias RemotePush_TypeJudge_Block = ([AnyHashable : Any]) -> Bool
typealias RemotePush_WillPresent_Block = ([AnyHashable : Any]) -> UNNotificationPresentationOptions
typealias RemotePush_DidPresent_Block = ([AnyHashable : Any]) -> Void

class PushNotificationManager: NSObject {
    
    @objc public static var `default` = PushNotificationManager()
    
    private var remotePushHandlers:[String : (RemotePush_TypeJudge_Block, RemotePush_WillPresent_Block, RemotePush_DidPresent_Block)] = [:]
    @objc var deviceToken: String?
    
    @objc func registerAPNService() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
            if !granted {
                if let error = error {
                    print("Push notification failed to request authorizations with error: \(error)")
                } else {
                    print("Push notification failed to request authorizations with unknown reason")
                }
            } else {
                PushNotificationUtility.registerPushNotifications()
            }
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    @objc func registerPushKitService() {
        let pushRegistry = PKPushRegistry(queue: DispatchQueue.main)
        pushRegistry.delegate = self
        pushRegistry.desiredPushTypes = [PKPushType.voIP]
    }
    
    func registerRemotePush(_ category: String,
                    condition handler0: @escaping RemotePush_TypeJudge_Block,
                  willPresent handler1: @escaping RemotePush_WillPresent_Block,
                   didPresent handler2: @escaping RemotePush_DidPresent_Block) {
        remotePushHandlers[category] = (handler0, handler1, handler2)
    }
}

extension PushNotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        for (_, (handler0, handler1, _)) in remotePushHandlers {
            let ret = handler0(notification.request.content.userInfo)
            if ret {
                completionHandler(handler1(notification.request.content.userInfo))
                break
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        for (_, (handler0, _, handler2)) in remotePushHandlers {
            let ret = handler0(response.notification.request.content.userInfo)
            if ret {
                handler2(response.notification.request.content.userInfo)
                break
            }
        }
        completionHandler()
    }
}

extension PushNotificationManager: PKPushRegistryDelegate {
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        let device = NSData(data: credentials.token)
        let deviceToken = device.description.replacingOccurrences(of:"<", with:"").replacingOccurrences(of:">", with:"").replacingOccurrences(of:" ", with:"")
        print("PushKit device token received: \(deviceToken)")
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        print("PushKit push received with payload \(String(describing:payload.dictionaryPayload))")
    }
}
