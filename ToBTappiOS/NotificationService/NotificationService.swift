//
//  NotificationService.swift
//  NotificationService
//
//  Created by TapplockiOS on 2018/8/3.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
    
            
            let usermanger = UserDefaults(suiteName: "group.tapplockNotificaitonService.com")
            
            let userStr: String? = usermanger?.value(forKey: "user_saveKey") as? String
            
            if userStr == nil {
                return
            }
            

            let data = bestAttemptContent.userInfo as! [String: Any]
            
            let type = data["type"] as? String
            
            if type == "-1" {
                usermanger?.set(type, forKey: "NotificationType")
                usermanger?.removeObject(forKey: "NotificationContent")
                return
            }
            
            
            let dict = ["title": bestAttemptContent.title, "body": bestAttemptContent.body]
        
            var array = usermanger?.object(forKey: "NotificationContent") as? [[String: String]]

            
            if array != nil {
                array?.insert(dict, at: 0)
            } else {
                array = [dict]
            }

            usermanger?.set(array, forKey: "NotificationContent")
    
            
            
            
            contentHandler(bestAttemptContent)
            
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
