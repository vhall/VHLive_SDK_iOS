//
//  VHSSInteract.h
//  VHVss
//
//  Created by xiongchao on 2020/11/16.
//  Copyright © 2020 vhall. All rights reserved.
//
//互动服务
#import <Foundation/Foundation.h>
#import "VHSSInteractModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface VHSSInteract : NSObject

#pragma mark - 聚合接口
/// 互动配置聚合接口
/// @param webinar_id 活动ID
/// @param success 成功回调
/// @param fail 失败回调
+ (void)getUnionCommonConfigWithWebinar_id:(NSString *)webinar_id
                                   success:(void (^)(NSDictionary *responseObject))success
                                      fail:(void (^)(NSError *error))fail;
/// 互动播放器聚合配置
/// @param webinar_id 活动ID
/// @param success 成功回调
/// @param fail 失败回调
+ (void)getUnionPlayerConfigWithWebinar_id:(NSString *)webinar_id
                                   success:(void (^)(NSDictionary *responseObject))success
                                      fail:(void (^)(NSError *error))fail;

#pragma mark - 互动连麦
/// 上麦申请
/// @param roomId 房间id
/// @param success 成功回调
/// @param fail 失败回调
+ (void)applyWithRoomId:(NSString *)roomId success:(void (^)(NSDictionary *response))success fail:(void (^)(NSError *error))fail;

/// 取消申请上麦
/// @param roomId 房间id
/// @param success 成功回调
/// @param fail 失败回调
+ (void)cancelApplyWithRoomId:(NSString *)roomId success:(void (^)(NSDictionary *response))success fail:(void (^)(NSError *error))fail;


/// 同意用户上麦
/// @param roomId 房间id
/// @param receive_account_id 参会用户的uid
/// @param success 成功回调
/// @param fail 失败回调
+ (void)agreeApplyWithRoomId:(NSString *)roomId receive_account_id:(NSString *)receive_account_id success:(void (^)(NSDictionary *response))success fail:(void (^)(NSError *error))fail;

/// 拒绝用户上麦
/// @param roomId 房间id
/// @param receive_account_id 参会用户的uid
/// @param success 成功回调
/// @param fail 失败回调
+ (void)rejectApplyWithRoomId:(NSString *)roomId receive_account_id:(NSString *)receive_account_id success:(void (^)(NSDictionary *response))success fail:(void (^)(NSError *error))fail;


/// 用户同意上麦邀请
/// @param roomId 房间id
/// @param success 成功回调
/// @param fail 失败回调
+ (void)userAgreeInviteWithRoomId:(NSString *)roomId success:(void (^)(NSDictionary *response))success fail:(void (^)(NSError *error))fail;


/// 用户拒绝上麦邀请
/// @param roomId 房间id
/// @param success 成功回调
/// @param fail 失败回调
+ (void)userRejectInviteWithRoomId:(NSString *)roomId success:(void (^)(NSDictionary *response))success fail:(void (^)(NSError *error))fail;


/// 设置房间内已上麦用户下麦
/// @param roomId 房间id
/// @param receive_account_id 参会用户的uid
/// @param success 成功回调
/// @param fail 失败回调
+ (void)setNospeakWithRoomId:(NSString *)roomId receive_account_id:(NSString *)receive_account_id success:(void (^)(NSDictionary *response))success fail:(void (^)(NSError *error))fail;


/// 邀请用户上麦
/// @param roomId 房间id
/// @param receive_account_id 参会用户的uid
/// @param success 成功回调
/// @param fail 失败回调
+ (void)inviteWithRoomId:(NSString *)roomId receive_account_id:(NSString *)receive_account_id success:(void (^)(NSDictionary *response))success fail:(void (^)(NSError *error))fail;


/// 设置房间是否允许上麦
/// @param roomId 房间id
/// @param status 是否允许，1：允许 0：禁止
/// @param success 成功
/// @param fail 失败
+ (void)setHandsupWithRoomId:(NSString *)roomId status:(NSInteger)status success:(void (^)(NSDictionary *response))success fail:(void (^)(NSError *error))fail;

/// 用户上麦
/// @param roomId 房间id
/// @param success 成功
/// @param fail 失败
+ (void)userSpeakWithRoomId:(NSString *)roomId success:(void (^)(NSDictionary *response))success fail:(void (^)(NSError *error))fail;

