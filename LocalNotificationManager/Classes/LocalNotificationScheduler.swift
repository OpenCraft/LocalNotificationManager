//
//  LocalNotificationScheduler.swift
//  Registration
//
//  Created by Cristian Madrid on 2/23/17.
//  Copyright © 2017 Unicred Brasil. All rights reserved.
//

import UserNotifications
import UIKit

public protocol LocalNotificationScheduler {
    init(categoryIdentifier: String)
    func schedule(title: String, message: String, date: Date)
    func schedule(title: String, message: String)
    func cleanNotifications()
}

extension LocalNotificationScheduler {
    public func schedule(title: String, message: String) {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .second, value: 10, to: Date()) ?? Date()
        schedule(title: title, message: message, date: date)
    }
}

public class LocalNotificationSchedulerFactory {
    static func instantiate(categoryIdentifier: String) -> LocalNotificationScheduler {
        if #available(iOS 10, *) {
            return LocalNotificationSchedulerNewestiOS(categoryIdentifier: categoryIdentifier)
        }
        return LocalNotificationSchedulerLegacyiOS(categoryIdentifier: categoryIdentifier)
    }
}

@available(iOS 10.0, *)
public class LocalNotificationSchedulerNewestiOS: LocalNotificationScheduler {
    
    let categoryIdentifier: String
    
    public required init(categoryIdentifier: String) {
        self.categoryIdentifier = categoryIdentifier
    }
    
    public func schedule(title: String, message: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.categoryIdentifier = categoryIdentifier
        content.sound = UNNotificationSound.default()
        
        let center = UNUserNotificationCenter.current()
        center.add(generateNotificationRequest(content: content, date: date))
    }
    
    func generateNotificationRequest(content: UNMutableNotificationContent, date: Date) -> UNNotificationRequest {
        var dateComponents = DateComponents()
        dateComponents.hour = date.hour
        dateComponents.minute = date.minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        return UNNotificationRequest(identifier: categoryIdentifier, content: content, trigger: trigger)
    }
    
    public func cleanNotifications() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [categoryIdentifier])
    }
}

@available(iOS 9, *)
public class LocalNotificationSchedulerLegacyiOS: LocalNotificationScheduler {
    
    fileprivate var notifications = [UILocalNotification]()
    
    let categoryIdentifier: String
    
    public required init(categoryIdentifier: String) {
        self.categoryIdentifier = categoryIdentifier
    }
    
    public func schedule(title: String, message: String, date: Date) {
        let localNotification = UILocalNotification()
        notifications.append(localNotification)
        
        localNotification.fireDate = date
        localNotification.timeZone = TimeZone.current
        localNotification.alertTitle = title
        localNotification.alertBody = message
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.category = categoryIdentifier
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    
    public func cleanNotifications() {
        for notification in notifications {
            UIApplication.shared.cancelLocalNotification(notification)
        }
    }
}
