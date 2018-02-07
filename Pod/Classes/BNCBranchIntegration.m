//
//  BNCBranchIntegration.m
//  Segment-Branch Integration
//
//  Created by Edward Smith on 1/29/18.
//  Copyright © 2018 Branch. All rights reserved.
//

#import "BNCBranchIntegration.h"
#import <Branch/Branch.h>
#import <Analytics/SEGAnalyticsUtils.h>

@implementation BNCBranchIntegration

- (instancetype)initWithSettings:(NSDictionary *)settings {
    if (self = [super init]) {
        self.settings = settings ?: @{};
        NSString *branchKey = [self.settings objectForKey:@"branch_key"];
        [Branch getInstance:branchKey];
    }
    return self;
}

- (void)identify:(SEGIdentifyPayload *)payload {
    if (payload.userId != nil && [payload.userId length] != 0) {
        [[Branch getInstance] setIdentity:payload.userId];
        SEGLog(@"[[Branch getInstance] setIdentity:%@]", payload.userId);
    }
}

- (void)track:(SEGTrackPayload *)payload {
    [[Branch getInstance] userCompletedAction:payload.event withState:payload.properties];
    SEGLog(@"[[Branch getInstance] userCompletedAction:%@ withState:%@]", payload.event, payload.properties);
}

- (void)screen:(SEGScreenPayload *)payload {
    if (payload.name.length) {
        NSMutableDictionary *state = [NSMutableDictionary dictionary];
        [state addEntriesFromDictionary:payload.properties];
        if (payload.category) {
            [state setObject:payload.category forKey:@"category"];
        }
        NSString *actionName = [NSString stringWithFormat:@"viewed_screen_%@", payload.name];
        [[Branch getInstance] userCompletedAction:actionName withState:state];
        SEGLog(@"[[Branch getInstance] userCompletedAction:%@ withState:%@]", actionName, payload.properties);
    }
}

- (void)alias:(SEGAliasPayload *)payload {
    if (payload.theNewId.length) {
        [[Branch getInstance] setIdentity:payload.theNewId];
        SEGLog(@"[[Branch getInstance] setIdentity:%@]", payload.theNewId);
    }
}

- (void)reset {
    [[Branch getInstance] logout];
    SEGLog(@"[[Branch getInstance] logout]");
}

- (void)receivedRemoteNotification:(NSDictionary *)userInfo {
    [[Branch getInstance] handlePushNotification:userInfo];
    SEGLog(@"[[Branch getInstance] handlePushNotification:%@]", userInfo);
}


- (void)continueUserActivity:(NSUserActivity *)userActivity {
    [[Branch getInstance] continueUserActivity:userActivity];
    SEGLog(@"[[Branch getInstance] continueUserActivity:%@]", userActivity);
}

- (void)openURL:(NSURL *)url options:(NSDictionary *)options {
    [[Branch getInstance] handleDeepLink:url];
    SEGLog(@"[[Branch getInstance] handleDeepLink:%@]", url);
}

@end
