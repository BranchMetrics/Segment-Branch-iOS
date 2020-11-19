//
//  BNCAppDelegate.m
//  Segment-Branch
//
//  Created by Derrick Staten on 11/10/2015.
//  Copyright (c) 2015 Derrick Staten. All rights reserved.
//

#import "BNCAppDelegate.h"
#import <Segment/SEGAnalytics.h>
#import "BNCBranchIntegrationFactory.h" // Import this file.

@implementation BNCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    SEGAnalyticsConfiguration *configuration =
        [SEGAnalyticsConfiguration configurationWithWriteKey:@"MlTmISmburwl2nN9o3NFpGfElujcfb0q"];
    
    // Add the Branch integration:
    [configuration use:[BNCBranchIntegrationFactory instance]];
    [SEGAnalytics setupWithConfiguration:configuration];
    [SEGAnalytics debug:YES];

    // Send some Segment events:
    [[SEGAnalytics sharedAnalytics] track:@"Hello World"];
    [[SEGAnalytics sharedAnalytics] group:@"segment"];
    [[SEGAnalytics sharedAnalytics] screen:@"home"];
    [[SEGAnalytics sharedAnalytics] identify:@"prateek"];
    [[SEGAnalytics sharedAnalytics] alias:@"f2prateek"];
    [[SEGAnalytics sharedAnalytics] flush];
    
    return YES;
}

@end
