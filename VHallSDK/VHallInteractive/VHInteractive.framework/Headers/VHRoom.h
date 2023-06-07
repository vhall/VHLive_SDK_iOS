//
//  VHRoom.h
//  VHInteractive
//
//  Created by vhall on 2018/4/18.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VHInteractive/VHLocalRenderView.h>
#import <VHInteractive/VHRoomBroadCastConfig.h>
#import <VHInteractive/VHRoomEnum.h>
#import <VHInteractive/VHRoomInfo.h>
#import <VHLiveSDK/VHDocument.h>
#import <VHLiveSDK/VHWebinarInfo.h>

#import <VHInteractive/VHRoomDocumentModel.h>
#import <VHInteractive/VHRoomMember.h>
#import <VHInteractive/VHRoomToolStatus.h>

NS_ASSUME_NONNULL_BEGIN

@protocol   VHRoomDelegate;
@class VHRenderView;

@interface VHRoom : NSObject

@property (nonatomic, weak)             id <VHRoomDelegate>         delegate;           ///<代理
@property (nonatomic, assign)           int reconnectTimes;                             ///<房间重连时长 (默认 15秒)
@property (nonatomic, assign)           BOOL isRehearsal;                               ///<是否彩排 YES：彩排模式开播 NO：正常直播 (默认NO,开播前设置有效)
@property (nonatomic, assign)           BOOL isPublishAnother;                          ///<是否开启自动旁路 YES：开启 NO：不开启 (默认NO,开播前设置有效)
@property (nonatomic, assign)           BOOL isMainScreen;                              ///<是否开启自动主屏配置 YES：开启 NO：不开启 (默认NO,开播前设置有效)
@property (nonatomic, strong)           VHRoomBroadCastConfig *broadCastConfig;         ///<旁路布局配置
@property (nonatomic, weak, readonly)   VHRenderView *cameraView;                       ///<当前推流cameraView，只在推流过程中存在
@property (nonatomic, copy, readonly)   NSString *roomId;                               ///<房间id
@property (nonatomic, assign, readonly) BOOL isPublishing;                              ///<当前是否在推流中
@property (nonatomic, assign, readonly) VHRoomStatus status;                            ///<当前房间状态
@property (nonatomic, strong, readonly) VHRoomInfo *roomInfo;                           ///<房间相关信息（进入房间成功后才有值）
@property (nonatomic, strong, readonly) NSDictionary *renderViewsById;                  ///<除自己以外房间内其他流id与视频view信息  (key:streamId value:视频VHRenderView)
@property (nonatomic, strong, readonly) NSArray *streams;                               ///<除自己以外房间内其他流id列表

/// 观众进入互动房间
/// @param roomId 房间id，同活动id
/// @discussion  注意：如果为常规(非无延迟)互动直播，观众需要上麦（申请上麦被同意或被邀请上麦）后再进入互动房间，否则没有上麦直接进入非无延迟互动直播间，会占用房间用户名额，可能会导致其他嘉宾进房间失败>
- (void)enterRoomWithRoomId:(NSString *)roomId;

/// 观众进入互动房间
/// <注意：如果为常规(非无延迟)互动直播，观众需要上麦（申请上麦被同意或被邀请上麦）后再进入互动房间，否则没有上麦直接进入非无延迟互动直播间，会占用房间用户名额，可能会导致其他嘉宾进房间失败>
/// @param params 参数
/// params[@"id"]    = 房间id，同活动id
/// params[@"pass"]  = 活动如果有K值或密码，则必传
/// params[@"k_id"]  = 观看初始化接口活动维度下k值的唯一ID
- (void)enterRoomWithParams:(NSDictionary *)params;

/// 开始推流 (加入房间成功以后方可调用)
/// @param cameraView 需要推流的本地摄像头view
- (BOOL)publishWithCameraView:(VHLocalRenderView *)cameraView;

/// 下麦并停止推流
- (void)unpublish;

/// 离开房间
- (void)leaveRoom;

/// 开启/关闭旁路直播 (使用该方法前提:加入房间初始化方法使用enterRoomWithRoomId:broadCastId:accessToken:userData:)
/// @param isOpen Yes开启旁路直播   NO关闭旁路直播
/// @param param [self baseConfigRoomBroadCast:4 layout:4]; 调用此函数配置视频质量参数和旁路布局
/// @discussion 设置成功后会自动推旁路
- (BOOL)publishAnotherLive:(BOOL)isOpen param:(NSDictionary *)param completeBlock:(void (^)(NSError *error))block;

