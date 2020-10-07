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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
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
    
    
    //configure all data needed to schedule a notification, content to show, when to show and a request
    @objc func scheduleLocal() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current() // lets us post notifications to home screen
        center.removeAllPendingNotificationRequests()
        
        
        
        //notification content
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        
        //triggering the notification
        var dateComponent = DateComponents()
        dateComponent.hour = 10
        dateComponent.minute = 30
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true) //there are several triggers but this is the calendar notif trigger
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        //make a request which ties the request and the content together
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfor = response.notification.request.content.userInfo
        
        if let customData = userInfor["customData"] as? String {
            print("custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                print("Default identifier")
                
            case "show":
                print("show more info")
                
            default:
                break
            }
        }
        completionHandler()
    }
}

