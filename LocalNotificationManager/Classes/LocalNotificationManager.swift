//
//  LocalNotificationManager.swift
//  Registration
//
//  Created by Cristian Madrid on 2/22/17.
//  Copyright © 2017 Unicred Brasil. All rights reserved.
//

import UserNotifications
import UIKit

public class LocalNotificationManager {
    
    fileprivate var application: UIApplication?
    public let scheduler: LocalNotificationScheduler
    public let registrator: LocalNotificationRegister
    public let categoryIdentifier: String
    
    public init(application: UIApplication) {
        self.categoryIdentifier = Bundle.main.displayName ?? NSUUID().uuidString
        self.application = application
        self.registrator = LocalNotificationRegisterFactory.instantiate(application: application)
        self.scheduler = LocalNotificationSchedulerFactory.instantiate(categoryIdentifier: categoryIdentifier)
        
    }
}

fileprivate extension Bundle {
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}
