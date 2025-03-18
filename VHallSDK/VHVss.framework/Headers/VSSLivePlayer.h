//
//  VSSLivePlayer.h
//  VSSDemo
//
//  Created by vhall on 2019/6/29.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <VHLSS/VHLivePlayer.h>

@class VSSLivePlayer;@class VHMessage;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,VSSLiveMsgType) {
    VSSLiveMsgType_live_start,          //开始直播
    VSSLiveMsgType_live_over,           //结束直播
    VSSLiveMsgType_vrtc_connect_invite, //邀请上麦
    VSSLiveMsgType_vrtc_connect_agree,  //讲师同意上麦申请
    VSSLiveMsgType_vrtc_connect_refuse, //讲师拒绝上麦申请
    VSSLiveMsgType_room_kickout,        //踢出
    VSSLiveMsgType_vrtc_connect_open,   //开启举手
    VSSLiveMsgType_vrtc_connect_close,  //关闭举手
    VSSLiveMsgType_room_announcement,   //发布公告
};

@protocol VSSLivePlayerDelegate <VHLivePlayerDelegate>

@optional

/// 直播消息回调
/// @param msg 消息
/// @param type 消息类型
/// @param targetIsMyself 是否只是针对自己的消息
- (void)receivedMsg:(VHMessage *)msg msgType:(VSSLiveMsgType)type targetIsMyself:(BOOL)targetIsMyself;

@end


@interface VSSLivePlayer : VHLivePlayer

@property (nonatomic, weak) id <VSSLivePlayerDelegate> vssDelegate;

//申请上麦
+ (void)applyInteractiveSuccess:(void (^)(NSDictionary *response))success
                        failure:(void (^)(NSError *error))failure;

//取消申请上麦
+ (void)cancelApplyInteractiveSuccess:(void (^)(NSDictionary *response))success
                        failure:(void (^)(NSError *error))failure;

//同意上麦邀请
+ (void)agreeInviteSuccess:(nullable void (^)(NSDictionary *response))success
                   failure:(nullable void (^)(NSError *error))failure;
//拒绝上麦邀请
+ (void)refuseInviteSuccess:(nullable void (^)(NSDictionary *response))success
                   failure:(nullable void (^)(NSError *error))failure;
/**
 获取原流的播放链接，直播hls，回放hls，点播mp4, 可能返回nil，真正调度后才能取得值
 */
-(NSString*)GetOriginalUrl;
@end

NS_ASSUME_NONNULL_END
