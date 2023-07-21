//
//  VHWebinarInfoData.h
//  VHallSDK
//
//  Created by 郭超 on 2022/8/31.
//  Copyright © 2022 vhall. All rights reserved.
//  房间详情数据

#import <Foundation/Foundation.h>

@interface VHWebinarInfoData_Join_info : NSObject
@property (nonatomic, copy) NSString *third_party_user_id;                              ///<用户id
@property (nonatomic, copy) NSString *join_id;                                          ///<sass参会id
@property (nonatomic, copy) NSString *avatar;                                           ///<头像
@property (nonatomic, copy) NSString *privacies;                                        ///<私密信息
@property (nonatomic, copy) NSString *nickname;                                         ///<昵称
@property (nonatomic, assign) BOOL is_kick;                                             ///<是否踢出：0-否（默认），1-是
@property (nonatomic, assign) BOOL is_gag;                                              ///<是否禁言：0-不禁言（默认），1-禁言
@property (nonatomic, assign) BOOL is_subscribe;                                        ///<是否预约：0-否，1-是
@property (nonatomic, assign) NSInteger verified;                                       ///<是否已通过观看限制（不含报名表单）
@property (nonatomic, assign) NSInteger role_name;                                      ///<角色：1-主持人；2-观众；3-助理；4-嘉宾
@property (nonatomic, assign) NSInteger user_id;                                        ///<
@property (nonatomic, assign) NSInteger activity_consumer_uid;                          ///<
@property (nonatomic, assign) NSInteger reg_form;                                       ///<是否已填写报名表单
@end


@interface VHWebinarInfoData_Pv : NSObject
@property (nonatomic, assign) BOOL show;                                                ///<是否显示
@property (nonatomic, assign) NSInteger real;                                           ///<真实pv数
@property (nonatomic, assign) NSInteger data_virtual;                                   ///<虚拟pv数
@end


@interface VHWebinarInfoData_Record : NSObject
@property (nonatomic, copy) NSString *record_id;                                        ///<默认回放ID
@property (nonatomic, copy) NSString *preview_paas_record_id;                           ///<试看paas_record_id
@property (nonatomic, copy) NSString *paas_record_id;                                   ///<回放paas_record_id
@property (nonatomic, assign) NSInteger encrypt_status;                                 ///<0:未加密 1:加密中 2:加密成功
@property (nonatomic, assign) NSInteger record_remark_layout;                           ///<回放重置布局：0-无 1-三分屏 2-画中画 3-纯文档
@end


@interface VHWebinarInfoData_Interact : NSObject
@property (nonatomic, copy) NSString *channel_id;                                       ///<渠道id
@property (nonatomic, copy) NSString *inav_id;                                          ///<互动id
@property (nonatomic, copy) NSString *room_id;                                          ///<房间id
@property (nonatomic, copy) NSString *paas_app_id;                                      ///<应用id
@property (nonatomic, copy) NSString *interact_token;                                   ///<互动token
@property (nonatomic, copy) NSString *paas_access_token;                                ///<PaaStoken
@property (nonatomic, copy) NSString *subscribe_paas_access_token;                                ///<预约PaaStoken
@end


@interface VHWebinarInfoData_Agreement : NSObject
@property (nonatomic, assign) BOOL is_open;                                             ///<是否开启观看协议：0-关闭；1-开启
@property (nonatomic, assign) BOOL is_agree;                                            ///<用户是否同意观看协议：0-未同意；1-已同意
@end

@interface VHWebinarInfoData_Webinar_Userinfo : NSObject
@property (nonatomic, copy) NSString *nickname;                                         ///<昵称
@property (nonatomic, copy) NSString *company;                                          ///<公司
@property (nonatomic, copy) NSString *avatar;                                           ///<头像地址
@property (nonatomic, copy) NSString *user_id;                                          ///<用户id
@end


@interface VHWebinarInfoData_Webinar : NSObject
@property (nonatomic, strong) VHWebinarInfoData_Webinar_Userinfo *userinfo;             ///<活动创建人
@property (nonatomic, copy) NSString *data_id;                                          ///<活动id
@property (nonatomic, copy) NSString *verify_tip;                                       ///<观看限制提示语
@property (nonatomic, copy) NSString *img_url;                                          ///<封面
@property (nonatomic, copy) NSString *verify_source;                                    ///<
@property (nonatomic, copy) NSString *subject;                                          ///<活动标题
@property (nonatomic, copy) NSString *category;                                         ///<类别
@property (nonatomic, copy) NSString *start_time;                                       ///<开始时间
@property (nonatomic, copy) NSString *introduction;                                     ///<活动介绍
@property (nonatomic, copy) NSString *end_time;                                         ///<结束时间
@property (nonatomic, copy) NSString *fee;                                              ///<观看费用
@property (nonatomic, copy) NSString *actual_start_time;                                ///<实际开始时间
@property (nonatomic, assign) BOOL hide_subscribe;                                      ///<预约按钮状态 1开启 0关闭
@property (nonatomic, assign) BOOL no_delay_webinar;                                    ///<无延迟直播：1-是，0-否
@property (nonatomic, assign) BOOL reg_form;                                            ///<是否开启报名表单
@property (nonatomic, assign) NSInteger is_director;                                    ///<
@property (nonatomic, assign) NSInteger type;                                           ///<1-直播中，2-预约，3-结束，4-点播，5-回放
@property (nonatomic, assign) NSInteger inav_num;                                       ///<
@property (nonatomic, assign) NSInteger document_id;                                    ///<
@property (nonatomic, assign) NSInteger live_time;                                      ///<
@property (nonatomic, assign) NSInteger mode;                                           ///<模式（1-音频、2-视频、3-互动、 4-文档、5-定时直播、6-分组讨论）
@property (nonatomic, assign) NSInteger webinar_show_type;                              ///<
@property (nonatomic, assign) NSInteger verify;                                         ///<验证类别，0 无验证，1 密码，2 白名单，3 付费活动, 4 F码, 6 F码+付费
@property (nonatomic, assign) NSInteger live_subtitle_type; ///<0：关闭，1：中文转中文字幕，2：中文转中英字幕，3：中文转英文字幕，4：英文转英文字母，5：英文转中英字幕