/// 用户下麦
/// @param roomId 房间id
/// @param success 成功
/// @param fail 失败
+ (void)userNoSpeakWithRoomId:(NSString *)roomId success:(void (^)(NSDictionary *response))success fail:(void (^)(NSError *error))fail;

/// 获取轮询用户
/// @param roomId 房间 ID
/// @param is_next 是否是下一组， 0：当前组， 1：下一组
/// @param success 成功
/// @param fail 失败
+ (void)getRoundUsersWithRoomId:(NSString *)roomId is_next:(NSString *)is_next success:(void (^)(NSDictionary *response))success fail:(void (^)(NSError *error))fail;

#pragma mark 房间管理
/// 设置房间用户设备（麦克风、摄像头）状态
/// @param roomId 房间id
/// @param receive_account_id 参会id
/// @param device 1麦克风，2摄像头
/// @param status 0关闭1打开
/// @param success 成功
/// @param fail 失败
+ (void)setDeviceStatusWithRoomId:(NSString *)roomId receive_account_id:(NSString *)receive_account_id device:(NSInteger)device status:(NSInteger)status success:(void (^)(NSDictionary *response))success fail:(void (^)(NSError *error))fail;

/// 设置主画面
/// @param roomId 房间id
/// @param receive_account_id 参会id
/// @param success 成功
/// @param fail 失败
+ (void)setMainScreenWithRoomId:(NSString *)roomId receive_account_id:(NSString *)receive_account_id success:(void (^)(NSDictionary *response))success fail:(void (^)(NSError *error))fail;

/// 设置房间用户的设备检测状态
/// @param roomId 房间id
/// @param status 设备检测状态，0未检测1可以上麦2不可以上麦
/// @param type 设备类型，0未检测 1手机端 2PC 3sdk
/// @param success 成功
/// @param fail 失败
+ (void)setDeviceCheckWithRoomId:(NSString *)roomId status:(NSInteger)status type:(NSInteger)type success:(void (^)(NSDictionary *response))success fail:(void (^)(NSError *error))fail;

/// 设置主讲人/文档控制权限
/// @param roomId 房间id
/// @param receive_account_id 目标用户id
/// @param success 成功
/// @param fail 失败
+ (void)setDocPermissionWithRoomId:(NSString *)roomId receive_account_id:(NSString *)receive_account_id success:(void (^)(NSDictionary *responseObject))success fail:(void (^)(NSError *error))fail;

/// 获取房间内各互动工具的当前状态
/// @param roomId 房间id
/// @param success 成功
/// @param fail 失败
+ (void)getInvaToolStatusWithRoomId:(NSString *)roomId
                            success:(void (^)(VHSSRoomToolsStatus *roomToolsStatus))success
                               fail:(void (^)(NSError *error))fail;

/// 直播设置_查询房间历史问卷
/// @param webinarId 活动id
/// @param roomId 房间id
/// @param switchId 场次id
/// @param success 成功
/// @param fail 失败
+ (void)fetchSurveyHistoryWithWebinarId:(NSString *)webinarId
                                 roomId:(NSString *_Nullable)roomId
                               switchId:(NSString *_Nullable)switchId
                                success:(void (^)(NSDictionary *responseObject, NSString *passSurveyString))success fail:(void (^)(NSError *error))fail;

#pragma mark 聊天

/// 获取在线成员列表
/// @param roomId 房间id
/// @param pos 查询条目节点，默认为0
/// @param limit 本次查询条目数量
/// @param nickname 用户昵称
/// @param success 成功
/// @param fail 失败
+ (void)getOnlineUserListWithRoomId:(NSString *)roomId pos:(NSInteger)pos limit:(NSInteger)limit nickname:(NSString *_Nullable)nickname success:(void (^)(NSDictionary *responseObject, BOOL haveNextPage))success fail:(void (^)(NSError *error))fail;

/// 获取受限列表，包括：被踢出、被禁言的用户
/// @param roomId 房间id
/// @param pos 查询条目节点，默认为0
/// @param limit 本次查询条目数量
/// @param success 成功
/// @param fail 失败
+ (void)getBoundedListWithRoomId:(NSString *)roomId pos:(NSInteger)pos limit:(NSInteger)limit success:(void (^)(NSDictionary *responseObject, BOOL haveNextPage))success fail:(void (^)(NSError *error))fail;

/// 设置/取消用户禁言
/// @param roomId 房间id
/// @param receive_account_id 参会用户的uid
/// @param status 1禁言 0取消禁言
/// @param success 成功
/// @param fail 失败
+ (void)setChatUserBannedWithRoomId:(NSString *)roomId receive_account_id:(NSString *)receive_account_id status:(NSInteger)status success:(void (^)(NSDictionary *responseObject))success fail:(void (^)(NSError *error))fail;

