//
//  BNCBranchIntegrationFactory.m
//  Segment-Branch Integration
//
//  Created by Edward Smith on 1/29/18.
//  Copyright © 2018 Branch. All rights reserved.
//

#import "BNCBranchIntegrationFactory.h"
#import "BNCBranchIntegration.h"

@implementation BNCBranchIntegrationFactory

+ (instancetype)instance {
    static dispatch_once_t once = 0;
    static BNCBranchIntegrationFactory *sharedInstance = nil;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    return self;
}

- (id<SEGIntegration>)createWithSettings:(NSDictionary *)settings forAnalytics:(SEGAnalytics *)analytics {
    return [[BNCBranchIntegration alloc] initWithSettings:settings];
}

- (NSString *)key {
    return @"Branch Metrics";
}

@end