@end


@interface VHWebinarInfoData_Switch : NSObject
@property (nonatomic, copy) NSString *switch_id;                                        ///<场次id
@property (nonatomic, copy) NSString *start_time;                                       ///<开始时间
@property (nonatomic, copy) NSString *end_time;                                         ///<结束时间
@property (nonatomic, assign) NSInteger end_type;                                       ///<结束类型 1:WEB 2:APP 3:SDK 4:推拉流 5:定时 6:Admin后台
@property (nonatomic, assign) NSInteger type;                                           ///<类型 0 直播 1录制
@property (nonatomic, assign) NSInteger start_type;                                     ///<开始类型 1:WEB 2:APP 3:SDK 4:推拉流 5:定时 6:Admin后台
@end


@interface VHWebinarInfoData_Subscribe : NSObject
@property (nonatomic, assign) BOOL show;                                                ///<是否显示
@property (nonatomic, assign) NSInteger num;                                            ///<人数
@end


@interface VHWebinarInfoData_Online : NSObject
@property (nonatomic, assign) BOOL show;                                                ///<是否显示
@property (nonatomic, assign) NSInteger data_virtual;                                   ///<虚拟在线数
@property (nonatomic, assign) NSInteger real;                                           ///<真实在线数
@end


@interface VHWebinarInfoData : NSObject
@property (nonatomic, copy) NSString *system_time;                                      ///<系统时间
@property (nonatomic, copy) NSString *visitor_id;                                       ///<访客标识
@property (nonatomic, copy) NSString *paas_record_id;                                   ///<PaaS回放id
@property (nonatomic, assign) NSInteger cast_screen;                                    ///<
@property (nonatomic, assign) NSInteger live_type;                                      ///<0-直播；2-彩排
@property (nonatomic, assign) NSInteger cheat_num;                                      ///<
@property (nonatomic, assign) NSInteger record_remark_layout;                           ///<
@property (nonatomic, assign) NSInteger webinar_show_type;                              ///<
@property (nonatomic, strong) VHWebinarInfoData_Join_info *join_info;                   ///<加入用户信息
@property (nonatomic, strong) VHWebinarInfoData_Pv *pv;                                 ///<热度
@property (nonatomic, strong) VHWebinarInfoData_Record *record;                         ///<回放
@property (nonatomic, strong) VHWebinarInfoData_Interact *interact;                     ///<互动信息(PaaS信息)
@property (nonatomic, strong) VHWebinarInfoData_Agreement *agreement;                   ///<观看协议
@property (nonatomic, strong) VHWebinarInfoData_Webinar *webinar;                       ///<活动信息
@property (nonatomic, strong) VHWebinarInfoData_Switch *data_switch;                    ///<场次信息
@property (nonatomic, strong) VHWebinarInfoData_Subscribe *subscribe;                   ///<预约人数
@property (nonatomic, strong) VHWebinarInfoData_Online *online;                         ///<在线信息

/// 初始化整理数据
/// - Parameter data: 数据详情
- (instancetype)initWithData:(NSDictionary *)data;

/// 获取观看端房间详情
/// - Parameters:
///   - webinarId:  活动Id，必传
///   - pass:       活动如果有k值或密码，则需要传
///   - k_id:       观看活动维度下k值的唯一ID
///   - nick_name:  昵称
///   - email:      邮箱
///   - record_id:  回放id非必传
///   - auth_model: 0 : 校验观看权限(默认)  1 : 不校验观看权限
///   - complete:   请求完成,包含数据详情和错误信息
+ (void)requestWatchInitWebinarId:(NSString *)webinarId
                             pass:(NSString *)pass
                             k_id:(NSString *)k_id
                        nick_name:(NSString *)nick_name
                            email:(NSString *)email
                        record_id:(NSString *)record_id
                       auth_model:(NSInteger)auth_model
                         complete:(void (^)(VHWebinarInfoData *webinarInfoData, NSError *error))complete;


/// 检查活动设置的观看权限
/// - Parameters:
///   - webinar_id: 活动id
///   - complete: type : 1 需要密码 2 白名单校验 , authStatus : 校验权限 , error : 错误提示
+ (void)queryWatchAuthWithWebinarId:(NSString *)webinar_id
                           complete:(void (^)(NSString *type, BOOL authStatus, NSError *error))complete;

/// 校验活动观看权限
/// - Parameters:
///   - webinar_id: 活动id
///   - type: 0:免费（默认），1:密码，2：白名单
///   - verify_value: 密码、白名单参数
///   - complete: 请求完成,包含数据详情和错误信息
+ (void)checkWatchAuthWithWebinarId:(NSString *)webinar_id
                               type:(NSString *)type
                       verify_value:(NSString *)verify_value
                           complete:(void (^)(NSDictionary *responseObject, NSError *error))complete;

@end
