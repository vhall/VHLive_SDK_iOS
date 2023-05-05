//
//  VHNetworkSpeedMonitor.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/4/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHNetworkSpeedMonitor : NSObject

- (instancetype)initWithUpdateInterval:(NSTimeInterval)interval;
- (void)startMonitoring;
- (void)stopMonitoring;

@end

NS_ASSUME_NONNULL_END
