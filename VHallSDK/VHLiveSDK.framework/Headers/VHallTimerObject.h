//
//  VHallTimerObject.h
//  VHallSDK
//
//  Created by 郭超 on 2022/7/22.
//  Copyright © 2022 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHallBasePlugin.h"
#import "VHallRawBaseModel.h"

@interface VHallTimerObjectModel : VHallRawBaseModel

@property (nonatomic, readonly) NSInteger duration;         ///<总时间 秒
@property (nonatomic, readonly) NSInteger remain_time;      ///<剩余时间 秒
@property (nonatomic, readonly) NSInteger status;           ///<4=暂停
@property (nonatomic, readonly) BOOL is_all_show;           ///<是否所有人可见
@property (nonatomic, readonly) BOOL is_timeout;            ///<是否允许超时

@end

@protocol VHallTimerObjectDelegate <NSObject>

/// 开始计时器
/// @param duration 计时时间（单位秒）
/// @param is_all_show 是否所有人可见
/// @param is_timeout 是否可超时 设置可超时后，倒计时结束，变倒计时为从00:00开始的正向计时，记录超时时间
- (void)vhTimerStartToDuration:(NSInteger)duration
                   is_all_show:(BOOL)is_all_show
                    is_timeout:(BOOL)is_timeout;

/// 结束计时器
- (void)vhTimerEnd;

/// 暂停计时器
- (void)vhTimerPause;

/// 恢复计时器
/// @param duration 计时时间（单位秒）
/// @param remain_time 剩余时间（单位秒）
/// @param is_all_show 是否所有人可见
/// @param is_timeout 是否可超时 设置可超时后，倒计时结束，变倒计时为从00:00开始的正向计时，记录超时时间
- (void)vhTimerResumeToDuration:(NSInteger)duration
                    remain_time:(NSInteger)remain_time
                    is_all_show:(BOOL)is_all_show
                     is_timeout:(BOOL)is_timeout;

/// 重置计时器
/// @param duration 计时时间（单位秒）
/// @param is_all_show 是否所有人可见
/// @param is_timeout 是否可超时 设置可超时后，倒计时结束，变倒计时为从00:00开始的正向计时，记录超时时间
- (void)vhTimerResetToDuration:(NSInteger)duration
                   is_all_show:(BOOL)is_all_show
                    is_timeout:(BOOL)is_timeout;

@end


@interface VHallTimerObject : VHallBasePlugin

@property (nonatomic, weak) id <VHallTimerObjectDelegate> delegate; ///<代理

/// 查询计时器进度
/// @param success 成功
/// @param fail 失败
+ (void)requestInteractsTimerInfoSuccess:(void (^)(VHallTimerObjectModel *timerModel))success
                                    fail:(void (^)(NSError *error))fail;
@end
