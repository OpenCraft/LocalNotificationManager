//
//  LocalNotificationManager.swift
//  Registration
//
//  Created by Cristian Madrid on 2/22/17.
//  Copyright © 2017 Unicred Brasil. All rights reserved.
//

import UserNotifications
import UIKit

class LocalNotificationManager {
    
    fileprivate var application: UIApplication?
    let scheduler: LocalNotificationScheduler
    let registrator: LocalNotificationRegister
    
    init(application: UIApplication) {
        self.application = application
        self.scheduler = LocalNotificationSchedulerFactory.instantiate()
        self.registrator = LocalNotificationRegisterFactory.instantiate(application: application)
    }
}
