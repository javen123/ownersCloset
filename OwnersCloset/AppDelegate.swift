//
//  AppDelegate.swift
//  CabTrack2.1
//
//  Created by Jim Aven on 4/9/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import UIKit
import Parse
import Bolts

//Globals

var myGuestPlacesArray = [AnyObject]()
var myPlaceResArray = [AnyObject]()
var mapCoord:(Double, Double)!
var sendGuestNotification = false
var sendOwnerNotification = false
var purchased = false
var needToPurchase = false


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        var options = launchOptions
        
        if options == nil {
            options = ["":""]
        }
        
        // set up parse database
        Parse.setApplicationId("xVkne0YKYbBUaoCcBfdD7yn9KcHdSVE5psmRurQ6", clientKey: "NbRww4hbh2F4v8sp6SL3mhMpl17iHSpxextDVQMC")
        
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(options!)
        
        // Set up psuch notifications
        
        let userNotificationTypes = (UIUserNotificationType.Alert |
            UIUserNotificationType.Badge |
            UIUserNotificationType.Sound);
        
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        // direct user to correct VC
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var initialViewController:UIViewController
        
        if curUser() != nil {
            initialViewController = storyboard.instantiateViewControllerWithIdentifier("entryVC") as! UIViewController
            
            fetchUserOwnerPlaces()
        }
        else {
            initialViewController = storyboard.instantiateViewControllerWithIdentifier("loginVC") as! UIViewController
        }
        
        // check for 30 day trial period expiration
        isReadyToPurchase()
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }
    
}

