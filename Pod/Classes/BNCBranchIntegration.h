//
//  BNCBranchIntegration.h
//  Segment-Branch Integration
//
//  Created by Edward Smith on 1/29/18.
//  Copyright © 2018 Branch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Analytics/SEGIntegration.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNCBranchIntegration : NSObject<SEGIntegration>
- (instancetype)initWithSettings:(NSDictionary *)settings analytics:(SEGAnalytics *)analytics NS_SWIFT_NAME(init(setttings:analytics:));
@property(nonatomic, strong) NSDictionary *settings;
@end

NS_ASSUME_NONNULL_END
