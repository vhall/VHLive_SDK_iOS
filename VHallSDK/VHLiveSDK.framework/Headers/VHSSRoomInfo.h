//
//  VHSSRoomInfo.h
//  VHVss
//
//  Created by 熊超 on 2020/11/26.
//  Copyright © 2020 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHSSInteract.h"

@class VHSSWebinarInitInfoModel;

NS_ASSUME_NONNULL_BEGIN

//当前活动信息
@interface VHSSRoomInfo : NSObject
/** 当前活动id */
@property (nonatomic, copy) NSString *current_webinarId;
/** 当前用户，三方用户id */
@property (nonatomic, copy) NSString *third_party_user_id;
/** 房间渠道id */
@property (nonatomic, copy) NSString *channel_id;
/** pass app_id */
@property (nonatomic, copy) NSString *paas_app_id;
/** pass access_token */
@property (nonatomic, copy) NSString *paas_access_token;
///<pass 回放id ///<pass 回放id ///<pass 回放id
@property (nonatomic, copy) NSString *paas_record_id;
/** 直播房间id (lss_***) */
@property (nonatomic, copy) NSString *room_id;
/** 互动房间id */
@property (nonatomic, copy) NSString *inav_id;
/** 私密信息 */
@property (nonatomic, copy) NSString *privacies;
/** 自己是否被禁言 */
@property (nonatomic, assign) BOOL is_banned;
/** 自己是否被踢出 */
@property (nonatomic, assign) BOOL is_kick;
/** 是否全体被禁言 */
@property (nonatomic, assign) BOOL is_all_banned;
/** 是否开启了问答禁言 YES 开启 NO 未开启 */
@property (nonatomic, assign) BOOL qa_status;
/** 自己角色  1主持人 2观众 3助理 4嘉宾 */
@property (nonatomic, assign) NSInteger userRole;
/** 进入房间时，房间工具状态 */
@property (nonatomic, strong) VHSSRoomToolsStatus *toolsStatus;
/** 直播状态1-直播中，2-预约，3-结束，4-点播，5-回放 */
@property (nonatomic, assign) NSInteger roomStatus;
@property (nonatomic, copy) NSString *nickName;     //自己昵称
@property (nonatomic, copy) NSString *avatar;     //自己头像
@property (nonatomic, copy) NSString *switch_id;   ///<场次信息

@property (nonatomic, copy) NSString *subject;     ///<活动名称
@property (nonatomic, copy) NSString *introduction;     ///<活动简介
@property (nonatomic, copy) NSString *img_url;     ///<活动封面
@property (nonatomic, copy) NSString *start_time; ///<活动创建时设置的开播时间
@property (nonatomic, copy) NSString *end_time; ///< 活动最近一次结束时间
@property (nonatomic, copy) NSString *actual_start_time; ///<活动最近一次开播时间
@property (nonatomic, assign) NSUInteger type;  ///<活动直播状态
@property (nonatomic, assign) NSUInteger mode;  ///<直播模式：1-音频、2-视频、3-互动

@property (nonatomic, copy) NSString *author_userId;     ///<活动发起者用户id
@property (nonatomic, copy) NSString *author_nickname;     ///<活动发起者用户昵称
@property (nonatomic, copy) NSString *author_avatar;     ///<活动发起者头像

@property (nonatomic, assign) BOOL membersManage;     ///<自己是否有成员管理权限
@property (nonatomic, assign) NSInteger inav_num;     ///<当前活动设置的最大连麦人数，6表示1v5，16表示1v15
@property (nonatomic, assign) NSInteger no_delay_webinar; ///<是否无延迟直播  1是 0否
@property (nonatomic, assign) NSInteger speakerAndShowLayout;   //0 -- 分离模式；1 -- 合并模式；
@property (nonatomic, copy) NSString *videoBackGround;  /// 背景图片
@property (nonatomic, copy) NSString *finalVideoBackground;  /// 背景图片(带透明度等属性的地址链接)
@property (nonatomic, copy) NSString *videoBackGroundColor; /// 背景颜色
@property (nonatomic, copy) NSDictionary *videoBackGroundSize;  /// 背景尺寸
/*
   新增化蝶支持角色修改名称
 */
//主持人角色名称
@property (nonatomic, copy) NSString *hostRoleName;
//嘉宾角色名称
@property (nonatomic, copy) NSString *guestRoleName;
//助理角色名称
@property (nonatomic, copy) NSString *assistantRoleName;
//------------------自定义属性----------------
@property (nonatomic, assign) BOOL init_speaking;     ///<获取房间工具状态此时自己的上麦状态（有可能之前异常杀死app，导致还处于上麦状态）

//通过直播初始化信息，创建房间信息
+ (VHSSRoomInfo *)roomInfoWithWebinarInitInfo:(VHSSWebinarInitInfoModel *)initModel;

//通过直播初始化信息，创建房间信息
+ (void)roomInfoWithWebinarInitInfoModel:(VHSSWebinarInitInfoModel *)webinarInitInfoModel complete:(void (^)(VHSSRoomInfo *roomInfo))complete;

//获取带设备状态、禁言状态、角色的context
- (NSDictionary *)contextWithDictionary:(NSDictionary *_Nullable)dict;

@end



NS_ASSUME_NONNULL_END
