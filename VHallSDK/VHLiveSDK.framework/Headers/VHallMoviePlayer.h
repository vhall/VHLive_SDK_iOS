//
//  VHallMoviePlayer.h
//  VHLivePlay
//
//  Created by liwenlong on 16/2/16.
//  Copyright © 2016年 vhall. All rights reserved.
//
#import <MediaPlayer/MPMoviePlayerController.h>
#import "VHallConst.h"

@protocol VHallMoviePlayerDelegate;
@interface VHallMoviePlayer : NSObject

@property(nonatomic,weak)id <VHallMoviePlayerDelegate> delegate;
@property(nonatomic,strong,readonly)UIView * moviePlayerView;
@property(nonatomic,assign)int timeout;                         //链接的超时时间 默认6000毫秒，单位为毫秒  MP4点播 最小10000毫秒
//@property(nonatomic,assign)int reConnectTimes;                //RTMP 断开后的重连次数 默认 2次
@property(nonatomic,assign)int bufferTime;                      //RTMP 的缓冲时间 默认 6秒 单位为秒 必须>0 值越小延时越小,卡顿增加
@property(assign,readonly)int realityBufferTime;                //获取RTMP播放实际的缓冲时间，单位毫秒
@property(nonatomic,assign,readonly)VHPlayerState playerState;  //播放器状态
@property(nonatomic,strong,readonly)UIView * documentView;      //文档view，当前活动如果没有文档次View 为 nil 可以从回调中获取此活动是否有文档

/**
 *  当前视频观看模式
 */
@property(nonatomic,assign)VHMovieVideoPlayMode playMode;
/**
 *  视频View的缩放比例 默认是自适应模式
 */
@property(nonatomic,assign)VHRTMPMovieScalingMode movieScalingMode;

/**
 *  设置默认播放的清晰度 默认原画
 */
@property(nonatomic,assign)VHMovieDefinition defaultDefinition;

/**
 * 设置当前要观看的清晰度
 */
@property(nonatomic,assign)VHMovieDefinition curDefinition;

/**
 * 当前活动状态
 */
@property(nonatomic,assign,readonly)VHMovieActiveState activeState;

/**
 * 以下属性 点播/回放播放时使用 直播无效
 */
@property (nonatomic, readonly) NSTimeInterval          duration;           //视频时长
@property (nonatomic, readonly) NSTimeInterval          playableDuration;   //可播放时长
@property (nonatomic, assign)   NSTimeInterval          currentPlaybackTime;//当前播放时间点
@property (nonatomic, assign)   float                   rate;//点播倍速播放速率 0.50, 0.67, 0.80, 1.0, 1.25, 1.50, and 2.0
@property (nonatomic, assign)   NSTimeInterval          initialPlaybackTime;//初始化要播放的位置
/**
 *  初始化VHMoviePlayer对象
 *  @param delegate 代理
 *  @return   返回VHMoviePlayer的一个实例
 */
- (instancetype)initWithDelegate:(id <VHallMoviePlayerDelegate>)delegate;


/**
 *  预加载视频信息 进入页面即需要使用此方法后 startPlay和startPlayback传参不再有效，只是有开始播放功能，更换房间时需要停止上个房间播放
 *  此方法可以提供播放前操作聊天等功能 （在预加载完成回调后，可调用startPlay开播，或使用聊天等功能）
 *  @param param
 *  param[@"id"]    = 活动Id 必传
 *  param[@"name"]  = 如已登录可以不传
 *  param[@"email"] = 如已登录可以不传
 *  param[@"pass"]  = 活动如果有K值或密码需要传
*/
- (void)preLoadRoomWithParam:(NSDictionary*)param;

/**
 *  观看直播视频
 *  @param param
 *  param[@"id"]    = 活动Id 必传
 *  param[@"name"]  = 如已登录可以不传
 *  param[@"email"] = 如已登录可以不传
 *  param[@"pass"]  = 活动如果有K值或密码需要传
 */
-(BOOL)startPlay:(NSDictionary*)param;

/**
 *  观看回放/点播视频
 *  @param param
 *  param[@"id"]    = 活动Id 必传
 *  param[@"name"]  = 如已登录可以不传
 *  param[@"email"] = 如已登录可以不传
 *  param[@"pass"]  = 活动如果有K值或密码需要传
 */
