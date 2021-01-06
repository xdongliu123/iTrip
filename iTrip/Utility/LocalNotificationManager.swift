//
//  LocalNotificationManager.swift
//  iTrip
//
//  Created by Zoe Liu on 2021/1/3.
//  Copyright © 2021 iTrip Studio. All rights reserved.
//

import UserNotifications

class LocalNotificationManager {
    static func registerLocalNotification(title: String, body: String, dateTime: Date, nodeId: String) -> String {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        // content.categoryIdentifier = "yourIdentifier"
        content.userInfo = ["nodeId": nodeId] // You can retrieve this when displaying notification

        // Setup trigger time
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let triggerDate = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: dateTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        // Create request
        let uniqueID = UUID().uuidString // Keep a record of this if necessary
        let request = UNNotificationRequest(identifier: uniqueID, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        return uniqueID
    }
    
    static func removeLocalPendingNotifications(ids: [String]) {
        // pending notifications are notifications…that haven't fired yet
        guard ids.count > 0 else {
            return
        }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
    }
    
    static func removeLocalDeliveredNotifications(ids: [String]) {
        // displayed notifications are delivered notifications until the user interacts with the notification
        guard ids.count > 0 else {
            return
        }
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ids)
    }
}
