//
//  VSSSign.h
//  VHallSDK
//
//  Created by vhall on 2019/7/5.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VSSSignInfo : NSObject

@property (nonatomic, copy) NSString *room_id;
@property (nonatomic, copy) NSString *sign_creator_avatar;
@property (nonatomic, copy) NSString *sign_creator_id;
@property (nonatomic, copy) NSString *sign_creator_nickname;
@property (nonatomic, copy) NSString *sign_id;
@property (nonatomic, assign) NSInteger sign_show_time;

@end

//签到记录列表-用户模型
@interface VSSSignRecord : NSObject

@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *bu;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *creator_id;
@property (nonatomic, copy) NSString *deleted;
@property (nonatomic, copy) NSString *deleted_at;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *sign_id;
@property (nonatomic, copy) NSString *signer_avatar;
@property (nonatomic, copy) NSString *signer_id;
@property (nonatomic, copy) NSString *signer_nickname;
@property (nonatomic, copy) NSString *source_id;
@property (nonatomic, copy) NSString *updated_at;

@end

@protocol VSSSignDelegate <NSObject>

@optional

//发起签到开始
- (void)vssSignStart:(NSUInteger)maxRemainTime;

//签到倒计时（每秒回调）
- (void)vssSigningCountDown:(NSUInteger)remainTime;

//签到倒计时结束
- (void)vssSignEnd;

@end

///VSS签到
@interface VSSSign : NSObject

@property (nonatomic, weak) id <VSSSignDelegate> delegate;

@property (nonatomic, strong, nullable) VSSSignInfo *curSignInfo;

//主播端发起签到
- (void)signOpeningWithTime:(NSUInteger)time
                    success:(void (^)(NSDictionary *response))success
                    failure:(void (^)(NSError *error))failure;

/// 主播端获取签到明细记录
/// @param signId 签到id
/// @param offset 页码
/// @param limit 每页条数
/// @param success 成功回调
/// @param failure 失败回调
- (void)getSignRecordsWithSignId:(NSString *)signId offset:(NSInteger)offset limit:(NSInteger)limit success:(void (^)(NSArray <VSSSignRecord *> *recordList))success failure:(void (^)(NSError *error))failure;

//观众确定签到
- (void)vssSignSuccess:(void (^)(NSDictionary *response))success
               failure:(void (^)(NSError *error))failure;

//取消
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