/// 基础配置旁路混流参数
/// @param definition 视频质量参数，推荐使用。即（分辨率+帧率+码率）
/// @param layout 旁路布局模板（非自定义布局）
- (NSDictionary *)baseConfigRoomBroadCast:(VHBroadcastProfileMode)definition layout:(VHBroadcastLayout)layout;

/// 设置旁路背景图
/// @param url 背景图URL,如果为空，则为取消背景图
/// @param cropType 填充类型:VHRoomBGCropType
/// @param handle 设置后的回调,成功:200
- (void)settingRoomBroadCastBackgroundImageURL:(NSURL *_Nullable)url cropType:(VHRoomBGCropType)cropType finish:(void (^)(int code, NSString *_Nonnull message))handle;

/// 设置音视频是否加入混流
/// @param isJoin 是否加入
/// @param cameraView 加入混流的renderView
/// @param handle 结果回调
- (void)setRoomJoinBroadCastMixOption:(BOOL)isJoin
                           cameraView:(VHLocalRenderView *)cameraView
                               finish:(void (^)(int code, NSString *_Nonnull message))handle;

#pragma mark ------------------v6.1新增--------------------
/// 嘉宾进入互动房间 (嘉宾使用)
/// @param params 参数
/// params[@"id"]    = 房间id，同活动id（必传）
/// params[@"nickname"]  = 昵称（必传）
/// params[@"password"]  = 口令（必传）
/// params[@"avatar"]  = 头像url（可选）
- (void)guestEnterRoomWithParams:(NSDictionary *)params
                         success:(void (^)(VHRoomInfo *info))success
                            fail:(void (^)(NSError *error))fail;

/// 主持人进入互动房间发起直播，收到"房间连接成功回调"后可开始推流（主持人使用）
/// @param params 参数
/// params[@"id"]    = 房间id，同活动id
/// params[@"nickname"]    = 昵称 (可选)
/// params[@"email"]    = 邮箱（可选）
- (void)hostEnterRoomStartWithParams:(NSDictionary *)params
                             success:(void (^)(VHRoomInfo *info))success
                                fail:(void (^)(NSError *error))fail;

/// 设置是否开启观众举手申请上麦功能（主持人使用，若开启，则观众可举手申请上麦。）
/// @param status 1：开启 0：关闭
/// @param success 成功
/// @param fail 失败
- (void)setHandsUpStatus:(NSInteger)status
                 success:(void (^)(NSDictionary *response))success
                    fail:(void (^)(NSError *error))fail;

/// 邀请某个用户上麦 (主持人使用)
/// @param userId 目标用户id
/// @param success 成功
/// @param fail 失败
- (void)inviteWithTargetUserId:(NSString *)userId
                       success:(void (^)(void))success
                          fail:(void (^)(NSError *error))fail;

/// 同意某个用户的上麦申请 (主持人使用)
/// @param userId 目标用户id
/// @param success 成功
/// @param fail 失败
- (void)agreeApplyWithTargetUserId:(NSString *)userId
                           success:(void (^)(void))success
                              fail:(void (^)(NSError *error))fail;

/// 拒绝某个用户的上麦申请 (主持人使用)
/// @param userId 目标用户id
/// @param success 成功
/// @param fail 失败
- (void)rejectApplyWithTargetUserId:(NSString *)userId
                            success:(void (^)(void))success
                               fail:(void (^)(NSError *error))fail;

/// 设置某个用户为主讲人 (主持人使用)
/// @param userId 目标用户id
/// @param success 成功
/// @param fail 失败
- (void)setMainSpeakerWithTargetUserId:(NSString *)userId
                               success:(void (^)(void))success
                                  fail:(void (^)(NSError *error))fail;

/// 下麦某个用户 (主持人使用)
/// @param userId 目标用户id
/// @param success 成功
/// @param fail 失败
- (void)downMicWithTargetUserId:(NSString *)userId
                        success:(void (^)(void))success
                           fail:(void (^)(NSError *error))fail;

/// 禁言/取消禁言某个用户
/// @param status YES：禁言 NO：取消禁言
/// @param userId 目标用户id
/// @param success 成功
/// @param fail 失败
- (void)setBanned:(BOOL)status
     targetUserId:(NSString *)userId
          success:(void (^)(void))success
             fail:(void (^)(NSError *error))fail;

