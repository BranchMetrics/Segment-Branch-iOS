//
//  BNCBranchIntegration.m
//  Segment-Branch Integration
//
//  Created by Edward Smith on 1/29/18.
//  Copyright © 2018 Branch. All rights reserved.
//

#import "BNCBranchIntegration.h"
#import <Branch/Branch.h>
#import <Branch/BNCPreferenceHelper.h>
#import <Segment/SEGAnalytics.h>
#import <Segment/SEGAnalyticsUtils.h>


@implementation BNCBranchIntegration

- (instancetype)initWithSettings:(NSDictionary *)settings analytics:(SEGAnalytics *)analytics {
    self = [super init];
    if (!self) return self;
    self.settings = settings ?: @{};
    NSString *branchKey = [self.settings objectForKey:@"branch_key"];
    [Branch setBranchKey:branchKey];
    [[Branch getInstance] registerPluginName:@"Segment - iOS" version:@"0.1.25"];
    
    [[Branch getInstance] dispatchToIsolationQueue:^{
        NSString *segmentID = [analytics getAnonymousId];
        if (segmentID.length) {
            [[BNCPreferenceHelper preferenceHelper] setRequestMetadataKey:@"$segment_anonymous_id" value:segmentID];
        }
    }];
   
    return self;
}

#pragma mark - Event Utilities

// These methods translate Segment events to Branch events.
//
// See https://segment.com/docs/spec/ecommerce/v2/ for the details of the Segment standard fields.

+ (NSString*) branchEventFromSegmentEventName:(NSString*)segmentEventName {
    id<NSObject> const kNull = [NSNull null];

    NSDictionary *eventDictionary = @{
        @"Checkout Step Completed":         kNull,
        @"Products Searched":               BranchStandardEventSearch,
        @"Product Viewed":                  BranchStandardEventViewItem,
        @"Product Added to Wishlist":       BranchStandardEventAddToWishlist,
        @"Product List Filtered":           kNull,
        @"Payment Info Entered":            BranchStandardEventAddPaymentInfo,
        @"Product Reviewed":                BranchStandardEventRate,
        @"Product List Viewed":             BranchStandardEventViewItems,
        @"Order Completed":                 BranchStandardEventPurchase,
        @"Wishlist Product Added to Cart":  kNull,
        @"Product Removed from Wishlist":   kNull,
        @"Coupon Removed":                  kNull,
        @"Order Cancelled":                 kNull,
        @"Cart Shared":                     BranchStandardEventShare,
        @"Cart Viewed":                     BranchStandardEventViewCart,
        @"Order Updated":                   kNull,
        @"Coupon Denied":                   kNull,
        @"Promotion Viewed":                kNull,
        @"Product Shared":                  BranchStandardEventShare,
        @"Checkout Step Viewed":            kNull,
        @"Order Refunded":                  kNull,
        @"Product Added":                   BranchStandardEventAddToCart,
        @"Coupon Applied":                  BranchStandardEventSpendCredits,
        @"Product Removed":                 kNull,
        @"Checkout Started":                BranchStandardEventInitiatePurchase,
        @"Promotion Clicked":               kNull,
        @"Product Clicked":                 BranchStandardEventViewItem,
        @"Coupon Entered":                  kNull,
    };

    if (!segmentEventName) return @"";
    NSString *branchEventName = eventDictionary[segmentEventName];
    return (branchEventName && [branchEventName isKindOfClass:NSString.class]) ? branchEventName : segmentEventName;
}

+ (BNCProductCategory) categoryFromString:(NSString*)string {
    if (string.length == 0) return nil;

    NSArray *categories = @[
        BNCProductCategoryAnimalSupplies,
        BNCProductCategoryApparel,
        BNCProductCategoryArtsEntertainment,
        BNCProductCategoryBabyToddler,
        BNCProductCategoryBusinessIndustrial,
        BNCProductCategoryCamerasOptics,
        BNCProductCategoryElectronics,
        BNCProductCategoryFoodBeverageTobacco,
        BNCProductCategoryFurniture,
        BNCProductCategoryHardware,
        BNCProductCategoryHealthBeauty,
        BNCProductCategoryHomeGarden,
        BNCProductCategoryLuggageBags,
        BNCProductCategoryMature,
        BNCProductCategoryMedia,
        BNCProductCategoryOfficeSupplies,
        BNCProductCategoryReligious,
        BNCProductCategorySoftware,
        BNCProductCategorySportingGoods,
        BNCProductCategoryToysGames,
        BNCProductCategoryVehiclesParts,
    ];

    for (BNCProductCategory category in categories) {
        if ([string compare:category options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch] == NSOrderedSame)
            return category;
    }
    return nil;
}

