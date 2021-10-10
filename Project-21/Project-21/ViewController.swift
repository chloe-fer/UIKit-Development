//
//  ViewController.swift
//  Project-21
//
//  Created by Chloe Fermanis on 6/10/21.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }
    
    @objc func registerLocal() {
        
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
    }
    
    @objc func scheduleLocal() {
        
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = "Time to get up!"
        content.body = "Get up! Get up! Get up! "
        // content.categoryIdentifier = "cusotmIdentifier"
        
        content.categoryIdentifier = "alarm"

        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
                
    }
    
    func registerCategories() {
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        
        // Day 73 - Challenge 2: add a second category
        let remind = UNNotificationAction(identifier: "remind", title: "Remind me later ...", options: .foreground)
        
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, remind], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
        
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            
            // Day 73 - Challenge 1: show different instances of UIAlertController depending on action
            case UNNotificationDefaultActionIdentifier:
                // user swiped to unlock
                print("Swipe")
                showAlert(title: "Swipe")
                
            case "remind":
                // user tapped "Remind me latter"
                print("Remind")
                showAlert(title: "Expect another reminder.")
                scheduleLocal()
                             
            case "show":
                print("Show more information...")
                showAlert(title: "Show more information...")
                scheduleLocal()
                
            default:
                break
            }
        }
        completionHandler()
    }
    
    // Day 73 - Challenge 1: show different instances of UIAlertController depending on action
    func showAlert(title: String) {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }


}
