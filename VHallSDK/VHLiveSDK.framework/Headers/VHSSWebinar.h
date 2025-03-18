//
//  VHSSWebinar.h
//  VHVss
//
//  Created by xiongchao on 2020/11/13.
//  Copyright © 2020 vhall. All rights reserved.
//
//活动服务
#import <Foundation/Foundation.h>
#import "VHSSWebinarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VHSSWebinar : NSObject

/// 创建活动，返回活动id
/// @param param 参数
/// @param success 成功回调
/// @param fail 失败回调
+ (void)createWebinarWithParam:(NSDictionary *)param success:(void (^)(NSString *webinarId))success fail:(void (^)(NSError *error))fail;


/// 修改活动，返回活动id
/// @param param 参数
/// @param success 成功回调
/// @param fail 失败回调
+ (void)changeWebinarWithParam:(NSDictionary *)param success:(void (^)(NSString *webinarId))success fail:(void (^)(NSError *error))fail;


/// 创建或修改活动，返回活动id
/// @param param 参数
/// @param isChange 是否为修改活动
/// @param success 成功
/// @param fail 失败
+ (void)createWebinarWithParam:(NSDictionary *)param isChange:(BOOL)isChange success:(void (^)(NSString *webinarId))success fail:(void (^)(NSError *_Nonnull error))fail;

/// 获取标签列表接口
/// @param webinar_id 活动id
/// @param success 成功
/// @param failure 失败
+ (void)requestLabelGetListWebinar_id:(NSString *)webinar_id success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure;

/// 获取暖场视频详情
/// @param webinar_id 活动id
/// @param success 成功
/// @param failure 失败
+ (void)requestWarmInfoWebinar_id:(NSString *)webinar_id success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure;

/// 章节打点数据
/// @param record_id 回放id
/// @param success 成功
/// @param failure 失败
+ (void)requesRecordDocInfo:(NSString *)record_id success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure;

/// 获取用户活动列表
/// @param userId 用户id
/// @param pos 查询条目节点，默认为0
/// @param limit 本次查询条目数量，最大100
/// @param orderType 排序方式 1 按照创建时间排序 2 按照最后直播时间排序
/// @param webinarStates  直播状态 默认为0 可以传入多个值 使用逗号分隔  0 全部 2 预告 1 直播 3 结束 5 回放 4 点播
/// @param needFlash 是否需要flash数据 0 否 1 是
/// @param webnarTitle 活动标题
/// @param start_time 检索开始
/// @param end_time 检索结束
/// @param success 成功回调
/// @param fail 失败回调
+ (void)getWebinarListWithUserId:(NSString *)userId pos:(NSInteger)pos limit:(NSInteger)limit orderType:(NSInteger)orderType webinarStates:(NSString *)webinarStates needFlash:(NSInteger)needFlash webinarTitle:(NSString *_Nullable)webnarTitle start_time:(NSString *)start_time end_time:(NSString *)end_time success:(void (^)(NSArray <VHSSWebinarListModel *> *list, BOOL haveNextPage))success fail:(void (^)(NSError *error))fail;

/// 获取活动基础信息
/// @param webinarId 活动id
/// @param no_check 检查是否属于当前用户 YES 不检查 NO 检查
/// @param success 成功回调
/// @param fail 失败回调
+ (void)getWebinarBaseInfoWithWebinarId:(NSString *)webinarId is_no_check:(BOOL)no_check success:(void (^)(VHSSWebinarBaseInfoModel *webinarBaseInfo))success fail:(void (^)(NSError *error))fail;

/// 发起端初始化直播间
/// @param webinarId 活动id
/// @param nickname 发直播昵称
/// @param email 邮箱
/// @param live_token 参会token
/// @param check_online 是否检测在线：0-否，1-是（默认）
/// @param success 成功回调
/// @param fail 失败回调
+ (void)liveInitWithWebinarId:(NSString *)webinarId nickname:(NSString *_Nullable)nickname email:(NSString *_Nullable)email live_token:(NSString *_Nullable)live_token check_online:(NSString *)check_online success:(void (^)(VHSSWebinarLiveInitInfoModel *initModel))success fail:(void (^)(NSError *error))fail;

/// 获取该活动下的回放列表
/// @param webinarId 活动id
/// @param pos 查询条目节点，默认为0
/// @param limit 本次查询条目数量，最大100
/// @param success 成功回调
/// @param fail 失败回调
+ (void)getRecordListWithWebinarId:(NSString *)webinarId pos:(NSInteger)pos limit:(NSInteger)limit success:(void (^)(NSArray * list))success fail:(void (^)(NSError *error))fail;

