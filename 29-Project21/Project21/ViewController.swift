//
//  ViewController.swift
//  Project21
//
//  Created by diayan siat on 06/10/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(initialSchedule))
    }
    
    
    //need to request permission to send notification
    @objc func registerLocal() {
        
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            
            if granted {
                print("Yay")
            }else {
                print("D'oh!")
            }
            
        }
        
    }
    
    @objc func initialSchedule() {
        scheduleLocal(delaySeconds: 5)
    }
    
    //configure all data needed to schedule a notification, content to show, when to show and a request
    func scheduleLocal(delaySeconds: TimeInterval) {
        registerCategories()
        
        let center = UNUserNotificationCenter.current() // lets us post notifications to home screen
        center.removeAllPendingNotificationRequests()
        
        //notification content
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Late wake up call", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "The early bird catches the worm, but the second mouse gets the cheese", arguments: nil)
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz", "REMIND_ME": "Reminder"]
        content.sound = .default
        
        
        //triggering the notification
        //        var dateComponent = DateComponents()
        //        dateComponent.hour = 10
        //        dateComponent.minute = 30
        
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true) //there are several triggers but this is the calendar notif trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delaySeconds, repeats: false)
        
        //make a request which ties the request and the content together
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        // Define the custom actions.
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        
        let remindMeAction = UNNotificationAction(identifier: "REMIND_ACTION",
                                                  title: "Remind me later",
                                                  options: UNNotificationActionOptions(rawValue: 0))
        
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, remindMeAction], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfor = response.notification.request.content.userInfo
        
        if let customData = userInfor["customData"] as? String {
            print("custom data \(customData)")
        }
        
        if let meetingId = userInfor["REMIND_ME"] as? String {
            print("Remind me: \(meetingId)")
        }
        
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            let ac = UIAlertController(title: "Swipe", message: "The user swiped to unlock", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            
        case "show":
            let ac = UIAlertController(title: "Tell Me More", message: "The user tapped the \"Tell me more\" button", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            
        case "REMIND_ACTION":
            print("accept action")
            scheduleLocal(delaySeconds: 86400)
            
        default:
            break
        }
        
        completionHandler()
    }
    
}

