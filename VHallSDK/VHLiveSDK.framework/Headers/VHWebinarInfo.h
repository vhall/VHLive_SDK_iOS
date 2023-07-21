//
//  VHWebinarInfo.h
//  VHallSDK
//
//  Created by xiongchao on 2020/12/17.
//  Copyright © 2020 vhall. All rights reserved.
//
//活动相关信息，注意：此类信息仅限新版控制台(v3及以上)创建的活动使用，否则部分属性无值
#import <Foundation/Foundation.h>
#import "VHallConst.h"
#import "VHallRawBaseModel.h"
#import "VHLotteryListModel.h"
#import "VHSurveyListModel.h"
#import "VHWebinarInfoData.h"
#import "VHRecordListModel.h"

@class VHWebinarScrollTextInfo;
@class VHRoleNameData;

@class VHViewProtocolModel;
@class VHStatementModel;

@class VHDirectorModel;
@class VHSeatModel;

NS_ASSUME_NONNULL_BEGIN

//菜单
@interface VHallPlayMenuModel : VHallRawBaseModel
///id
@property (nonatomic, copy) NSString *ID;
///名称
@property (nonatomic, copy) NSString *name;
///类型
@property (nonatomic, assign) NSInteger type;
///状态
@property (nonatomic, assign) NSInteger status;
@end

// 检测配置项权限
@interface VHPermissionConfigItem : VHallRawBaseModel

@property (nonatomic, assign) BOOL watch_hide_like;                                             ///<是否开启点赞
@property (nonatomic, assign) BOOL hide_gifts;                                                  ///<是否开启礼物
@property (nonatomic, assign) BOOL watch_record_no_chatting;                                    ///<是否开启回放禁言
@property (nonatomic, assign) BOOL watch_record_chapter;                                        ///<是否开启回放章节打点

@end

// 角色信息
@interface VHRoleNameData : NSObject
@property (nonatomic, copy) NSString *host_name;        ///<主持人角色名称
@property (nonatomic, copy) NSString *guest_name;       ///<嘉宾角色名称
@property (nonatomic, copy) NSString *assist_name;      ///<助理角色名称
@end

// 观看协议模型数据
@interface VHViewProtocolModel : NSObject
@property (nonatomic, copy, readonly) NSArray<VHStatementModel *> *statement_info;      ///<协议介绍
@property (nonatomic, copy, readonly) NSString *statement_content;                      ///<协议提示内容
@property (nonatomic, copy, readonly) NSString *title;                                  ///<观看协议title
@property (nonatomic, copy, readonly) NSString *content;                                ///<观看协议content
@property (nonatomic, assign, readonly) NSInteger is_agree;                             ///<用户协议是否同意 0-未同意，1-同意
@property (nonatomic, assign, readonly) NSInteger is_open;                              ///<观看协议开关0-关闭，1-打开
@property (nonatomic, assign, readonly) NSInteger rule;                                 ///<协议规则rule 0-强制，1-非强制
@property (nonatomic, assign, readonly) NSInteger statement_status;                     ///<声明状态 0-关 1-开
@end

// 协议介绍
@interface VHStatementModel : NSObject
@property (nonatomic, copy, readonly) NSString *title;  ///<协议
@property (nonatomic, copy, readonly) NSString *link;   ///<协议链接
@end

// 云导播台详情
@interface VHDirectorModel : NSObject
@property (nonatomic, readonly) NSInteger director_status;                      ///<云导播台开启状态 0-未开启 1-已开启
@property (nonatomic, readonly) NSArray <VHSeatModel *> *seatList; ///<机位列表(可用状态+机位id+机位名称)
@end

// 机位详情
@interface VHSeatModel : NSObject
@property (nonatomic, copy, readonly) NSString *name;              ///<机位名称
@property (nonatomic, copy, readonly) NSString *seat_id;           ///<机位ID
@property (nonatomic, readonly) NSInteger seat_status;          ///<机位状态
@end

// 跑马灯配置信息
@interface VHWebinarScrollTextInfo : NSObject
@property (nonatomic, copy, readonly) NSString *webinar_id;        ///<活动id
@property (nonatomic, copy, readonly) NSString *color;             ///<十六进制色值 如：#FFFFFF
@property (nonatomic, copy, readonly) NSString *text;              ///<文本内容
@property (nonatomic, assign, readonly) NSInteger scrolling_open;       ///<是否开启跑马灯  1：开启 0：关闭
@property (nonatomic, assign, readonly) NSInteger text_type;       ///<文本显示格式，1：固定文本 2：固定文本+观看者id和昵称
@property (nonatomic, assign, readonly) NSInteger alpha;           ///<不透明度，如：60%不透明度，则属性值为60
@property (nonatomic, assign, readonly) NSInteger size;            ///<字号
@property (nonatomic, assign, readonly) NSInteger interval;        ///<间隔时间，秒
@property (nonatomic, assign, readonly) NSInteger speed;           ///<滚屏速度 10000：慢 6000：中 3000：快
@property (nonatomic, assign, readonly) NSInteger position;        ///<显示位置 1：随机 2：上 3：中 4：下
@end

