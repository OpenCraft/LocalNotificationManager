//
//  LocalNotificationScheduler.swift
//  Registration
//
//  Created by Cristian Madrid on 2/23/17.
//  Copyright © 2017 Unicred Brasil. All rights reserved.
//

import UserNotifications
import UIKit

protocol LocalNotificationScheduler {
    func schedule(message: String, date: Date)
    func cleanNotifications()
}

class LocalNotificationSchedulerFactory {
    static func instantiate() -> LocalNotificationScheduler {
        if #available(iOS 10, *) {
            return LocalNotificationSchedulerNewestiOS()
        }
        return LocalNotificationSchedulerLegacyiOS()
    }
}

private let categoryIdentifier = "Registration"
private let title = "Unicred"
@available(iOS 10.0, *)
class LocalNotificationSchedulerNewestiOS: LocalNotificationScheduler {
    
    func schedule(message: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.categoryIdentifier = categoryIdentifier
        content.sound = UNNotificationSound.default()
        
        let center = UNUserNotificationCenter.current()
        center.add(getNotificationRequest(content: content, date: date))
    }
    
    func getNotificationRequest(content: UNMutableNotificationContent, date: Date) -> UNNotificationRequest {
        var dateComponents = DateComponents()
        dateComponents.hour = date.hour
        dateComponents.minute = date.minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        return UNNotificationRequest(identifier: categoryIdentifier, content: content, trigger: trigger)
    }
    
    func cleanNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [categoryIdentifier])
    }
}

@available(iOS 9, *)
@available(iOS 8, *)
class LocalNotificationSchedulerLegacyiOS: LocalNotificationScheduler {
    
    fileprivate var notification: UILocalNotification?
    
    func schedule(message: String, date: Date) {
        let localNotification = UILocalNotification()
        notification = localNotification
        
        localNotification.fireDate = date
        localNotification.timeZone = TimeZone.current
        localNotification.alertTitle = title
        localNotification.alertBody = message
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.category = categoryIdentifier
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    
    func cleanNotifications() {
        if let notification = notification {
            UIApplication.shared.cancelLocalNotification(notification)
        }
    }
}