#define addStringField(field, name) { \
    NSString *value = dictionary[@#name]; \
    if (value) { \
        if ([value isKindOfClass:NSString.class]) \
            field = value; \
        else \
            field = [value description]; \
        dictionary[@#name] = nil; \
    } \
}

#define addDecimalField(field, name) { \
    NSString *value = dictionary[@#name]; \
    if (value) { \
        if (![value isKindOfClass:NSString.class]) \
            value = [value description]; \
        field = [NSDecimalNumber decimalNumberWithString:value]; \
        dictionary[@#name] = nil; \
    } \
}

#define addDoubleField(field, name) { \
    NSNumber *value = dictionary[@#name]; \
    if ([value respondsToSelector:@selector(doubleValue)]) { \
        field = [value doubleValue]; \
        dictionary[@#name] = nil; \
    } \
}

+ (BranchUniversalObject*) universalObjectFromDictionary:(NSMutableDictionary*)dictionary {
    NSInteger initialCount = dictionary.count;
    if (initialCount == 0) return nil;

    /* Segment product fields:
        product_id
        sku
        category
        name
        brand
        variant
        price
        quantity
        url
        image_url
    */

    BranchUniversalObject *object = [[BranchUniversalObject alloc] init];
    object.contentMetadata.contentSchema = BranchContentSchemaCommerceProduct;

    addStringField(object.canonicalIdentifier, product_id);
    addStringField(object.contentMetadata.sku, sku);
    BNCProductCategory category = [self categoryFromString:dictionary[@"category"]];
    if (category) {
        object.contentMetadata.productCategory = category;
        dictionary[@"category"] = nil;
    }
    addStringField(object.contentMetadata.productName, name);
    addStringField(object.contentMetadata.productBrand, brand);
    addStringField(object.contentMetadata.productVariant, variant);
    addDecimalField(object.contentMetadata.price, price);
    addDoubleField(object.contentMetadata.quantity, quantity);
    addStringField(object.canonicalUrl, url);
    addStringField(object.imageUrl,  image_url);

    // Segment fields not handled: coupon and position, for instance.
    object.contentMetadata.customMetadata = [self stringDictionaryFromDictionary:dictionary];

    // If we didn't add any fields return a nil object:
    if (dictionary.count == initialCount)
        return nil;

    return object;
}

+ (NSString*) stringFromObject:(id<NSObject>)object {
    if (object == nil) return nil;
    if ([object isKindOfClass:NSString.class]) {
        return (NSString*) object;
    } else
    if ([object respondsToSelector:@selector(stringValue)]) {
        return [(id)object stringValue];
    }
    return [object description];
}

+ (NSMutableDictionary*) stringDictionaryFromDictionary:(NSDictionary*)dictionary_ {
    if (dictionary_ == nil) return nil;
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    for(id<NSObject> key in dictionary_.keyEnumerator) {
        NSString* stringValue = [self stringFromObject:dictionary_[key]];
        NSString* stringKey = [self stringFromObject:key];
        if (stringKey) dictionary[stringKey] = stringValue;
    }
    return dictionary;
}

+ (BranchEvent*) branchEventFromSegmentEvent:(NSString*)eventName
                                  dictionary:(NSDictionary*)immutableDictionary {
    // Make a deep copy of the event dictionary:
    NSError*error = nil;
    NSMutableDictionary*dictionary = nil;
    NSData*data = [NSPropertyListSerialization dataWithPropertyList:immutableDictionary
        format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    if (error || data == nil) {
        SEGLog(@"[Branch Event] Can't serialize event parameters: %@.", error);
    } else {
        error = nil;
        dictionary = [NSPropertyListSerialization propertyListWithData:data
            options:NSPropertyListMutableContainersAndLeaves format:NULL error:&error];
        if (error) SEGLog(@"[Branch Event] Can't de-serialize event parameters: %@.", error);
    }

    // Make a BranchEvent from the passed dictionary:
    NSString *branchEvent = [self.class branchEventFromSegmentEventName:eventName];
    BranchEvent *event = [[BranchEvent alloc] initWithName:branchEvent];
    if (!dictionary) return event;

    /* BranchEvent fields:

    transactionID;
    currency;
    revenue;
    shipping;
    tax;
    coupon;
    affiliation;
    eventDescription;
    searchQuery;
    */

    /* Segment event fields:

    "order_id": "50314b8e9bcf000000000000",
    "affiliation": "Google Store",
    "value": 30,
    "revenue": 25,
    "shipping": 3,
    "tax": 2,
    "discount": 2.5,
    "coupon": "hasbros",
    "currency": "USD",
    */

    addStringField(event.transactionID, order_id);
    addStringField(event.currency, currency);
    addDecimalField(event.revenue, revenue);
    addDecimalField(event.shipping, shipping);
    addDecimalField(event.tax, tax);
    addStringField(event.coupon, coupon);
    addStringField(event.affiliation, affiliation);
    event.eventDescription = eventName;
    addStringField(event.searchQuery, query);

    NSArray *products = dictionary[@"products"];
    NSMutableArray *contentItems = [NSMutableArray<BranchUniversalObject *> new];
    if ([products isKindOfClass:NSArray.class]) {
        for (NSMutableDictionary *product in products) {
            BranchUniversalObject *object = [self universalObjectFromDictionary:product];
            if (object) {
                [contentItems addObject:object];
            }
        }
        dictionary[@"products"] = nil;
    }
    // Maybe the some product fields are at the first level. Don't add if we already have:
    if (contentItems.count == 0) {
        BranchUniversalObject *object = [self universalObjectFromDictionary:dictionary];
        if (object) {
            [contentItems addObject:object];
        }
    }
    event.contentItems = [NSArray arrayWithArray:contentItems];
    
    // Add any extra fields to customData:
    event.customData = [self stringDictionaryFromDictionary:dictionary];

    return event;
}

#pragma mark - Segment Interface

- (void)track:(SEGTrackPayload *)payload {
    BranchEvent *event = [self.class branchEventFromSegmentEvent:payload.event dictionary:payload.properties];
    [event logEvent];
    SEGLog(@"[BranchEvent logEvent]: %@.", event);
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

- (void)identify:(SEGIdentifyPayload *)payload {
    if (payload.userId != nil && [payload.userId length] != 0) {
        [[Branch getInstance] setIdentity:payload.userId];
        SEGLog(@"[[Branch getInstance] setIdentity:%@]", payload.userId);
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

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    [[Branch getInstance] initSessionWithLaunchOptions:notification.userInfo];
    SEGLog(@"[[Branch getInstance] initSessionWithLaunchOptions:%@]", notification.userInfo);
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
