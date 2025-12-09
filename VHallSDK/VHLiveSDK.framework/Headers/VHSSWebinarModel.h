//
//  VHSSWebinarModel.h
//  VHVss
//
//  Created by 熊超 on 2020/11/16.
//  Copyright © 2020 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//活动列表
@interface VHSSWebinarListModel : NSObject
@property (nonatomic, copy) NSString *webinar_id;       ///<活动id
@property (nonatomic, assign) NSInteger webinar_state;      ///<直播状态 1预约 2直播 3回放 4点播 5结束
@property (nonatomic, copy) NSString *img_url;          ///<封面图片
@property (nonatomic, copy) NSString *subject;          ///<标题
@property (nonatomic, copy) NSString *start_time;       ///<直播开始时间 eg:2020-10-26 22:56:32
@property (nonatomic, copy) NSString *share_link;     ///<分享链接
@property (nonatomic, assign) NSInteger webinar_type;     ///<直播类型 1：音频 2: 视频 3：互动
@property (nonatomic, assign) NSInteger player;     ///<1 flash 2 h5
@property (nonatomic, assign) NSInteger is_new_version;   ///<0 1 3 只有3是新版本的
@property (nonatomic, assign) NSInteger is_privilege;    ///<是否开启角色邀请
@property (nonatomic, assign) NSInteger no_delay_webinar;     ///<是否无延迟直播 1:是 0:否
@property (nonatomic, assign) NSInteger inav_num;     ///<当前活动设置的最大连麦人数 6表示1v5，16表示1v15
@property (nonatomic, assign) NSInteger director_user_status;//云导播用户权限
@property (nonatomic, assign) NSInteger portrait_screen; ///<是否支持竖屏 1:开启 0:关闭。默认关闭
@property (nonatomic, assign) NSInteger webinar_show_type; ///横竖屏 0竖屏 1横屏
@property (nonatomic) NSInteger is_director; ///是否有云导播权限
@end


//活动基础信息
@interface VHSSWebinarBaseInfoModel : NSObject
@property (nonatomic, copy) NSDictionary *data;     //原始数据
@property (nonatomic, copy) NSString *ID;           ///<id
@property (nonatomic, copy) NSString *user_id;       ///<用户id
@property (nonatomic, copy) NSString *subject;       ///<标题
@property (nonatomic, copy) NSString *introduction;       ///<简介
@property (nonatomic, copy) NSString *img_url;       ///<封面图片
@property (nonatomic, copy) NSString *category;     ///<类别，eg：金融
@property (nonatomic, copy) NSString *start_time;   ///<直播开始时间
@property (nonatomic, copy) NSString *actual_start_time;       ///<实际开始时间
@property (nonatomic, copy) NSString *end_time;     ///<直播结束时间
@property (nonatomic, assign) NSInteger is_open;      ///<是否公开,默认0为公开，1为不公开
@property (nonatomic, assign) NSInteger webinar_type;       ///<1 音频 2 视频 3 互动
@property (nonatomic, assign) NSInteger verify;       ///<验证类别，0 无验证，1 密码，2 白名单，3 付费活动, 4 F码, 5 报名表单
@property (nonatomic, copy) NSString *fee;       ///<金额
@property (nonatomic, copy) NSString *password;       ///<观看密码
@property (nonatomic, assign) NSInteger type;       ///<1为直播，2为预约,3为结束
@property (nonatomic, assign) NSInteger is_custom;       ///<是否定制，1为定制
@property (nonatomic, assign) NSInteger status;       ///<1为正常显示，2为删除
@property (nonatomic, assign) NSInteger auto_record;       ///<是否自动生成回放，1为是，2为否
@property (nonatomic, assign) NSInteger is_chat;       ///<是否允许聊天，默认0为允许，1为不允许
@property (nonatomic, assign) NSInteger top;       ///<人数上限，0位不限制
@property (nonatomic, assign) NSInteger is_allow;       ///<0为免费，1位有限制（并且要设置top的值），2位无限制。注：如果是包年账户，默认为0代表最多按包年方数走，还可以设置为2无限制。
@property (nonatomic, assign) NSInteger use_global_k;       ///<是否使用全局KEY验证 0 不使用 1使用
@property (nonatomic, assign) NSInteger is_old;       ///<是否为自动回放，1为是
@property (nonatomic, assign) NSInteger exist_3rd_auth;       ///<是否开启三方K值验证
@property (nonatomic, copy) NSString *auth_url;       ///<三方k值验证地址
@property (nonatomic, copy) NSString *failure_url;       ///<三方k值验证失败跳转地址
@property (nonatomic, copy) NSString *jump_url;        ///<后台配置跳转路径
@property (nonatomic, assign) NSInteger buffer;       ///<观看方是否延迟
@property (nonatomic, assign) NSInteger is_demand;       ///<是否为点播
@property (nonatomic, assign) NSInteger is_new_version;       ///<是否是新版本
@property (nonatomic, assign) NSInteger player;       ///<播放器，1flash 2h5
@property (nonatomic, copy) NSString *vss_room_id;       ///<vss房间id
@property (nonatomic, copy) NSString *vss_inav_id;       ///<vss互动id
@property (nonatomic, copy) NSString *vss_channel_id;       ///<vss频道id
@property (nonatomic, assign) NSInteger hide_watch;       ///<是否显示在线人数 1是 0否
@property (nonatomic, assign) NSInteger is_adi_watch_doc;       ///<观众是否可预览文档
@property (nonatomic, assign) NSInteger hide_appointment;       ///<是否显示预约人数
@property (nonatomic, assign) NSInteger hide_pv;       ///<是否显示活动热度
@property (nonatomic, assign) NSInteger webinar_curr_num;       ///<最高并发 0 无限制
@property (nonatomic, assign) NSInteger is_capacity;       ///<是否扩容
@property (nonatomic, assign) NSInteger webinar_show_type; ///横竖屏 0竖屏 1横屏
@property (nonatomic, assign) NSInteger no_delay_webinar;     ///<是否无延迟直播 1:是 0:否
@property (nonatomic, assign) NSInteger inav_num;     ///<当前活动设置的最大连麦人数 6表示1v5，16表示1v15
@property (nonatomic, assign) NSInteger director_user_status;//云导播用户权限
@property (nonatomic, assign) NSInteger portrait_screen; ///<是否支持竖屏 1:开启 0:关闭。默认关闭
@property (nonatomic, assign) NSInteger is_director;//是否可以使用云导播功能
@property (nonatomic) BOOL rehearsal_type;  ///<YES:彩排中 NO:未彩排
@property (nonatomic, assign) NSInteger live_subtitle_type; ///<0：关闭，1：中文转中文字幕，2：中文转中英字幕，3：中文转英文字幕，4：英文转英文字母，5：英文转中英字幕
@end