/// 获取控制台/观看端 自定义菜单绑定文件列表
/// @param webinarId 活动id
/// @param menu_id 自定义菜单ID
/// @param success 成功回调
/// @param fail 失败回调
+ (void)getFileDownLoadWithWebinarId:(NSString *)webinarId menu_id:(NSString *)menu_id success:(void (^)(NSDictionary *response))success fail:(void (^)(NSError *error))fail;

// 观看端 检测下载
+ (void)getCheckDownloadWithWebinarId:(NSString *)webinarId menu_id:(NSString *)menu_id file_id:(NSString *)file_id success:(void (^)(NSDictionary *response))success fail:(void (^)(NSError *error))fail;

/// 云导播初始化机位
/// @param webinarId 活动id
/// @param nickname 昵称
/// @param email 邮箱
/// @param live_token 直播token
/// @param seatId  机位id
/// @param checkHostLine 是否检查主持人，0 不检查， 1 检查
/// @param success 成功回调
/// @param fail 失败回调
+ (void)directorSeatInit:(NSString *)webinarId nickname:(NSString *_Nullable)nickname email:(NSString *_Nullable)email live_token:(NSString *_Nullable)live_token seatID:(NSString *)seatId checkHostLine:(NSString *)checkHostLine success:(void (^)(VHSSWebinarLiveInitInfoModel *initModel))success fail:(void (^)(NSError *error))fail;

/// 观看端初始化直播间
/// @param webinarId      活动id
/// @param pass                 活动观看密码或k值
/// @param k_id                 观看活动维度下k值的唯一ID
/// @param nickname        昵称
/// @param email               邮箱
/// @param record_id      回放id
/// @param auth_model      0 : 校验观看权限(默认)  1 : 不校验观看权限
/// @param success          成功回调
/// @param fail                 失败回调
+ (void)watchInitWithWebinarId:(NSString *)webinarId
                          pass:(NSString *_Nullable)pass
                          k_id:(NSString *_Nullable)k_id
                      nickname:(NSString *_Nullable)nickname
                         email:(NSString *_Nullable)email
                     record_id:(NSString *_Nullable)record_id
                    auth_model:(NSInteger)auth_model
                       success:(void (^)(VHSSWebinarWatchInitInfoModel *initModel))success
                          fail:(void (^)(NSError *error))fail;

/// 活动观看权限
/// @param webinar_id 活动id
/// @param type 0:免费（默认），1:密码，2：白名单，3：付费，4：邀请码
/// @param verify_value 邀请码、密码、白名单（邮箱|手机|工号|其他）
/// @param success 成功回调
/// @param fail 错误回调
+ (void)getWatchSDKAuthWithWebinarId:(NSString *)webinar_id
                                type:(NSString *_Nullable)type
                        verify_value:(NSString *_Nullable)verify_value success:(void (^)(NSDictionary *responseObject))success
                                fail:(void (^)(NSError *error))fail;

/// 分享详情
/// @param webinarId 活动id
+ (void)liveShareInfo:(NSString *)webinarId success:(void (^)(NSDictionary *responseObject))success fail:(void (^)(NSError *error))fail;

/// 获取活动角色权限配置
/// @param webinarId 活动id
/// @param success 成功回调
/// @param fail 失败回调
+ (void)getWebinarPrivilegeWithWebinarId:(NSString *)webinarId success:(void (^)(VHSSWebinarPrivilegeModel *model))success fail:(void (^)(NSError *error))fail;


/// 开启关闭角色开关
/// @param webinarId 活动id
/// @param is_privilege 是否开启 1 开启 0 关闭
/// @param success 成功回调
/// @param fail 失败回调
+ (void)setWebinarPrivilegeWithWebinarId:(NSString *)webinarId is_privilege:(NSInteger)is_privilege success:(void (^)(VHSSWebinarPrivilegeModel *privilegeModel))success fail:(void (^)(NSError *error))fail;


/// 开始直播
/// @param webinar_id 活动id
/// @param live_token 参会token
/// @param live_type 开播类型：0-正式直播（默认）；2-彩排
/// @param success 成功
/// @param fail 失败
+ (void)liveStartWithWebinarId:(NSString *)webinar_id nickname:(NSString *_Nullable)nickname liveToken:(NSString *_Nullable)live_token live_type:(NSString *_Nullable)live_type success:(void (^)(void))success fail:(void (^)(NSError *error))fail;

