//
//  VSSRoomInfo.h
//  VSSDemo
//
//  Created by vhall on 2019/6/27.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,VSSRoomStatus) {
    VSSRoomStatusDefault,   //预约
    VSSRoomStatusLiving,    //直播
    VSSRoomStatusOver,      //结束
};

//1主持人2观众3助理4嘉宾
typedef NS_ENUM(NSInteger,VSSRoomUserRole) {
    VSSRoomUserRoleUnkown,
    VSSRoomUserRoleHost,
    VSSRoomUserRoleAudience,
    VSSRoomUserRoleAssistant,
    VSSRoomUserRoleGust,
};

@class VSSAdvertisementInfo;
@class VSSRoomAttributes;

@interface VSSRoomInfo : NSObject

///房间信息
@property (nonatomic, strong, nullable) NSString *account_id;//房主id
@property (nonatomic, strong) VSSAdvertisementInfo *advert_info; ///<广告模型
@property (nonatomic, strong) NSString *channel_id; //渠道id
@property (nonatomic, strong) NSString *room_id;//直播房间id (lss_*******)
@property (nonatomic, strong) NSString *paas_access_token; //直播token
@property (nonatomic, strong) NSString *inav_id;//互动直播间id
@property (nonatomic, strong, nullable) NSString *record_id;//回放id
@property (nonatomic, assign) VSSRoomStatus roomStatus; //直播状态 0预约1直播2结束
@property (nonatomic, assign) NSInteger layout;  //0不存在 1单视频 2文档＋声音 3文档＋视频 4单音频
@property (nonatomic, strong) NSString *third_party_user_id;//自己的参会id
@property (nonatomic, assign) VSSRoomUserRole userRole;//自己的角色名称 1主持人2观众3助理4嘉宾
@property (nonatomic, strong) NSString *room_name; /// 直播间名称
@property (nonatomic, assign) NSInteger pv; /// pv数
@property (nonatomic, copy) NSString *nickName;  //自己的昵称
@property (nonatomic, copy) NSString *avatar;  //自己的头像
@property (nonatomic, assign) BOOL is_banned; ///<是否被禁言 1是0否
@property (nonatomic, assign) BOOL is_kicked; ///<是否被踢出 1是0否
@property (nonatomic, assign) BOOL keepBanChatStatus; ///<是否保持禁言状态，默认YES（观众被主播禁言后，观众退出房间后重新进入房间，保持禁言状态）
@property (nonatomic, strong) VSSRoomAttributes* attributes;//房间信息
@property (nonatomic, assign ,readonly) BOOL is_speaking;  ///<加入VSS房间此时自己的上麦状态 1 ：上麦中 0 ：未上麦

//----------------------SaaS6.0使用-------------------------
@property (nonatomic, copy) NSString *current_webinarId;     ///<当前活动id


- (instancetype)initWithDict:(NSDictionary *)dict;


//获取添加设备类型、是否可上麦、是否被禁言等信息之后的userInfo
- (NSMutableDictionary *)contextWithUserInfo:(NSDictionary *)userInfo;
@end

//上麦列表模型
@interface VSSRoomSpeaker : NSObject
/** 昵称 */
@property (nonatomic, copy) NSString *nick_name;
/** 角色  1主持人 2观众 3助理 4嘉宾*/
@property (nonatomic, assign) NSInteger role_name;
/** 用户id */
@property (nonatomic, copy) NSString *account_id;
/** 是否开启麦克风 1:开启 0未开启 */
@property (nonatomic, assign) NSInteger audio;
/** 是否开启摄像头 1:开启 0未开启 */
@property (nonatomic, assign) NSInteger video;
@end

@interface VSSRoomAttributes : NSObject
@property (nonatomic, assign) BOOL all_banned;          //全体禁言1禁言0取消禁言
@property (nonatomic, assign) BOOL is_board;            //开关白板，1开0关
@property (nonatomic, assign) BOOL is_desktop;          //开关桌面演示，1开0关
@property (nonatomic, assign) BOOL is_doc;              //开关文档，1开0关
@property (nonatomic, assign) BOOL is_handsup;          //开关举手，1开0关
@property (nonatomic, assign) BOOL is_invitecard;       //开关邀请卡 1是0否
@property (nonatomic, assign) BOOL is_qa;               //开关问答，1开0关
@property (nonatomic, assign) NSInteger start_type;     //1 web 2 app 3 sdk 4 推拉流 5 定时 6 admin后台 7第三方8 助手
@property (nonatomic, copy)   NSString* doc_permission;   //文档权限（主讲人的id）
@property (nonatomic, copy)   NSString* main_screen;      //主画面
@property (nonatomic, copy)   NSString* rebroadcast;      //转播源房间id
@property (nonatomic, strong) NSArray <VSSRoomSpeaker *> *speaker_list;    //加入VSS房间此时的上麦列表
@property (nonatomic, strong) NSDictionary* stream;     //流 layout布局 definition清晰度

- (instancetype)initWithDict:(NSDictionary *)dict;

@end


NS_ASSUME_NONNULL_END