//直播初始化信息
@interface VHSSWebinarInitInfoModel : NSObject
@property (nonatomic, copy) NSString *paas_record_id;     ///<pass回放id
//--------------------活动信息 webinar------------------------
@property (nonatomic, copy) NSString *ID;     ///<活动id
@property (nonatomic, copy) NSString *subject;     ///<活动名称(带html标签)
@property (nonatomic, copy) NSString *img_url;     ///<活动封面图
@property (nonatomic, copy) NSString *introduction;     ///<活动简介
@property (nonatomic, assign) NSInteger mode;     ///<直播模式：1-音频、2-视频、3-互动
@property (nonatomic, copy) NSString *start_time;     ///<活动创建时，设置的开始时间
@property (nonatomic, copy) NSString *end_time;     ///<活动最近一次结束时间
@property (nonatomic, assign) NSInteger inav_num;     ///<当前活动设置的最大连麦人数 6表示1v5，16表示1v15
@property (nonatomic, assign) NSInteger no_delay_webinar;     ///<是否无延迟直播 1:是 0:否
@property (nonatomic, copy) NSString *actual_start_time;     ///<活动真实开始时间（最近一次开始的时间）
@property (nonatomic, assign) NSInteger type;       ///<1-直播中，2-预约，3-结束，4-点播，5-回放
@property (nonatomic, assign) NSInteger webinar_show_type;     ///<是否横屏 0:竖屏 1:横屏
@property (nonatomic, assign) NSInteger live_subtitle_type; ///<0：关闭，1：中文转中文字幕，2：中文转中英字幕，3：中文转英文字幕，4：英文转英文字母，5：英文转中英字幕
//--------------活动创建人信息 userinfo----------------------
@property (nonatomic, copy) NSString *author_nickname;     ///<作者昵称
@property (nonatomic, copy) NSString *author_avatar;     ///<作者头像
@property (nonatomic, copy) NSString *author_user_id;     ///作者id
//--------------参会人信息 join_info----------------------
@property (nonatomic, copy) NSString *join_nickname;     ///<昵称
@property (nonatomic, copy) NSString *join_avatar;     ///<头像
@property (nonatomic, copy) NSString *third_party_user_id;     ///<vss用户id
@property (nonatomic, copy) NSString *join_id;     ///<sass参会id
@property (nonatomic, copy) NSString *role_name;     ///<角色 1主持人 2观众 3助理 4嘉宾
@property (nonatomic, assign) NSInteger is_gag;     ///<是否禁言：0-不禁言（默认），1-禁言
@property (nonatomic, assign) NSInteger is_kick;     ///<是否禁言：0-不踢出（默认），1-踢出
@property (nonatomic, copy) NSString *privacies;     ///<私密信息
//----------------interact--------------------
@property (nonatomic, copy) NSString *room_id;     ///<房间id
@property (nonatomic, copy) NSString *channel_id;  ///<渠道id
@property (nonatomic, copy) NSString *inav_id;     ///<互动id
@property (nonatomic, copy) NSString *interact_token;  ///<互动token
@property (nonatomic, copy) NSString *paas_app_id;  ///<paas_app_id
@property (nonatomic, copy) NSString *paas_access_token;  ///<paas_access_token