-(BOOL)startPlayback:(NSDictionary*)param;

/**
 *  暂停播放 （如果是直播，等同于stopPlay）
 */
-(void)pausePlay;

/**
 *  播放出错/pausePlay后恢复播放
 *  @return NO 播放器不是暂停状态 或者已经结束
 */
-(BOOL)reconnectPlay;

/**
 *  停止播放
 */
-(void)stopPlay;

/**
 *  设置静音
 *  @param mute 是否静音
 */
- (void)setMute:(BOOL)mute;

/**
 *  销毁播放器
 */
- (void)destroyMoivePlayer;

#pragma mark - 连麦互动接口
/**
 *  发送 申请上麦/取消申请 消息
 *  @param type 1举手，0取消举手
 */
- (BOOL)microApplyWithType:(NSInteger)type;

/**
 *  发送 申请上麦/取消申请 消息
 *  @param type 1举手，0取消举手
 *  @param finishBlock 消息发送结果
 */
- (BOOL)microApplyWithType:(NSInteger)type finish:(void(^)(NSError *error))finishBlock;

/**
 *  收到邀请后 是否同意上麦
 *  @param type 1接受，2拒绝，3超时失败
 *  @param finishBlock 结果回调
 */
- (BOOL)replyInvitationWithType:(NSInteger)type finish:(void(^)(NSError *error))finishBlock;

#pragma mark - 辅助接口
/**
 *  清空视频剩余的最后一帧画面
 */
- (void)cleanLastFrame;

/**
 *  仅播放 VR 活动时有效
 *  是否启用陀螺仪控制画面模式
 */
- (void)setUsingGyro:(BOOL)usingGyro;

/**
 *  仅播放 VR 活动时，并且 开启陀螺仪模式时 必须设置
 *  设置视频显示的方向 用于陀螺仪方向校对
 */
- (void)setUILayoutOrientation:(UIDeviceOrientation)orientation;

/**
 *  更新DLNA 播放地址
 *  参数为 dlnaControl对象
 *  返回值 NO 为不可投屏状态
 */
- (BOOL)dlnaMappingObject:(id)DLNAobj;

/**
 *  重连socket
 */
-(BOOL)reconnectSocket;

///设置音频输出设备
+ (void)audioOutput:(BOOL)inSpeaker;

/**
 *  设置系统声音大小
 *  @param size float  [0.0~1.0]
 */
+ (void)setSysVolumeSize:(float)size;

/**
 *  获取系统声音大小
 */
+ (float)getSysVolumeSize;
@end


@protocol VHallMoviePlayerDelegate <NSObject>
@optional
/**
 *  视频预加载完成可以调用播放接口
 *  activeState 预加载完成时活动状态
 *  error 为空时频预加载完成
 */
- (void)preLoadVideoFinish:(VHallMoviePlayer*)moviePlayer activeState:(VHMovieActiveState)activeState error:(NSError*)error;

/**
 *  播放连接成功 
 */
- (void)connectSucceed:(VHallMoviePlayer*)moviePlayer info:(NSDictionary*)info;

/**
 *  缓冲开始回调
 */
- (void)bufferStart:(VHallMoviePlayer*)moviePlayer info:(NSDictionary*)info;

/**
 *  缓冲结束回调
 */
-(void)bufferStop:(VHallMoviePlayer*)moviePlayer info:(NSDictionary*)info;

/**
 *  下载速率的回调
 *
 *  @param moviePlayer 播放器实例
 *  @param info        下载速率信息 单位kbps
 */
- (void)downloadSpeed:(VHallMoviePlayer*)moviePlayer info:(NSDictionary*)info;

/**
 *  Streamtype
 *
 *  @param moviePlayer moviePlayer
 *  @param info        info
 */
- (void)recStreamtype:(VHallMoviePlayer*)moviePlayer info:(NSDictionary*)info;

/**
 *  播放时错误的回调
 *
 *  @param livePlayErrorType 直播错误类型
 */
- (void)playError:(VHSaasLivePlayErrorType)livePlayErrorType info:(NSDictionary*)info;

/**
 *  视频活动状态回调
 *
 *  @param activeState  视频活动状态
 */
- (void)ActiveState:(VHMovieActiveState)activeState;