// 活动基础信息
@interface VHWebinarBaseInfo : NSObject

@property (nonatomic, strong) id data;                             ///<活动详情原数据
@property (nonatomic) VHRoleNameData *roleData;                    ///<角色数据
@property (nonatomic) VHWebinarLiveType webinar_type;           ///<1 音频直播 2 视频直播 3 互动直播
@property (nonatomic) VHMovieActiveState type;                     ///<1-直播中，2-预约，3-结束，4-点播，5-回放
@property (nonatomic) NSInteger webinar_show_type;              ///<横竖屏 0竖屏 1横屏
@property (nonatomic) NSInteger no_delay_webinar;               ///<是否无延迟直播 1:是 0:否
@property (nonatomic) NSInteger inav_num;                          ///<当前活动设置的最大连麦人数， 如：6表示1v5，16表示1v15...
@property (nonatomic) BOOL allowAdvanceBeauty;                  ///<获取美颜权限结果
@property (nonatomic) BOOL rehearsal_type;                      ///<YES:彩排中 NO:未彩排
@property (nonatomic, readonly) NSInteger is_director;             ///<能否使用云导播功能 0-否 1-是
@property (nonatomic, copy) NSString *ID;                          ///<活动id
@property (nonatomic, copy) NSString *user_id;                     ///<活动创建者用户id
@property (nonatomic, copy) NSString *subject;                     ///<标题
@property (nonatomic, copy) NSString *introduction;             ///<简介
@property (nonatomic, copy) NSString *img_url;                     ///<封面图片
@property (nonatomic, copy) NSString *category;                    ///<类别，eg：金融
@property (nonatomic, copy) NSString *start_time;                  ///<直播开始时间
@property (nonatomic, copy) NSString *actual_start_time;        ///<实际开始时间
@property (nonatomic, copy) NSString *end_time;                    ///<直播结束时间
@property (nonatomic, assign) NSInteger live_subtitle_type; ///<0：关闭，1：中文转中文字幕，2：中文转中英字幕，3：中文转英文字幕，4：英文转英文字母，5：英文转中英字幕

/// 查询活动基础信息
/// @param webinarId 活动id
/// @param success 成功
/// @param fail 失败
+ (void)getWebinarBaseInfoWithWebinarId:(NSString *)webinarId
                                success:(void (^)(VHWebinarBaseInfo *baseInfo))success
                                   fail:(void (^)(NSError *error))fail;

/// 获取活动权限检测
/// @param webinarId 活动id 1、传活动id时，返回活动id+活动创建者相关的配置项信息 2、不传活动id时，获取登录用户的配置项信息
/// @param webinar_user_id 活动发起者用户id，有webinar_id时，必传
/// @param scene_id 使用场景：1权限检测（默认1）  2获取配置项选中值
/// @param success 成功
/// @param failure 失败
+ (void)permissionsCheckWithWebinarId:(NSString *)webinarId
                      webinar_user_id:(NSString *)webinar_user_id
                             scene_id:(NSString *)scene_id
                              success:(void (^)(VHPermissionConfigItem *item))success
                              failure:(void (^)(NSError *error))failure;

/// 返回角色数据
/// @param webinarId 活动id
/// @param roleNameData 角色信息
+ (void)getRoleNameWebinar_id:(NSString *)webinarId
                 dataCallBack:(void (^)(VHRoleNameData *))roleNameData;

/// 开启观看协议需前置获取观看协议
/// @param webinarId 活动id
/// @param success 观看协议数据
/// @param fail 失败
+ (void)fetchViewProtocol:(NSString *)webinarId
                  success:(void (^)(VHViewProtocolModel *protocolModel))success
                     fail:(void (^)(NSError *error))fail;
/// 同意观看协议
/// @param webinarId 活动id
/// @param success 成功
/// @param fail 失败
+ (void)agreeViewProtocol:(NSString *)webinarId
                  success:(void (^)(void))success
                     fail:(void (^)(NSError *error))fail;

/// 获取问卷历史
/// @param webinarId 活动id
/// @param roomId 房间id
/// @param switchId 场次id
/// @param success 成功
/// @param fail 失败
+ (void)fetchSurveyListWebinarId:(NSString *)webinarId
                          roomId:(NSString *)roomId
                        switchId:(NSString *)switchId
                         success:(void (^)(VHSurveyListModel *listModel))success
                            fail:(void (^)(NSError *error))fail;

/// 获取抽奖列表接口
/// @param showAll 是否需要展示所有抽奖 0-否(默认：仅展示进行中、已中奖抽奖) 1-全部抽奖 2 已中奖抽奖（sdk专用）
/// @param webinarId 活动id
/// @param success 成功
/// @param fail 失败
+ (void)fetchLotteryListShowAll:(NSInteger)showAll
                      webinarId:(NSString *)webinarId
                        success:(void (^)(VHLotteryListModel *listModel))success
                           fail:(void (^)(NSError *error))fail;