//-----------------sso-----------------------
@property (nonatomic, copy) NSString *kick_id;     ///<单点观看，用户唯一标识
@property (nonatomic, assign) NSInteger sso_enabled;     ///<单点观看开关

//--------------在线人数 online----------------------
@property (nonatomic, assign) NSUInteger online_virtual;     ///<虚拟在线人数
@property (nonatomic, assign) NSUInteger online_real;      ///<真实在线人数
@property (nonatomic, assign) BOOL online_show;    ///<是否显示
//--------------热度 pv----------------------
@property (nonatomic, assign) NSUInteger pv_virtual;     ///<虚拟热度
@property (nonatomic, assign) NSUInteger pv_real;      ///<真实热度
@property (nonatomic, assign) BOOL pv_show;        ///<是否显示
//--------------云导播机位初始化----------------------
@property (nonatomic, copy) NSString *seatId;
@property (nonatomic, copy) NSString *seatName;
@property (nonatomic, copy) NSString *seatRoomid;
//--------------上报数据 report_data----------------------
@property (nonatomic, copy) NSString *vid;      ///<直播发起者账号
@property (nonatomic, copy) NSString *vfid;     ///<直播发起者父账号
@property (nonatomic, copy) NSString *guid;     ///<所有观众唯一标识
@property (nonatomic, copy) NSString *biz_id;     ///<教育版业务ID
@property (nonatomic, copy) NSString *report_extra;   ///<额外上报参数

//-------------------场次信息-------------------------------
@property (nonatomic, copy) NSString *switch_id;   ///<场次信息

@property (nonatomic, assign) NSInteger live_type;  ///<0-直播；2-彩排

@property (nonatomic, assign) BOOL live_rehearsal; ///<是否有彩排权限

@property (nonatomic, strong) NSDictionary *member_level;
@property (nonatomic, assign) NSInteger member_level_status;   ///<1展示 0关闭

@property (nonatomic, copy) NSDictionary *data;  //原始数据
- (instancetype)initWithDict:(NSDictionary *)dict;
@end

//发起端
@interface VHSSWebinarLiveInitInfoModel : VHSSWebinarInitInfoModel

@property (nonatomic, strong) NSArray *permission;     ///<权限 详见：http://yapi.vhall.domain/project/99/interface/api/24939
@end

//观看端 活动信息
@interface VHSSWebinarWatchInitInfoModel : VHSSWebinarInitInfoModel

@property (nonatomic, copy) NSString *cheat_num;     ///<欺骗系数
@property (nonatomic, copy) NSString *visitor_id;     ///<访客id
@property (nonatomic, assign) NSInteger cast_screen;     ///<投屏权限：0-无权限投屏，1-有权限投屏
@end

//活动角色配置
@interface VHSSWebinarPrivilegeModel : NSObject
@property (nonatomic, copy) NSString *webinar_id;       ///<活动id
@property (nonatomic, assign) NSInteger is_privilege;     ///<是否开启角色
@property (nonatomic, copy) NSString *guest_password;     ///<嘉宾密码
@property (nonatomic, copy) NSString *assistant_password;     ///<助理密码
@property (nonatomic, copy) NSString *start_time;     ///<开始时间
@property (nonatomic, copy) NSString *subject;     ///<活动标题
@property (nonatomic, copy) NSString *join_link;     ///<助理加入链接
@property (nonatomic, copy) NSString *guest_join_link;     ///<嘉宾加入链接
@property (nonatomic, copy) NSString *nick_name;     ///<活动主办方
@property (nonatomic, strong) NSDictionary *guest;     ///<嘉宾权限数据
@property (nonatomic, strong) NSDictionary *assistant;     ///<助理权限数据

+ (instancetype)initWithDict:(NSDictionary *)dict;
@end

@interface VHSSWebinarModel : NSObject

@end

NS_ASSUME_NONNULL_END
