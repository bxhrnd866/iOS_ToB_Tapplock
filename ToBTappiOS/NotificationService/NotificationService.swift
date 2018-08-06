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
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            
            
            
            let us = UserDefaults(suiteName: "group.tapplockNotificaitonService.com")
            
            let dict = self.bestAttemptContent?.userInfo as? [String: Any]
            
            if dict != nil {
                us?.set(dict, forKey: "cuncudict")
            }
            us?.set("22222", forKey: "model")
            
            
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
