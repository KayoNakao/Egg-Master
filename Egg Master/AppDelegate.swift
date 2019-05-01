//
//  AppDelegate.swift
//  Egg Master
//
//  Created by 中尾 佳代 on 2019/02/28.
//  Copyright © 2019 Kayo Nakao. All rights reserved.
//

import UIKit
import UserNotifications

protocol AppDelegateDelegate {
    func getTimerRemainings(time: Double)
    func setTimerRemainings() -> Double
}

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var delegate : AppDelegateDelegate?
    var backgroundTaskID : UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
    let notificationId = "eggNotification"

    var timerLeft:Double?
    var date:Date?
    var isTimerOn = false{
        didSet {
            if !isTimerOn {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationId])
            }
        }
    }
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        //uncomment to keep running background
//        self.backgroundTaskID = application.beginBackgroundTask(){
//            [weak self] in
//            application.endBackgroundTask((self?.backgroundTaskID)!)
//            self?.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
//        }
    }

    
    func applicationDidEnterBackground(_ application: UIApplication) {
            
        if isTimerOn{
            
            timerLeft = delegate?.setTimerRemainings()

            createNotification()
            date = Date()
        }

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if (date != nil) {
            
            print("timerleft: ", timerLeft!)
            print("since now: ", date!.timeIntervalSinceNow)
            
            timerLeft = timerLeft! + date!.timeIntervalSinceNow
            
            print("timerleft2:", timerLeft!)
            if timerLeft! <= 0 {
                delegate?.getTimerRemainings(time: 0)
                
            }else{
                delegate?.getTimerRemainings(time: timerLeft!)
            }
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        //uncomment to keep running background
//        application.endBackgroundTask(self.backgroundTaskID)

        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationId])
        
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationId])
    }
    
    
    //MARK: - User Notification
    func createNotification(){
        
        // Create UNMutableNotificationContent
        let content = UNMutableNotificationContent()
        content.title = "It's Time!"
        content.body = "It is ready now."
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: "notification.mp3"))
        
        // Create UNTimeIntervalNotificationTrigger
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: self.timerLeft!, repeats: false)
        
        // Create UNNotificationRequest with identifier, content, trigger
        let request = UNNotificationRequest.init(identifier: notificationId, content: content, trigger: trigger)
        
        // Add request to UNUserNotificationCenter
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }
    
}

