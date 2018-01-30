#import <Foundation/Foundation.h>
#import <Analytics/SEGIntegrationFactory.h>

@interface BNCBranchIntegrationFactory : NSObject<SEGIntegrationFactory>

+ (NSObject<SEGIntegrationFactory>*_Nonnull)instance;

@end
