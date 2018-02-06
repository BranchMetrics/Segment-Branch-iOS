#import <Foundation/Foundation.h>
#import <Analytics/SEGIntegrationFactory.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNCBranchIntegrationFactory : NSObject<SEGIntegrationFactory>

+ (instancetype)instance;

@end

NS_ASSUME_NONNULL_END
