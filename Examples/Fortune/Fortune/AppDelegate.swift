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
import Branch

// Initialize Segment analytics
var Analytics: SEGAnalytics = {
    //Branch.getInstance().initSession(launchOptions: launchOptions) // Initialize Branch
    let configuration = SEGAnalyticsConfiguration(writeKey: "MJ0oYt38lzMKtdk5uPjXbpo7JOrlTJQP")
    configuration.use(BNCBranchIntegrationFactory.instance())
    configuration.trackApplicationLifecycleEvents = true
    configuration.recordScreenViews = true
    SEGAnalytics.setup(with: configuration)
    return SEGAnalytics.shared()
} ()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions:[UIApplicationLaunchOptionsKey: Any]?
        ) -> Bool {
        // Initialize our app data source:
        AppData.shared.initialize()

        // Turn on all the debug output for testing:
        BNCLogSetDisplayLevel(.all)
        SEGAnalytics.debug(true)

        // Initialize and enable analytics:
        Analytics.enable()
        
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
