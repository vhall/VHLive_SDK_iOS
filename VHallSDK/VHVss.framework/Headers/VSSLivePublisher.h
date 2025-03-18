//
//  VSSLivePublisher.h
//  VHallSDK
//
//  Created by vhall on 2019/7/9.
//  Copyright © 2019年 vhall. All rights reserved.
//

#import <VHLSS/VHLivePublisher.h>

NS_ASSUME_NONNULL_BEGIN

@interface VSSLivePublisher : VHLivePublisher

///开始直播  //type：1 web 2 app 3 sdk 4 推拉流 5 定时 6 admin后台 7第三方8 助手
+ (void)vssStartLiveWithType:(NSInteger)type success:(void (^_Nullable)(NSDictionary *response))success failure:(void (^_Nullable)(NSError *error))failure;

///结束直播 //type：1 web 2 app 3 sdk 4 推拉流 5 定时 6 admin后台 7第三方8 助手
+ (void)vssStopLiveWithType:(NSInteger)type success:(void (^_Nullable)(NSDictionary *response))success failure:(void (^_Nullable)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
