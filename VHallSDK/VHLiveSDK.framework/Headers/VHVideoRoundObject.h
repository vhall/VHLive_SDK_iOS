//
//  VHVideoRoundObject.h
//  VHLiveSDK
//
//  Created by 郭超 on 2022/11/2.
//  Copyright © 2022 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHallBasePlugin.h"

@interface VHVideoRoundObject : VHallBasePlugin

/// 获取轮询用户
/// @param room_id 房间id
/// @param is_next 是否是下一组， 0：当前组， 1：下一组
/// @param success 成功
/// @param fail 失败
+ (void)getRoundUsers:(NSString *)room_id is_next:(NSString *)is_next success:(void (^)(NSDictionary *response))success fail:(void (^)(NSError *error))fail;

@end