/// 踢出/取消踢出某个用户
/// @param status YES：踢出 NO：取消踢出
/// @param userId 目标用户id
/// @param success 成功
/// @param fail 失败
- (void)setKickOut:(BOOL)status
      targetUserId:(NSString *)userId
           success:(void (^)(void))success
              fail:(void (^)(NSError *error))fail;

/// 申请上麦
/// @param success 成功
/// @param fail 失败
- (void)applySuccess:(void (^)(void))success
                fail:(void (^)(NSError *error))fail;

/// 取消申请上麦
/// @param success 成功
/// @param fail 失败
- (void)cancelApplySuccess:(void (^)(void))success
                      fail:(void (^)(NSError *error))fail;

/// 拒绝主持人发来的上麦邀请
/// @param success 成功回调
/// @param fail 失败回调
- (void)rejectInviteSuccess:(void (^)(void))success
                       fail:(void (^)(NSError *error))fail;

/// 同意主持人发来的上麦邀请，成功回调中开启推流
/// @param success 成功回调
/// @param fail 失败回调
- (void)agreeInviteSuccess:(void (^)(void))success
                      fail:(void (^)(NSError *error))fail;

/// 是否开启文档融屏旁路
/// @param enable 开启/关闭
/// @param handle 设置后的回调
- (void)settingRoomBroadCastDocMixEnable:(BOOL)enable
                                  finish:(void (^)(int code, NSString *_Nonnull message))handle;

/// 获取在线成员列表
/// @param pageNum 页码，第一页从1开始
/// @param pageSize 每页条数
/// @param nickName 指定昵称（非必传参数，可传nil）
/// @param success 成功 haveNextPage：是否还有下一页
/// @param fail 失败
- (void)getOnlineUserListWithPageNum:(NSInteger)pageNum
                            pageSize:(NSInteger)pageSize
                            nickName:(NSString *)nickName
                             success:(void (^)(NSArray <VHRoomMember *> *list, BOOL haveNextPage))success
                                fail:(void (^)(NSError *error))fail;

/// 获取受限成员列表 (包括：被踢出、被禁言的用户)
/// @param pageNum 页码，第一页从1开始
/// @param pageSize 每页条数
/// @param success 成功 haveNextPage：是否还有下一页
/// @param fail 失败
- (void)getLimitUserListWithPageNum:(NSInteger)pageNum
                           pageSize:(NSInteger)pageSize
                            success:(void (^)(NSArray <VHRoomMember *> *list, BOOL haveNextPage))success
                               fail:(void (^)(NSError *error))fail;

/// 获取房间文档列表
/// @param pageNum 页码，第一页从1开始
/// @param pageSize 每页条数
/// @param success 成功
/// @param fail 失败
- (void)getDocListWithPageNum:(NSInteger)pageNum
                     pageSize:(NSInteger)pageSize
                      success:(void (^)(NSArray <VHRoomDocumentModel *> *list, BOOL haveNextPage))success
                         fail:(void (^)(NSError *error))fail;

/// 获取互动房间状态(包含上麦用户列表)
/// @param roomId 房间id lss_xxx
/// @param success 成功
/// @param fail 失败
- (void)getInvaToolStatusWithRoomId:(NSString *)roomId
                            success:(void (^)(VHSSRoomToolsStatus *roomToolsStatus))success
                               fail:(void (^)(NSError *error))fail;

/// 获取互动SDK版本号
+ (NSString *)sdkVersionEX;

/// 获取支持的推流视频分辨率列表，如：[480x360,640x480,960x540...]
+ (NSArray<NSString *> *)availableVideoResolutions;

@end


/// 代理协议
@protocol VHRoomDelegate <NSObject>

/// 进入房间回调
/// @param room room实例
/// @param error 错误信息，如果error存在，则进入房间失败
- (void)room:(VHRoom *)room enterRoomWithError:(NSError *)error;

/// 房间连接成功回调
/// @param room room实例
/// @param roomMetadata 互动直播间数据 (可能为nil，暂时无用)
- (void)room:(VHRoom *)room didConnect:(NSDictionary *)roomMetadata;

/// 房间发生错误回调
/// @param room room实例
/// @param status 错误状态码
/// @param reason 错误描述
- (void)room:(VHRoom *)room didError:(VHRoomErrorStatus)status reason:(NSString *)reason;

/// 房间状态改变回调
/// @param room room实例
/// @param status 房间状态
- (void)room:(VHRoom *)room didChangeStatus:(VHRoomStatus)status;

