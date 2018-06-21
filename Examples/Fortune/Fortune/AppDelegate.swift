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
var Analytics: SEGAnalytics = {
    let configuration = SEGAnalyticsConfiguration(writeKey: "6ViWbAkMJGarxYDMiDkrn2BQoeYqrbIm")
    configuration.use(BNCBranchIntegrationFactory.instance())
    configuration.trackApplicationLifecycleEvents = true
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

    // Add this so Branch can handle deep links when the app is in the background:
    @objc func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([Any]?) -> Void
    ) -> Bool {
        return Branch.getInstance().continue(userActivity)
    }
}
