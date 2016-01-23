//
//  AppDelegate.swift
//  Talk2Cook
//
//  Created by David Keller on 22.01.16.
//  Copyright © 2016 PennApps XIII. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    //This is to call in the Houndify dictionary and pull in the client ID and KEY
    var clientId: String? {
        get {
            guard let path = NSBundle.mainBundle().pathForResource("Configuration", ofType: "plist"), let configuration = NSDictionary(contentsOfFile: path) else { return nil }
            print(configuration);
            return configuration["Houndify"]?["client id"] as? String
        }
    }
    
    var clientKey: String? {
        get {
            guard let path = NSBundle.mainBundle().pathForResource("Configuration", ofType: "plist"), let configuration = NSDictionary(contentsOfFile: path) else { return nil }
            
            return configuration["Houndify"]?["client key"] as? String
        }
    }


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if let clientIDcheck = clientId, let clientKeycheck = clientKey {
            //Reference code from SDK documentation
            //[Hound setClientID:@"<INSERT YOUR CLIENT ID>"];
            //[Hound setClientKey:@"<INSERT YOUR CLIENT KEY>"];
            Hound.setClientID(clientIDcheck)
            Hound.setClientKey(clientKeycheck)
        }
        
        return true
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
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Split view

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? RecipeViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }

}