/// 设置/取消用户踢出
/// @param roomId 房间id
/// @param receive_account_id 参会用户的uid
/// @param status 1禁言 0取消禁言
/// @param success 成功
/// @param fail 失败
+ (void)setChatUserKickedWithRoomId:(NSString *)roomId receive_account_id:(NSString *)receive_account_id status:(NSInteger)status success:(void (^)(NSDictionary *responseObject))success fail:(void (^)(NSError *error))fail;

/// 获取当前房间聊天列表
/// @param roomId 房间id
/// @param msg_id 聊天记录 锚点消息id,此参数存在时anchor_path 参数必须存在
/// @param pos 获取条目节点，默认为0
/// @param limit 获取条目数量，最大100
/// @param start_time 开始时间
/// @param is_role 0：不筛选主办方 1：筛选主办方 默认是0
/// @param anchor_path 锚点方向，up 向上查找，down 向下查找,此参数存在时 msg_id 参数必须存在,默认down
/// @param success 成功
/// @param fail 失败
+ (void)getChatListWithRoomId:(NSString *)roomId msg_id:(NSString *)msg_id pos:(NSInteger)pos limit:(NSInteger)limit start_time:(NSString *)start_time is_role:(NSInteger)is_role anchor_path:(NSString *)anchor_path success:(void (^)(NSArray <NSDictionary *> *array, BOOL haveNextPage))success fail:(void (^)(NSError *error))fail;

+ (void)newGetChatListWithRoomId:(NSString *)roomId start_time:(NSString *)startTime pos:(NSInteger)pos limit:(NSInteger)limit success:(void (^)(NSArray <NSDictionary *> *array, BOOL haveNextPage))success fail:(void (^)(NSError * error)) fail __deprecated_msg("!! 6.5.0 开始，不再使用该方法; 请使用 +[VHSSInteract getChatListWithRoomId:msg_id:pos:limit:start_time:is_role:anchor_path:success:fail:]");

/// 发送自定义消息
/// @param room_id 房间id
/// @param body  消息内容
/// @param success 成功
/// @param fail 失败
+ (void)sendCustomMsgWithRoomId:(NSString *)room_id body:(NSString *)body success:(void (^)(NSDictionary *responseObject))success fail:(void (^)(NSError *error))fail;

/// 获取公告列表
/// @param room_id 房间id
/// @param pos 获取条目节点，默认为0
/// @param limit 获取条目数量，最大100
/// @param startTime 开始时间
/// @param success 成功
/// @param fail 失败
+ (void)getAnnouncementListWithRoomId:(NSString *)room_id pos:(NSInteger)pos limit:(NSInteger)limit startTime:(NSString *)startTime success:(void (^)(NSArray <VHSSInteractAnnouncementModel *> *dataArr, BOOL haveNextPage))success fail:(void (^)(NSError *error))fail;

#pragma mark - 反馈

/// 用户反馈
/// @param webinarId 活动id
/// @param type 反馈类型1:卡顿 2:黑屏 3:声音不同步 4:APP反馈
/// @param content 反馈内容
/// @param source 反馈来源 1:网页 2:APP
/// @param success 成功
/// @param fail 失败
+ (void)createFeedbackWithWebinarId:(NSString *_Nullable)webinarId type:(NSInteger)type content:(NSString *)content source:(NSInteger)source success:(void (^)(NSDictionary *responseObject))success fail:(void (^)(NSError *error))fail;

#pragma mark - 文档

/// 获取活动下的文档列表
/// @param webinarId 活动id
/// @param type 来源类型：1：控制台下，2：直播间中
/// @param roomId 活动id (当type=2必传)
/// @param pos 查询条目节点，默认为0
/// @param limit 本次查询条目数量
/// @param keyword 关键字
/// @param success 成功回调
/// @param fail 失败回调
+ (void)getWebinarDocumentListWithWebinarId:(NSString *)webinarId type:(NSInteger)type roomId:(NSString *)roomId pos:(NSInteger)pos limit:(NSInteger)limit keyword:(NSString *_Nullable)keyword success:(void (^)(NSArray <VHSSInteractDocModel *> *dataArr, BOOL haveNextPage))success fail:(void (^)(NSError *error))fail;

#pragma mark - 关键词过滤

