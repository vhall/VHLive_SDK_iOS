//
//  VHallLikeObject.h
//  VHallSDK
//
//  Created by 郭超 on 2022/7/25.
//  Copyright © 2022 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHallBasePlugin.h"

@protocol VHallLikeObjectDelegate <NSObject>

/// 更新点赞总数
/// @param num 点赞总数
- (void)vhPraiseTotalToNum:(NSInteger)num;

@end

@interface VHallLikeObject : VHallBasePlugin

@property (nonatomic, weak) id <VHallLikeObjectDelegate> delegate; ///<代理

/// 创建房间的用户点赞
/// @param roomId 房间id
/// @param num 点赞次数，最多500，超过500会强制成为500
/// @param complete responseObject:成功详情 error:错误详情
+ (void)createUserLikeWithRoomId:(NSString *)roomId
                             num:(NSInteger)num
                        complete:(void (^)(NSDictionary *responseObject, NSError *error))complete;

/// 获取房间的点赞数量
/// @param roomId 房间id
/// @param complete total:点赞数 error:错误详情
+ (void)getRoomLikeWithRoomId:(NSString *)roomId
                     complete:(void (^)(NSInteger total, NSError *error))complete;

@end
