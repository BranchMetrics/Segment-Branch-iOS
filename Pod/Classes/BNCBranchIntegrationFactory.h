//
//  BNCBranchIntegrationFactory.h
//  Segment-Branch Integration
//
//  Created by Edward Smith on 1/29/18.
//  Copyright © 2018 Branch. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef SWIFT_PACKAGE
@import Segment;
#else
#import <Segment/SEGIntegrationFactory.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface BNCBranchIntegrationFactory : NSObject<SEGIntegrationFactory>
+ (instancetype)instance;
@end

NS_ASSUME_NONNULL_END