/// 获取关键词列表
/// @param roomId 房间
/// @param success 成功
/// @param fail 失败
+ (void)getCurrentUserAllKeywordWithRoomId:(NSString *)roomId success:(void (^)(NSArray <NSString *> *keywords))success fail:(void (^)(NSError *error))fail;

#pragma mark - 抽奖
/// 提交中奖信息
/// @param roomId 房间id
/// @param name 中奖人姓名
/// @param phone 中奖人手机号
/// @param remark 备注：除了姓名、手机号以外，其他输入项配置数组，并转换为json字符串
// [{
//  "field": "地址",
//  "field_key": "address",
//  "field_value": "紫檀大厦",
//  "rank":1
// },...]

/// @param lotteryId 抽奖活动id
/// @param success 成功
/// @param fail 失败
+ (void)submitWinInfoWithRoomId:(NSString *)roomId name:(NSString *)name phone:(NSString *)phone remark:(NSString *)remark lotteryId:(NSString *)lotteryId success:(void (^)(void))success fail:(void (^)(NSError *error))fail;


/// 获取领奖信息提交输入项配置
/// @param webinarId 活动id
/// @param lotteryId 抽奖id
/// @param success 成功
/// @param fail 失败
+ (void)getLotteryReceiveAwardSettingWithWebinarId:(NSString *)webinarId lotteryId:(NSString *)lotteryId success:(void (^)(NSDictionary *responseObject))success fail:(void (^)(NSError *error))fail;


/// 口令抽奖-立即参与
/// @param roomId 房间id
/// @param lottery_id 抽奖id
/// @param success 成功
/// @param fail 失败
+ (void)lotteryParticipationWithRoomId:(NSString *)roomId lottery_id:(NSString *)lottery_id success:(void (^)(NSDictionary *responseObject))success fail:(void (^)(NSError *error))fail;


/// 获取中奖用户列表
/// @param lottery_id 抽奖id
/// @param success 成功
/// @param fail 失败
+ (void)getLotteryWinListWithLotteryId:(NSString *)lottery_id success:(void (^)(NSDictionary *responseObject))success fail:(void (^)(NSError *error))fail;

/// 查询自己是否中奖
/// @param success 成功回调
/// @param fail 失败回调
+ (void)lotteryCheckSuccess:(void (^)(NSDictionary *responseObject))success fail:(void (^)(NSError *error))fail;

/// 观看端-检查抽奖列表接口
/// @param showAll 是否需要展示所有抽奖 0-否(默认：仅展示进行中、已中奖抽奖) 1-全部抽奖 2 已中奖抽奖（sdk专用）
/// @param webinarId 活动id
/// @param success 成功
/// @param fail 失败
+ (void)lotteryListIsShowAll:(NSInteger)showAll
                   webinarId:(NSString *)webinarId
                     success:(void (^)(NSDictionary *responseObject))success
                        fail:(void (^)(NSError *error))fail;

/// 观看端-抽奖-获取中奖人信息
/// @param room_id 房间id
/// @param success 成功
/// @param fail 失败
+ (void)lotteryWinningUserInfo:(NSString *)room_id
                       success:(void (^)(NSDictionary *responseObject))success
                          fail:(void (^)(NSError *error))fail;

/// 观看端-抽奖-查看中奖详情
/// @param room_id 房间id
/// @param lottery_id 抽奖id
/// @param success 成功
/// @param fail 失败
+ (void)lotteryWinningUserDetail:(NSString *)room_id
                      lottery_id:(NSString *)lottery_id
                         success:(void (^)(NSDictionary *responseObject))success
                            fail:(void (^)(NSError *error))fail;

#pragma mark - 播放器设置

/// 观看端获取水印
/// @param webinar_id 活动id
/// @param success 成功
/// @param fail 失败
+ (void)getWatermarkInfoWithWebinarId:(NSString *)webinar_id success:(void (^)(VHSSInteractWatermarkModel *model))success fail:(void (^)(NSError *error))fail;

/// 观看端获取跑马灯
/// @param webinar_id 活动id
/// @param success 成功
/// @param fail 失败
+ (void)getScrollScreenWithWebinarId:(NSString *)webinar_id success:(void (^)(VHSSInteractScrollScreenModel *model))success fail:(void (^)(NSError *error))fail;

#pragma mark - 直播问答
/// 提交一个提问
/// @param roomId 房间id
/// @param content 提问内容
/// @param success 成功
/// @param fail 失败
+ (void)submitOneQuestionWithRoomId:(NSString *)roomId content:(NSString *)content success:(void (^)(void))success fail:(void (^)(NSError *error))fail;


