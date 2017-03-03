//
//  LocalNotificationRegister.swift
//  Registration
//
//  Created by Cristian Madrid on 2/23/17.
//  Copyright © 2017 Unicred Brasil. All rights reserved.
//
import UserNotifications
import UIKit

protocol LocalNotificationRegister {
    init(application: UIApplication)
    func register() -> LocalNotificationRegisterFetch
    func application(didRegister notificationSettings: UIUserNotificationSettings)
}

class LocalNotificationRegisterFactory {
    
    static func instantiate(application: UIApplication) -> LocalNotificationRegister {
        if #available(iOS 10, *) {
            return LocalNotificationRegisterNewestiOS(application: application)
        }
        
        if #available(iOS 9, *) {
            return LocalNotificationRegisterLegacyiOS(application: application)
        } else {
            return LocalNotificationRegisterLegacyiOS(application: application)
        }
    }
}

class LocalNotificationRegisterBase: LocalNotificationRegister {
    internal func register() -> LocalNotificationRegisterFetch {
        fatalError("You must implement this function")
    }

    fileprivate var application: UIApplication?
    fileprivate let fetcher = LocalNotificationRegisterFetch()
    
    required init(application: UIApplication) {
        self.application = application
    }
    
    func application(didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types.contains(.alert) {
            self.fetcher.doSuccess()
        } else {
            self.fetcher.doFailure()
        }
    }
}

@available(iOS 9, *)
@available(iOS 8, *)
class LocalNotificationRegisterLegacyiOS: LocalNotificationRegisterBase {
    override func register() -> LocalNotificationRegisterFetch {
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        UIApplication.shared.registerForRemoteNotifications()
        return fetcher
    }
}

@available(iOS 10, *)
class LocalNotificationRegisterNewestiOS: LocalNotificationRegisterBase {
    override func register() -> LocalNotificationRegisterFetch {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .alert, .sound]) { granted, _ in
            if granted {
                self.fetcher.doSuccess()
            } else {
                self.fetcher.doFailure()
            }
        }
        application?.registerForRemoteNotifications()
        return fetcher
    }
}

class LocalNotificationRegisterFetch {
    
    private var onSuccessClosure: ((Void) -> Void)? = nil
    private var onFailureClosure: ((Void) -> Void)? = nil
    
    @discardableResult func onSuccess(success: @escaping (Void) -> Void) -> Self {
        onSuccessClosure = success
        return self
    }
    
    @discardableResult func onFailure(error: @escaping (Void) -> Void) -> Self {
        onFailureClosure = error
        return self
    }
    
    final fileprivate func doSuccess() {
        if let success = onSuccessClosure {
            success()
        }
    }
    
    final fileprivate func doFailure() {
        if let failure = onFailureClosure {
            failure()
        }
    }
}