/// 获取指定活动下的回放列表
/// - Parameters:
///   - webinarId: 活动id
///   - pageNum: 页数
///   - pageSize: 一页几个
///   - complete: 返回结果的回调
+ (void)getRecordListWithWebinarId:(NSString *)webinarId
                           pageNum:(NSInteger)pageNum
                          pageSize:(NSInteger)pageSize
                          complete:(void (^)(NSArray <VHRecordListModel *> *recordList, NSError *error))complete;

#pragma mark - 云导播活动
/// 导播台是否开启 director_status=YES:已开启，NO:未开启
/// @param webinarId 活动id
/// @param success 成功
/// @param fail 失败
+ (void)getDirectorStatusWithWebinarId:(NSString *)webinarId
                               success:(void (^)(BOOL director_status))success
                                  fail:(void (^)(NSError *error))fail;
/// 以视频推流到云导播获取机位列表
/// @param webinarId 活动id
/// @param success 成功
/// @param fail 失败
+ (void)getSeatList:(NSString *)webinarId
            success:(void (^)(VHDirectorModel *directorModel))success
               fail:(void (^)(NSError *error))fail;
/// 选择机位
/// @param webinarId 活动id
/// @param seatId 机位id
/// @param success 成功
/// @param fail 失败
+ (void)selectSeatWithWebinarId:(NSString *)webinarId
                         seatId:(NSString *)seatId
                        success:(void (^)(BOOL))success
                           fail:(void (^)(NSError *error))fail;
/// 云导播台的房间流状态
/// @param webinarId 活动id
/// @param success 成功
/// @param fail 失败
+ (void)getDirectorRoomStreamStatus:(NSString *)webinarId
                            success:(void (^)(BOOL isHaveStream))success
                               fail:(void (^)(NSError *error))fail;

@end

@protocol VHWebinarInfoDelegate <NSObject>

/// 房间人数改变回调 （目前仅支持真实人数改变触发此回调）
/// @param online_real 真实在线用户数
/// @param online_virtual 虚拟在线用户数
- (void)onlineChangeRealNum:(NSUInteger)online_real virtualNum:(NSUInteger)online_virtual;

@end

// 活动详情
@interface VHWebinarInfo : NSObject

@property (nonatomic, weak) id<VHWebinarInfoDelegate> delegate; ///<代理

@property (nonatomic, readonly) id data;                                        ///<活动详情原数据
@property (nonatomic, readonly) VHWebinarInfoData *webinarInfoData;             ///<活动详情数据模型
@property (nonatomic, readonly) VHWebinarLiveType liveType;                     ///<活动直播类型 （视频、音频、互动）
@property (nonatomic, readonly) VHMovieActiveState liveState;                   ///<活动直播状态  (直播、预告、结束、点播/回放)
@property (nonatomic, readonly) VHWebinarScrollTextInfo *scrollTextInfo;        ///<跑马灯信息
@property (nonatomic, copy, readonly) NSString *webinarId;                      ///<活动id
@property (nonatomic, copy, readonly) NSString *join_id;                        ///<自己的参会id
@property (nonatomic, copy, readonly) NSString *subject;                        ///<活动名称
@property (nonatomic, copy, readonly) NSString *img_url;                        ///<活动封面图
@property (nonatomic, copy, readonly) NSString *author_userId;                  ///<活动发起者用户id
@property (nonatomic, copy, readonly) NSString *author_nickname;                ///<活动发起者昵称
@property (nonatomic, copy, readonly) NSString *author_avatar;                  ///<活动发起者头像
@property (nonatomic, readonly) NSUInteger online_real;                         ///<真实在线人数（该值会随房间人数改变实时更新）
@property (nonatomic, readonly) NSUInteger online_virtual;                      ///<虚拟在线人数
@property (nonatomic, readonly) NSUInteger pv_real;                             ///<真实热度
@property (nonatomic, readonly) NSUInteger pv_virtual;                          ///<虚拟热度
@property (nonatomic, readonly) BOOL pv_show;                                   ///<是否显示热度
@property (nonatomic, readonly) BOOL online_show;                               ///<是否显示在线人数
@property (nonatomic, readonly) NSInteger inav_num;                             ///<当前活动设置的支持大连麦人数， 如：6表示1v5，16表示1v15...
@property (nonatomic, readonly) NSInteger speakerAndShowLayout;                   ///<0 -- 分离模式；1 -- 合并模式；
@property (nonatomic, readonly) NSInteger live_subtitle_type; ///<0：关闭，1：中文转中文字幕，2：中文转中英字幕，3：中文转英文字幕，4：英文转英文字母，5：英文转中英字幕

@end

NS_ASSUME_NONNULL_END
