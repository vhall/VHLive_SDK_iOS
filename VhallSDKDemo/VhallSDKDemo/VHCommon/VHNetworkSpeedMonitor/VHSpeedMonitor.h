//
//  VHSpeedMonitor.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/4/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHSpeedMonitor : NSObject

/// 开始检测
- (void)startNotifier;

/// 停止检测
- (void)stopNotifier;

/// 打印当前网络类型
- (void)getNetwork;

/// 获取当前网速
- (float)getInterfaceSpeedInKbps;

@end

NS_ASSUME_NONNULL_END
