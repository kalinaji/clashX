//
//  NSUserNotificationCenter+Extension.swift
//  ClashX
//
//  Created by CYC on 2018/8/6.
//  Copyright © 2018年 yichengchen. All rights reserved.
//

import Cocoa

extension NSUserNotificationCenter {
    func post(title:String,info:String,identifier:String? = nil) {
        let notification = NSUserNotification()
        notification.title = title
        notification.informativeText = info
        if identifier != nil {
            notification.userInfo = ["identifier":identifier!]
        }
        self.delegate = UserNotificationCenterDelegate.shared
        self.deliver(notification)
    }
    
    func postGenerateSimpleConfigNotice() {
        self.post(title: "No External-controller specified in config file!", info: "We have replace current config with a simple config with external-controller specified!")
    }
    
    func postConfigFileChangeDetectionNotice() {
        self.post(title: "Config file have been changed", info: "Tap to reload config",identifier:"postConfigFileChangeDetectionNotice")

    }
    
}

class UserNotificationCenterDelegate:NSObject,NSUserNotificationCenterDelegate {
    static let shared = UserNotificationCenterDelegate()
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        switch notification.userInfo?["identifier"] as? String {
        case "postConfigFileChangeDetectionNotice":
            NotificationCenter.default.post(Notification(name: kShouldUpDateConfig))
            center.removeAllDeliveredNotifications()
        default:
            break
        }
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
}
