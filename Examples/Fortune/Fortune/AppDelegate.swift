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

// Initialize Segment analytics:
var MyAnalytics: Analytics = {
    let configuration = AnalyticsConfiguration(writeKey: "6ViWbAkMJGarxYDMiDkrn2BQoeYqrbIm")
    configuration.use(BNCBranchIntegrationFactory.instance())
    configuration.trackApplicationLifecycleEvents = true
    
    Analytics.setup(with: configuration)
    return Analytics.shared()
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
        //Analytics.Analytics.debug(true)

        // Initialize and enable analytics:
        MyAnalytics.enable()
        
        return true
    }

    // Add this so Branch can handle deep links when the app is in the background:
    @objc func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([Any]?) -> Void
    ) -> Bool {
        MyAnalytics.continue(userActivity)
        return true
    }

    // Add this so Branch can handle app schemes like `myapp://open?link...`:
    @objc func application(_ app: UIApplication,
        open url: URL,
        options: [UIApplicationOpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        MyAnalytics.open(url, options: options)
        return true
    }
}
