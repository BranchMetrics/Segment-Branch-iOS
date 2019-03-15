[![Platform](https://img.shields.io/cocoapods/p/Segment-Branch.svg?style=flat)](http://cocoapods.org/pods/Segment-Branch)
[![Version](https://img.shields.io/cocoapods/v/Segment-Branch.svg?style=flat)](http://cocoapods.org/pods/Segment-Branch)
[![License](https://img.shields.io/cocoapods/l/Segment-Branch.svg?style=flat)](http://cocoapods.org/pods/Segment-Branch)

# Segment-Branch

Easily add Branch deep linking and analytics to your Segment-based app with this Segment integration.

New to Branch or deep linking? Start here: [All about Branch deep linking.](https://branch.io/what-is-deep-linking/)

The Segment-Branch integration adds:

* Deep linking capabilities to your app.
* Segment events are automatically tracked and analyzed in the Branch dashboard too, 
  so you can measure the effectiveness of your deep linked content and marketing campaigns.
* Use other Branch features, like referrals or automatic app content listing in Spotlight.

### Questions?

* Segment support: [Segment Support](https://segment.com/contact)
* Branch Support: [Branch support](https://support.branch.io/support/home)


### Examples

See the [Fortune Example App](https://github.com/BranchMetrics/Segment-Branch-iOS/tree/master/Examples/Fortune#fortune-example)
for an example of using the Segment-Branch SDK in your app.

## Installation and Usage Details

The installation has five steps:

1. Add the Segment-Branch integration to your CocoaPod pod file.
2. Add some code to your AppDelegate:
   - Tell Segment to use the Branch integration when your application launches.
   - Pass along URLs to Segment in your `application:continueUserActivity:restorationHandler:` method.
   - Pass along URLs to Segment in your `application:openURL:options:` method.
3. Configure your app in the Branch dashboard: [Branch Dashboard.](https://docs.branch.io/pages/dashboard/integrate/)
4. Configure your app to handle universal URLs: [Universal Links.](https://docs.branch.io/pages/apps/ios/#configure-associated-domains)
5. Configure your app to handle app scheme URLs: [App Schemes.](https://docs.branch.io/pages/apps/ios/#configure-infoplist)


## Step 1: Add the Segment-Branch integration to your CocoaPod pod file

To install the Segment-Branch integration, add this line to your [CocoaPods](http://cocoapods.org) `Podfile`:

```ruby
pod 'Segment-Branch'
```

so that your pod file looks something like:

```ruby
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '8.0'
use_frameworks!

target 'Fortune' do
  pod 'Segment-Branch'
end
```

Then run `pod install` from the command line to install the new pod.

## Step 2: Add some code to your AppDelegate

Update your app delegate to tell Segment to use Branch, then add some code to pass deep link notifications to Segment which will in turn pass them to the Branch SDK.

**Objective-C**

```objc
#import <Segment/Analytics>
#import <Segment-Branch/BNCBranchIntegrationFactory.h>

...

// Add Branch to your Segment configuration and set a deep link handler block:
- (BOOL)application:(UIApplication *)application
        didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    SEGAnalyticsConfiguration *config = [SEGAnalyticsConfiguration configurationWithWriteKey:@"YOUR_WRITE_KEY"];

    // Use Branch:
    [config use:[BNCBranchIntegrationFactory instance]];
    [SEGAnalytics setupWithConfiguration:config];

    // Add a handler for Branch deep links:
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(branchDidStartSession:)
                                                 name:BranchDidStartSessionNotification
                                               object:nil];
}

// Handle universal links: Pass your user activity to Segment in your `continueUserActivity:` method.
- (BOOL)application:(UIApplication *)application
continueUserActivity:(NSUserActivity *)userActivity
 restorationHandler:(void (^)(NSArray *))restorationHandler {
    [[SEGAnalytics shared] continueUserActivity:userActivity];
    return YES;
}

// Handle scheme links: Pass the URL to Segment in your `openURL:` method.
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    [[SEGAnalytics shared] openURL:url options:options];
    return YES;
}

// Add this to read the deep link data when it is received
- (void)branchDidStartSession:(NSNotification *) notification {
    if ([[notification userInfo] objectForKey:BranchErrorKey] != nil) {
        // An error occurred
        return;
    }
    BranchLinkProperties linkProps = [[notification userInfo] objectForKey:BranchLinkPropertiesKey];
    if (linkProps != nil) {
        // deep link with data
    }
    return;
}

```

**Swift**

```swift
import Analytics
import Segment_Branch

...

class AppDelegate ...

    // Add Branch to your Segment configuration and set a deep link handler block:
    func application(_ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions:[UIApplicationLaunchOptionsKey: Any]?
        ) -> Bool {
    let configuration = SEGAnalyticsConfiguration(writeKey: "YOUR_WRITE_KEY")
    configuration.use(BNCBranchIntegrationFactory.instance())
    SEGAnalytics.setup(with: configuration)

    // Register deep link notification handler:
    NotificationCenter.default.addObserver(
            self,
            selector: #selector(branchDidStartSession(notification:),
            name: NSNotification.Name.BranchDidStartSession,
            object: nil
    )

    // Handle universal links: Pass your user activity to Segment in your `continueUserActivity:` method.
    @objc func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([Any]?) -> Void
    ) -> Bool {
        SEGAnalytics.shared().continue(userActivity)
        return true
    }

    // Add this so Branch can handle app schemes like `myapp://open?link...`:
    @objc func application(_ app: UIApplication,
        open url: URL,
        options: [UIApplicationOpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        SEGAnalytics.shared().open(url, options: options)
        return true
    }

    // Add this to read the deep link data when it is received
    @objc func branchDidStartSession(notification: Notification) {
        if (notification.userInfo?[BranchErrorKey] as? Error) != nil {
            // An error occurred
            return
        }
        if let linkprops = notification.userInfo?[BranchLinkPropertiesKey] as? BranchLinkProperties {
            let deepLinkData = linkprops.controlParams as NSDictionary?
            // handle your deep link
        }
        return
    }
```

## Steps 3 through 5

Refer to the Branch documentation for setting up the Branch dashboard and configuring your app
to accept URLs from iOS.

3. Configure your app in the Branch dashboard: [Branch Dashboard.](https://docs.branch.io/pages/dashboard/integrate/)
4. Configure your app to handle universal links: [Universal Links.](https://docs.branch.io/pages/apps/ios/#configure-associated-domains)
5. Configure your app to handle app schemes: [App Schemes.](https://docs.branch.io/pages/apps/ios/#configure-infoplist)


## Author

Branch Metrics, support@branchmetrics.io

## License

Segment-Branch is available under the MIT license. See the LICENSE file for more info.
