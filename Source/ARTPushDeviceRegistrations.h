//
//  ARTPushDeviceRegistrations.h
//  Ably
//
//  Created by Ricardo Pereira on 20/02/2017.
//  Copyright © 2017 Ably. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARTTypes.h"

@class ARTDeviceDetails;
@class ARTPaginatedResult;

@protocol ARTHTTPAuthenticatedExecutor;

NS_ASSUME_NONNULL_BEGIN

@interface ARTPushDeviceRegistrations : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)init:(id<ARTHTTPAuthenticatedExecutor>)httpExecutor;

- (void)save:(ARTDeviceDetails *)deviceDetails callback:(void (^)(ARTErrorInfo *_Nullable))callback;

- (void)list:(NSDictionary<NSString *, NSString *> *)params callback:(void (^)(ARTPaginatedResult<ARTDeviceDetails *> *_Nullable,  ARTErrorInfo *_Nullable))callback;

- (void)remove:(NSString *)deviceId callback:(void (^)(ARTErrorInfo *_Nullable))callback;
- (void)removeWhere:(NSDictionary<NSString *, NSString *> *)params callback:(void (^)(ARTErrorInfo *_Nullable))callback;

@end

NS_ASSUME_NONNULL_END
