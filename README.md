[![Version](https://img.shields.io/cocoapods/v/Segment-Branch.svg?style=flat)](http://cocoapods.org/pods/Segment-Branch)
[![License](https://img.shields.io/cocoapods/l/Segment-Branch.svg?style=flat)](http://cocoapods.org/pods/Segment-Branch)
[![Platform](https://img.shields.io/cocoapods/p/Segment-Branch.svg?style=flat)](http://cocoapods.org/pods/Segment-Branch)

# Segment-Branch

Easily add Branch deep linking and analytics to your Segment-based app with this Segment integration.

New to Branch or deep linking? Start here: [All about Branch deep linking.](https://branch.io/what-is-deep-linking/)

## Examples

See the [Fortune Example App](https://github.com/BranchMetrics/Segment-Branch-iOS/tree/master/Examples/Fortune)
for an example of using the Segment-Branch SDK in your app.

## Installation and Usage Details

The installation has seven steps:

1. Add the Segment-Branch integration to your CocoaPod pod file.
2. Tell Segment to use the Branch integration when your application launches.
3. Pass along URLs to Segment in your `application:continueUserActivity:restorationHandler:` method.
4. Pass along URLs to Segment in your `application:openURL:options:` method.
5. Configure your app in the Branch dashboard: [Branch Dashboard.](https://docs.branch.io/pages/dashboard/integrate/)
6. Configure your app to handle universal links: [Universal Links.](https://docs.branch.io/pages/apps/ios/#configure-associated-domains)
7. Configure your app to handle app schemes: [App Schemes.](https://docs.branch.io/pages/apps/ios/#configure-infoplist)


### Step 1: Add the Segment-Branch integration to your CocoaPod pod file

To install the Segment-Branch integration, add this line to your [CocoaPods](http://cocoapods.org) `Podfile`:

```ruby
pod "Segment-Branch"
```

Then run `pod install` from the command line to install the new pod.

### Step 2: Tell Segment to use the Branch integration when your application launches

Register the Branch integration with Segment. You'll need to import the Branch integration in your
`AppDelegate` and add the following lines in your `application:didFinishLaunchingWithOptions:` method:

**Objective-C**

```objc
#import <Segment/Analytics>
#import <Segment-Branch/BNCBranchIntegrationFactory.h>
.
.
.
- (BOOL)application:(UIApplication *)application
        didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    SEGAnalyticsConfiguration *config = [SEGAnalyticsConfiguration configurationWithWriteKey:@"YOUR_WRITE_KEY"];
    [config use:[BNCBranchIntegrationFactory instance]];
    [SEGAnalytics setupWithConfiguration:config];
}
```

**Swift**

```
import Analytics
import Segment_Branch
.
.
.
    func application(_ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions:[UIApplicationLaunchOptionsKey: Any]?
        ) -> Bool {
    let configuration = SEGAnalyticsConfiguration(writeKey: "YOUR_WRITE_KEY")
    configuration.use(BNCBranchIntegrationFactory.instance())
    SEGAnalytics.setup(with: configuration)
}
```

### Step 3: Pass along URLs to Segment in your `continueUserActivity:` method

In your `application:continueUserActivity:restorationHandler:` method, add:

**Object-C**

```objc
- (BOOL)application:(UIApplication *)application
continueUserActivity:(NSUserActivity *)userActivity
 restorationHandler:(void (^)(NSArray *))restorationHandler {
    [[SEGAnalytics shared] continueUserActivity:userActivity];
    return YES;
}
```

**Swift**

```swift
@objc func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([Any]?) -> Void
) -> Bool {
    SEGAnalytics.shared().continue(userActivity)
    return true
}
```

### Step 4: Pass along URLs to Segment in your `openURL:` method

In your `application:openURL:options:` method, add:

**Objective-C**

```
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    [[SEGAnalytics shared] openURL:url options:options];
    return YES;
}
```

**Swift**

```swift
// Add this so Branch can handle app schemes like `myapp://open?link...`:
@objc func application(_ app: UIApplication,
    open url: URL,
    options: [UIApplicationOpenURLOptionsKey : Any] = [:]
) -> Bool {
    SEGAnalytics.shared().open(url, options: options)
    return true
}
```

### Steps 5 through 7

Refer to the Branch documentation for setting up the Branch dashboard and configuring your app
to accept URLS from iOS.

5. Configure your app in the Branch dashboard: [Branch Dashboard.](https://docs.branch.io/pages/dashboard/integrate/)
6. Configure your app to handle universal links: [Universal Links.](https://docs.branch.io/pages/apps/ios/#configure-associated-domains)
7. Configure your app to handle app schemes: [App Schemes.](https://docs.branch.io/pages/apps/ios/#configure-infoplist)


## Author

Branch Metrics, support@branchmetrics.io

## License

Segment-Branch is available under the MIT license. See the LICENSE file for more info.
