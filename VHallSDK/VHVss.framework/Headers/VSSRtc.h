//
//  VSSRtc.h
//  VSSDemo
//
//  Created by vhall on 2019/7/1.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <VHRTC/VHInteractiveRoom.h>
#import "VSSRTCMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@class VSSRtc;

@protocol VSSRtcDelegate <VHInteractiveRoomDelegate>

@optional
//互动所有事件回调
- (void)vssRTC:(VSSRtc *)rtc didReceivedMsg:(VSSRTCMsgModel *)model;
//自己的麦克风状态开启/关闭完成回调
- (void)vssRTC:(VSSRtc *)rtc micphoneStatus:(BOOL)isOpen;
//自己的摄像头状态开启/关闭完成回调
- (void)vssRTC:(VSSRtc *)rtc cameraStatus:(BOOL)isOpen;

@end



@interface VSSRtc : VHInteractiveRoom

- (instancetype)init;
- (instancetype)initWithLogParam:(nullable NSDictionary*)logParam;

//互动房间id
@property (nonatomic, copy) NSString *inav_id;
//用户id
@property (nonatomic, copy) NSString *joinId;
//推流token
@property (nonatomic, copy) NSString *access_token;

@property (nonatomic, weak) id <VSSRtcDelegate> vssDelegate;


///开启/关闭自己的摄像头
- (void)ownCameraOpen:(BOOL)on success:(void(^)(void))success failure:(void(^)(NSString *msg))failure;

///开启/关闭自己的麦克风
- (void)ownMicrophoneOpen:(BOOL)on success:(void(^)(void))success failure:(void(^)(NSString *msg))failure;

///开启/关闭别人的麦克风
+ (void)microphoneSwitch:(BOOL)on
                  toUser:(NSString *)targetId
                 success:(void (^)(NSDictionary *response))success
                 failure:(void (^)(NSError *error))failure;

///开启/关闭别人的摄像头
+ (void)cameraSwitch:(BOOL)on
              toUser:(NSString *)targetId
             success:(void (^)(NSDictionary *response))success
             failure:(void (^)(NSError *error))failure;


//设置举手（1允许0禁止）活动开始后调用生效
+ (void)handUpSet:(BOOL)isOpen
          success:(void (^)(NSDictionary *response))success
          failure:(void (^)(NSError *error))failure;

//下麦某个用户
+ (void)downMicrophoneTargetId:(NSString *)targetId
                    success:(void (^)(id responseObject))success
                    failure:(void(^)(NSError *error))failure;

//同意某个用户的上麦申请
+ (void)acceptUpMicrophoneTargetId:(NSString *)targetId
                      success:(void (^)(NSDictionary *response))success
                      failure:(void(^)(NSError *error))failure;
//拒绝某个用户的上麦申请
+ (void)refuseUpMicrophoneTargetId:(NSString *)targetId
                          success:(void (^)(NSDictionary *response))success
                          failure:(void (^)(NSError *error))failure;

//邀请某个用户上麦
+ (void)inviteUpMicrophoneTargetId:(NSString *)targetId
               success:(void (^)(NSDictionary *response))success
               failure:(void (^)(NSError *error))failure;


//指定某个用户主画面显示
+ (void)setMainScreenWithTargertId:(NSString *)targertId
                           success:(void (^)(NSDictionary *response))success
                           failure:(void (^)(NSError *error))failure;

///自己上麦 (主持人不调用，开始推流之前先请求这个接口，成功之后再正式推流上麦)
+ (void)startInteractivePushSuccess:(nullable void (^)(NSDictionary *response))successBlock failure:(nullable void (^)(NSError *error))failureBlock;
///自己下麦 (主持人、观众、嘉宾公用接口)
+ (void)stopInteractivePushSuccess:(nullable void (^)(NSDictionary *response))successBlock failure:(nullable void (^)(NSError *error))failureBlock;

@end

NS_ASSUME_NONNULL_END
