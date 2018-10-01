//
//  AppDelegate.swift
//  LifeHacks
//
//  Created by  Kostantin Zarubin on 06.09.2018.
//  Copyright © 2018  Kostantin Zarubin. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookCore
import FacebookLogin
import YandexMobileMetrica
import FacebookShare

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        YMMYandexMetrica.activate(with: YMMYandexMetricaConfiguration.init(apiKey: "e60a2b16-838a-40b3-ac75-c89470773f1a")!)
        
        SubscriptionManager.shared.checkSubscriptionStatus()
        
        if UserDefaults.standard.object(forKey: "OnOnboarding") as? Int == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "TabBar")
        }
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEventsLogger.activate(application)
    }
}

