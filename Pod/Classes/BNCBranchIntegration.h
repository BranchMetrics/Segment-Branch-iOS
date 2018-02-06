#import <Foundation/Foundation.h>
#import <Analytics/SEGIntegration.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNCBranchIntegration : NSObject<SEGIntegration>

@property(nonatomic, strong) NSDictionary *settings;

- (instancetype)initWithSettings:(NSDictionary *)settings NS_SWIFT_NAME(init(setttings:));

@end

NS_ASSUME_NONNULL_END
