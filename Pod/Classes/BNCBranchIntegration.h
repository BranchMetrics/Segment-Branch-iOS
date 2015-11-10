#import <Foundation/Foundation.h>
#import <Analytics/SEGIntegration.h>

@interface BNCBranchIntegration : NSObject<SEGIntegration>

@property(nonatomic, strong) NSDictionary *settings;

- (id)initWithSettings:(NSDictionary *)settings;

@end