/**
 *  获取当前视频播放模式
 *
 *  @param playMode  视频播放模式
 VHMovieVideoPlayModeNone            = 0,    //不存在
 VHMovieVideoPlayModeMedia           = 1,    //单视频
 VHMovieVideoPlayModeTextAndVoice    = 2,    //文档＋声音
 VHMovieVideoPlayModeTextAndMedia    = 3,    //文档＋视频
 VHMovieVideoPlayModeVoice           = 4,    //单音频
 */
- (void)VideoPlayMode:(VHMovieVideoPlayMode)playMode isVrVideo:(BOOL)isVrVideo;

/**
 *  获取当前视频支持的所有播放模式
 *
 *  @param playModeList 视频播放模式列表
 */
- (void)VideoPlayModeList:(NSArray*)playModeList;

/**
 *  该直播支持的清晰度列表
 *
 *  @param definitionList  支持的清晰度列表
 */
- (void)VideoDefinitionList:(NSArray*)definitionList;

/**
 *  主播开始推流消息
 *
 *  注意：H5和互动 活动 收到此消息后建议延迟 5s 开始播放
 */
- (void)LiveStart;
/**
 *  直播结束消息
 *
 *  直播结束消息
 */
- (void)LiveStoped;

/**
 *  播主发布公告
 *
 *  播主发布公告消息
 */
- (void)Announcement:(NSString*)content publishTime:(NSString*)time;

/**
 *  是否允许举手申请上麦 回调。
 *  @param player         VHallMoviePlayer实例
 *  @param isInteractive  当前活动是否支持互动功能
 *  @param state          主持人是否允许举手
 */
- (void)moviePlayer:(VHallMoviePlayer *)player isInteractiveActivity:(BOOL)isInteractive interactivePermission:(VHInteractiveState)state;

/**
 *  主持人是否同意上麦申请回调
 *  @param player       VHallMoviePlayer实例
 *  @param attributes   参数 收到的数据
 *  @param error        错误回调 nil 同意上麦 不为空为不同意上麦
 */
- (void)moviePlayer:(VHallMoviePlayer *)player microInvitationWithAttributes:(NSDictionary *)attributes error:(NSError *)error;

/**
 *  主持人邀请你上麦
 *  @param player       VHallMoviePlayer实例
 *  @param attributes   参数 收到的数据
 */
- (void)moviePlayer:(VHallMoviePlayer *)player microInvitation:(NSDictionary *)attributes;

/**
 *  被踢出
 *
 *  @param player player
 *  @param isKickout 被踢出 取消踢出后需要重新进入
 */
- (void)moviePlayer:(VHallMoviePlayer *)player isKickout:(BOOL)isKickout;

/**
 *  主持人显示/隐藏文档
 *
 *  @param isHave  YES 此活动有文档演示
 *  @param isShow  YES 主持人显示观看端文档，NO 主持人隐藏观看端文档
 */
- (void)moviePlayer:(VHallMoviePlayer *)player isHaveDocument:(BOOL)isHave isShowDocument:(BOOL)isShow;

/**
*  直播文档同步，直播文档有延迟，指定需要延迟的秒数，默认为直播缓冲时间
*/
- (NSTimeInterval)documentDelayTime:(VHallMoviePlayer *)player;

#pragma mark - 点播
/**
 *  statusDidChange
 *
 *  @param player player
 *  @param state  VHPlayerState
 */
- (void)moviePlayer:(VHallMoviePlayer *)player statusDidChange:(VHPlayerState)state;

/**
 *  currentTime
 *
 *  @param player player
 *  @param currentTime 回放当前播放时间点 1s 回调一次可用于UI刷新
 */
- (void)moviePlayer:(VHallMoviePlayer*)player currentTime:(NSTimeInterval)currentTime;

/**
 *  是否包含投屏功能
 *  * cast_screen 1有投屏功能 0没有投屏功能
 */
- (void)moviePlayer:(VHallMoviePlayer *)player isCast_screen:(BOOL)isCast_screen;

/**
 *  是否开启问答功能
 *  * cast_screen 1有问答功能 0没有问答功能
 */
- (void)moviePlayer:(VHallMoviePlayer *)player isQuestion_status:(BOOL)isQuestion_status;

@end