/// 结束直播
/// @param webinar_id 活动id
/// @param live_token 参会token
/// @param live_type 开播类型：0-正式直播（默认）；2-彩排
/// @param success 成功
/// @param fail 失败
+ (void)liveEndWithWebinarId:(NSString *)webinar_id liveToken:(NSString *_Nullable)live_token live_type:(NSString *_Nullable)live_type success:(void (^)(void))success fail:(void (^)(NSError *error))fail;

/// 发起端-直播结束生成回放
/// @param webinar_id 活动id
/// @param live_token 参会token
/// @param live_type 开播类型：0-正式直播（默认）；2-彩排
/// @param success 成功
/// @param fail 失败
+ (void)liveCreateRecordWithWebinarId:(NSString *)webinar_id liveToken:(NSString *_Nullable)live_token live_type:(NSString *_Nullable)live_type success:(void (^)(NSDictionary *responseObject))success fail:(void (^)(NSError *error))fail;

/// 发起端-直播结束设置默认回放
/// @param record_id 回放id
/// @param live_token 参会token
/// @param success 成功
/// @param fail 失败
+ (void)liveSetDefaultRecordWithRecord_id:(NSString *)record_id liveToken:(NSString *_Nullable)live_token success:(void (^)(void))success fail:(void (^)(NSError *error))fail;

/// 口令用户登录验证
/// @param type 角色（1-主持人，2-嘉宾，3-助理）
/// @param webinarId 活动id
/// @param password 口令
/// @param nickName 昵称，type不为1时必填
/// @param avatar 头像（可选）
/// @param visitor_id 访客唯一标识
/// @param success 成功
/// @param failure 失败
+ (void)passUserLoginWithType:(NSInteger)type webinarId:(NSString *)webinarId password:(NSString *)password nickName:(NSString *_Nullable)nickName avatar:(NSString *_Nullable)avatar visitor_id:(NSString *_Nullable)visitor_id success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure;

/// 口令用户登出
/// @param webinarId 活动id
+ (void)passUserLogOutWithWebinarId:(NSString *)webinarId success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure;

/// 检测配置项权限（前端使用）
/// @param webinarId 活动id （活动id，1、传活动id时，返回活动id+活动创建者相关的配置项信息 2、不传活动id时，获取登录用户的配置项信息）
/// @param webinar_user_id （传webinar_id时，必传webinar_user_id）
/// @param scene_id 使用场景：1权限检测（默认1）  2获取配置项选中值
+ (void)getConfigListWithWebinarId:(NSString *_Nullable)webinarId webinar_user_id:(NSString *_Nullable)webinar_user_id scene_id:(NSString *_Nullable)scene_id success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure;


/// 获取多语种 http://yapi.vhall.domain/project/99/interface/api/44437
/// @param webinarId 活动id
+ (void)getLanguageWithWebinarId:(NSString *)webinarId success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure;
///获取角色名称 参数 webinarId:活动id http://yapi.vhall.domain/project/99/interface/api/49695
+ (void)getRoleName:(NSDictionary *)roleDic success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure;
///获取角色配置
+ (void)getRoleInfo:(NSDictionary *)roleInfoDic success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure;
///修改角色
+ (void)editRoleInfo:(NSDictionary *)editInfoDic success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure;
///获取房间初始化信息
+ (void)fetchLiveInitRoomInfo:(NSString *)activityId success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure;
///获取美颜权限的passs值
+ (void)fetchBeautyEnable:(NSString *)activityId callBackPassToken:(void (^)(NSString *))paas_access_token;
///观看协议 http://yapi.vhall.domain/project/101/interface/api/cat_8860
///观看端获取协议
+ (void)fetchViewingProtocol:(NSString *)webinarId success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure;

//同意观看协议
+ (void)agreeViewingProtocol:(NSString *)webinarId success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure;

///云导播活动
///http://yapi.vhall.domain/project/99/interface/api/cat_8936
///查看云导播状态
+ (void)fetchCloudBroadcastStatus:(NSString *)webinarId success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure;
///获取机位列表
+ (void)fetchSeatList:(NSString *)webinarId success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure;
///选择推流机位
+ (void)selectSeat:(NSString *)webinarId seatId:(NSString *)seatId deviceUUID:(NSString *)UUID success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure;
///机位初始化
+ (void)seatInit:(NSString *)webinarId seatId:(NSString *)seatId checkHostOnline:(NSString *)check_online success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure;
///云导播以主持人身份发起直播获取直播间状态
+ (void)fetchCloudBrocastStreamStatus:(NSString *)webinarId success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
