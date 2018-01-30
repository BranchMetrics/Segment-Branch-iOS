//
//  BNCBranchIntegration.h
//  Segment-Branch Integration
//
//  Created by Edward Smith on 1/29/18.
//  Copyright © 2018 Branch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Analytics/SEGIntegration.h>

@interface BNCBranchIntegration : NSObject<SEGIntegration>

- (NSObject<SEGIntegration>*_Nonnull)initWithSettings:(NSDictionary*_Nullable)settings;
@property(nonatomic, strong) NSDictionary*_Nullable settings;

@end