/// 获取当前活动的历史问答记录
/// @param roomId 房间id
/// @param success 成功
/// @param fail 失败
+ (void)getWebinarHistoryQuestionsWithRoomId:(NSString *)roomId success:(void (^)(NSDictionary *responseObject))success fail:(void (^)(NSError *error))fail;

#pragma mark - 签到

/// 用户进行签到
/// @param roomId 房间id
/// @param signId 签到id
/// @param success 成功
/// @param fail 失败
+ (void)userSignWithRoomId:(NSString *)roomId signId:(NSString *)signId success:(void (^)(void))success fail:(void (^)(NSError *error))fail;

#pragma mark - 计时器

/// 查询计时器进度
/// @param success 成功
/// @param fail 失败
+ (void)requestInteractsTimerInfoSuccess:(void (^)(NSDictionary *responseObject))success
                                    fail:(void (^)(NSError *error))fail;

#pragma mark - 点赞

/// 创建房间的用户点赞
/// @param roomId 房间id
/// @param num 点赞次数，最多500，超过500会强制成为500
/// @param success 成功
/// @param fail 失败
+ (void)requestCreateUserLikeWithRoomId:(NSString *)roomId
                                    num:(NSInteger)num
                                success:(void (^)(NSDictionary *responseObject))success
                                   fail:(void (^)(NSError *error))fail;

/// 获取房间的点赞数量
/// @param roomId 房间id
/// @param success 成功
/// @param fail 失败
+ (void)requestGetRoomLikeWithRoomId:(NSString *)roomId
                             success:(void (^)(NSDictionary *responseObject))success
                                fail:(void (^)(NSError *error))fail;

/// 获取点赞总数量
/// @param success 成功
/// @param fail 失败
+ (void)requestGetAllLikeWithSuccess:(void (^)(NSDictionary *responseObject))success
                                fail:(void (^)(NSError *error))fail;


#pragma mark - 礼物

/// 观看端获取活动使用的礼物列表
/// @param roomId 房间id
/// @param success 成功
/// @param fail 失败
+ (void)requestWebinarUsingGiftListWithRoomId:(NSString *)roomId
                                      success:(void (^)(NSDictionary *responseObject))success
                                         fail:(void (^)(NSError *error))fail;

/// 观看端发送礼物给主持人
/// @param roomId 房间id
/// @param gift_id 礼物ID
/// @param channel
/// @param service_code 
/// @param success 成功
/// @param fail 失败
+ (void)requestSendGiftWithRoomId:(NSString *)roomId
                          gift_id:(NSString *)gift_id
                          channel:(NSString *)channel
                     service_code:(NSString *)service_code
                          success:(void (^)(NSDictionary *responseObject))success
                             fail:(void (^)(NSError *error))fail;

/// 观看端-获取推送的推屏卡片列表
/// @param webinar_id 活动ID
/// @param switch_id 活动场次ID
/// @param curr_page 当前页码，默认 1
/// @param page_size 每页条数，默认 10
/// @param success 成功
/// @param fail 失败
+ (void)requestPushScreenCardListWithWebinarId:(NSString *)webinar_id
                                     switch_id:(NSString *)switch_id
                                     curr_page:(NSInteger)curr_page
                                     page_size:(NSInteger)page_size
                                       success:(void (^)(NSDictionary *responseObject))success
                                          fail:(void (^)(NSError *error))fail;

/// 观看端-获取推屏卡片信息
/// @param webinar_id 活动ID
/// @param card_id 卡片id
/// @param success 成功
/// @param fail 失败
+ (void)requestPushScreenCardInfoWithWebinarId:(NSString *)webinar_id
                                       card_id:(NSString *)card_id
                                       success:(void (^)(NSDictionary *responseObject))success
                                          fail:(void (^)(NSError *error))fail;

/// 观看端-点击推屏卡片
/// @param webinar_id 活动ID
/// @param switch_id 活动场次ID
/// @param card_id 卡片id
/// @param success 成功
/// @param fail 失败
+ (void)requestPushScreenCardClickWithWebinarId:(NSString *)webinar_id
                                      switch_id:(NSString *)switch_id
                                        card_id:(NSString *)card_id
                                        success:(void (^)(NSDictionary *responseObject))success
                                           fail:(void (^)(NSError *error))fail;

@end

NS_ASSUME_NONNULL_END