/// 推流成功回调
/// @param room room实例
/// @param cameraView 当前推流 cameraView
- (void)room:(VHRoom *)room didPublish:(VHRenderView *)cameraView;

/// 停止推流回调
/// @param room room实例
/// @param cameraView 当前推流 cameraView
- (void)room:(VHRoom *)room didUnpublish:(VHRenderView *)cameraView;

/// 视频流加入回调（流类型包括音视频、共享屏幕、插播等）
/// @param room room实例
/// @param attendView 该成员对应视频画面
- (void)room:(VHRoom *)room didAddAttendView:(VHRenderView *)attendView;

/// 视频流离开回调（流类型包括音视频、共享屏幕、插播等）
/// @param room room实例
/// @param attendView 该成员对应视频画面
- (void)room:(VHRoom *)room didRemovedAttendView:(VHRenderView *)attendView;

/// 文档融屏流上线(订阅)
/// @param room room实例
/// @param attendView 该成员对应视频画面
- (void)room:(VHRoom *)room didAddDocmentAttendView:(VHRenderView *)attendView;

/// 文档融屏流下线(订阅)
/// @param room room实例
/// @param attendView 该成员对应视频画面
- (void)room:(VHRoom *)room didRemovedDocmentAttendView:(VHRenderView *)attendView;

/// 流准备好了
/// @param room room实例
/// @param msg 详情
- (void)room:(VHRoom *)room onStreamMixed:(NSDictionary *)msg;

/// 流音视频开启情况
/// @param room room实例
/// @param streamId 流id
/// @param muteStream 音视频详情
- (void)room:(VHRoom *)room didUpdateOfStream:(NSString *)streamId muteStream:(NSDictionary *)muteStream;

/// 互动房间互动消息回调
/// @param room room实例
/// @param eventName 互动消息name，可为空
/// @param attributes 互动消息体
- (void)room:(VHRoom *)room interactiveMsgWithEventName:(NSString *)eventName attribute:(id) attributes __deprecated_msg("Use room:receiveRoomMessage: instead");

/// 自己下麦回调（主动下麦/被下麦都会触发此回调） v4.0.0+
/// @param room room实例
- (void)leaveInteractiveRoomByHost:(VHRoom *)room;

/// 自己的麦克风开关状态改变回调（主动操作/被操作都会触发此回调，收到此回调后不需要再主动设置麦克风状态） v4.0.0+
/// @param room room实例
/// @param isClose YES:关闭 NO:开启
- (void)room:(VHRoom *)room microphoneClosed:(BOOL)isClose;

/// 自己的摄像头开关状态改变回调（主动操作/被操作都会触发此回调，收到此回调后不需要再主动设置摄像头状态） v4.0.0+
/// @param room room实例
/// @param isClose YES:关闭 NO:开启
- (void)room:(VHRoom *)room screenClosed:(BOOL)isClose;

/// 自己被踢出房间回调
/// @param room room实例
/// @param iskickout 是否被踢出
- (void)room:(VHRoom *)room iskickout:(BOOL)iskickout;

/// 自己被禁言/取消禁言回调
/// @param room room实例
/// @param forbidChat 是否被禁言
- (void)room:(VHRoom *)room forbidChat:(BOOL)forbidChat;

/// 收到全体禁言/取消全体禁言回调
/// @param room room实例
/// @param allForbidChat 是否已全体禁言
- (void)room:(VHRoom *)room allForbidChat:(BOOL)allForbidChat;

/// 直播结束回调
/// @param room room实例
/// @param liveOver 是否结束
- (void)room:(VHRoom *)room liveOver:(BOOL)liveOver;


/// 互动相关消息回调（推荐使用） v6.1及以上
/// @param room room实例
/// @param message 消息相关信息
- (void)room:(VHRoom *)room receiveRoomMessage:(VHRoomMessage *)message;


/// 房间人数改变回调 （目前仅支持真实人数改变触发此回调）
/// @param online_real 真实在线用户数
/// @param online_virtual 虚拟在线用户数
- (void)onlineChangeRealNum:(NSUInteger)online_real virtualNum:(NSUInteger)online_virtual;


/// 房间公告发布
/// @param room room实例
/// @param content 公告内容
/// @param pushTime 发布时间
/// @param duration 公告显示时长 0代表永久显示
- (void)room:(VHRoom *)room announcement:(NSString *)content pushTime:(NSString *)pushTime duration:(NSInteger)duration;

@end

NS_ASSUME_NONNULL_END
