//
//  AppDelegate.swift
//  Fortune
//
//  Created by Edward Smith on 10/3/17.
//  Copyright © 2017 Branch. All rights reserved.
//

import UIKit
import Analytics
import Segment_Branch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions:[UIApplicationLaunchOptionsKey: Any]?
        ) -> Bool {
        // Initialize our app data source:
        AppData.shared.initialize()

        // Initialize Segment analytics:
        let configuration = SEGAnalyticsConfiguration(writeKey: "MlTmISmburwl2nN9o3NFpGfElujcfb0q")
        configuration.use(BNCBranchIntegrationFactory.instance())
        SEGAnalytics.debug(true)

        return true
    }

/* TODO:
    func application(_ application: UIApplication,
             continue userActivity: NSUserActivity,
                restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        Branch.getInstance().continue(userActivity)
        return true
    }

    func application(_ application: UIApplication,
                          open url: URL,
                           options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        Branch.getInstance().application(application, open: url, options: options)
        return true
    }
*/
}
