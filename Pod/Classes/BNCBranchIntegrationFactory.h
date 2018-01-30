//
//  BNCBranchIntegrationFactory.h
//  Segment-Branch Integration
//
//  Created by Edward Smith on 1/29/18.
//  Copyright © 2018 Branch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Analytics/SEGIntegrationFactory.h>

@interface BNCBranchIntegrationFactory : NSObject<SEGIntegrationFactory>

+ (NSObject<SEGIntegrationFactory>*_Nonnull)instance;

@end
