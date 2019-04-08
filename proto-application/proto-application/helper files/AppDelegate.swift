//
//  AppDelegate.swift
//  proto-application
//
//  Created by Hessel Bierma on 16/10/2018.
//  Copyright © 2018 S.A. Proto. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var i: Int = 0
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let storyboardLaunch = UIStoryboard(name: "LaunchScreen", bundle: nil)
        self.window = UIWindow()
        let logIn = storyboard.instantiateViewController(withIdentifier: "LogIn")
        let home = storyboard.instantiateViewController(withIdentifier: "Tab")
        let launch = storyboardLaunch.instantiateViewController(withIdentifier: "launch")
        
        if (keychain.get("access_token") ?? "").isEmpty{
            print("not logged in")
            self.window?.rootViewController = logIn
        }else{
            tryAccessToken(completion: {completion in
                if completion{
                    self.window?.rootViewController = home
                    print("checked, still active")
                }else{
                    tokenRequest(token: keychain.get("refresh_token")!, completion: { completion in
                        if completion{
                            self.window?.rootViewController = home
                            print("checked, refreshed token")
                        }else{
                            self.window?.rootViewController = logIn
                            print("checked, tried to refresh but failed.")
                        }
                    })
                }
            })
            if ((self.window?.rootViewController) == nil){
                print("check not finished yet")
                self.window?.rootViewController = launch
            }
        }
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //retrieveProtubeToken()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

