//
//  VSSRTCMsgModel.h
//  VHVSS
//
//  Created by vhall on 2019/9/16.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VSSMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

//http://wiki.vhallops.com/pages/viewpage.action?pageId=46694612
//互动消息事件类型
typedef NS_ENUM(NSInteger,VSSRTCMsgType) {
    VSSRTCMsgType_vrtc_connect_open = 0,         //开启举手
    VSSRTCMsgType_vrtc_connect_close = 1,        //关闭举手
    VSSRTCMsgType_vrtc_connect_apply = 2,        //申请上麦
    VSSRTCMsgType_vrtc_connect_apply_cancel = 3, //某个用户取消上麦申请
    VSSRTCMsgType_vrtc_connect_invite = 4,       //某个用户被邀请上麦
    VSSRTCMsgType_vrtc_connect_agree = 5,        //某个用户上麦申请被同意
    VSSRTCMsgType_vrtc_connect_refused = 6,      //某个用户上麦申请被拒绝
    VSSRTCMsgType_vrtc_mute = 7,                 //静音某路流
    VSSRTCMsgType_vrtc_mute_all = 8,             //全体静音
    VSSRTCMsgType_vrtc_mute_cancel = 9,          //取消某路静音
    VSSRTCMsgType_vrtc_mute_all_cancel = 10,     //取消全体静音
    VSSRTCMsgType_vrtc_frames_forbid = 11,       //禁止某路视频显示
    VSSRTCMsgType_vrtc_frames_display = 12,      //显示某路视频
    VSSRTCMsgType_vrtc_big_screen_set = 13,      //某用户的互动流画面被设置为旁路大画面
    VSSRTCMsgType_vrtc_speaker_switch = 14,      //互动设置主讲人
    VSSRTCMsgType_room_kickout = 15,             //某个用户被踢出
    VSSRTCMsgType_live_start = 16,               //开始直播
    VSSRTCMsgType_live_over = 17,                //结束直播
    VSSRTCMsgType_room_announcement = 18,        //发布公告
    VSSRTCMsgType_vrtc_disconnect_success = 19,  //某用户下麦成功 （自己主动下麦/被下麦）
    VSSRTCMsgType_vrtc_connect_success = 20,     //某用户上麦成功 （自己主动上麦/被上麦）
    VSSRTCMsgType_vrtc_connect_invite_refused = 21,    //某个用户拒绝上麦邀请
    VSSRTCMsgType_room_kickout_cancel = 22,      //某用户被取消踢出
    VSSRTCMsgType_room_disable = 23,        //禁言
    VSSRTCMsgType_room_permit = 24,         //取消禁言
    VSSRTCMsgType_room_disable_all = 25,      //全体禁言
    VSSRTCMsgType_room_permit_all = 26,      //全体取消禁言
};

@interface VSSRTCMsgModel : VSSMsgModel

@property (nonatomic) VSSRTCMsgType msgType;

- (instancetype)initWithMsg:(VHMessage *)msg type:(VSSRTCMsgType)type;

@end

NS_ASSUME_NONNULL_END
