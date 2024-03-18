//
//  VHallMoviePlayer.h
//  VHLivePlay
//
//  Created by liwenlong on 16/2/16.
//  Copyright © 2016年 vhall. All rights reserved.
//
#import <MediaPlayer/MPMoviePlayerController.h>
#import "VHallConst.h"
#import "VHPlayerCommonModel.h"
#import "VHWebinarInfo.h"
#import "VHMarqueeOptionModel.h"

@class VHDLNAControl;
@protocol VHallMoviePlayerDelegate;
@protocol VHallMoviePlayerDeprocatedDelegate;

@interface VHallMoviePlayer : NSObject

@property (nonatomic, weak) id <VHallMoviePlayerDelegate>       delegate;               ///<代理对象
@property (nonatomic, strong, readonly) UIView *moviePlayerView;                        ///<获取播放器view
@property (nonatomic, strong, readonly) UIView *documentView;                           ///<获取文档演示view，如果没有文档则为nil (在收到"文档显示/隐藏回调"后获取)
@property (nonatomic, strong, readonly) UIImageView *waterImg;                          ///<水印（在收到"播放连接成功回调"后使用）
@property (nonatomic, strong, readonly) VHWebinarInfo *webinarInfo;                     ///<活动相关信息 （在收到"视频信息预加载回调"或"播放连接成功回调"后使用，v6.0新增，仅限新版控制台(v3及以上)创建的活动使用）
@property (nonatomic, assign, readonly) int realityBufferTime;                          ///<获取RTMP播放实际的缓冲时间，单位毫秒
@property (nonatomic, assign, readonly) VHMovieVideoPlayMode playMode;                  ///<获取当前视频观看模式
@property (nonatomic, assign, readonly) VHMovieActiveState activeState;                 ///<活动状态 （在收到"视频信息预加载回调"或"播放连接成功回调"后使用）
@property (nonatomic, assign, readonly) VHPlayerState playerState;                      ///<获取播放器状态
@property (nonatomic, assign) VHRTMPMovieScalingMode movieScalingMode;                  ///<设置视频的填充模式 默认是自适应模式：VHRTMPMovieScalingModeAspectFit
@property (nonatomic, assign) VHMovieDefinition defaultDefinition;                      ///<设置默认播放的清晰度 默认原画
@property (nonatomic, assign) VHMovieDefinition curDefinition;                          ///<设置当前播放的清晰度
@property (nonatomic, assign) int timeout;                                              ///<设置链接的超时时间 默认5000毫秒，单位为毫秒  MP4点播 最小10000毫秒
@property (nonatomic, assign) int bufferTime;                                           ///<设置RTMP 的缓冲时间 默认 6秒 单位为秒 必须>0 值越小延时越小,卡顿增加
@property (nonatomic, strong) VHMarqueeOptionModel *marqueeOptionConfig;///<跑马灯

//---------------以下属性 直播使用--------------------
@property (nonatomic, assign) BOOL default_live_subtitle;                               ///<是否使用字幕视频 [播放开始前设置]
@property (nonatomic, assign) BOOL live_subtitle;                                       ///<是否使用字幕视频 [播放开始后设置]

//---------------以下属性 点播/回放播放时使用 直播无效--------------------
@property (nonatomic, assign, readonly) NSTimeInterval duration;                        ///<视频时长
@property (nonatomic, assign, readonly) NSTimeInterval playableDuration;                ///<可播放时长
@property (nonatomic, assign) float rate;                                               ///<点播倍速播放速率 0.50, 0.67, 0.80, 1.0, 1.25, 1.50, and 2.0
@property (nonatomic, assign) NSTimeInterval currentPlaybackTime;                       ///<当前播放时间点
@property (nonatomic, assign) NSTimeInterval initialPlaybackTime;                       ///<初始化要播放的位置

/// 初始化VHMoviePlayer对象
/// @param delegate 代理对象
- (instancetype)initWithDelegate:(id <VHallMoviePlayerDelegate>)delegate;

/// 预加载视频信息，在收到"视频信息预加载完成回调"后，即可使用聊天、签到、问答、抽奖等功能，然后择机调用startPlay/startPlayback进行播放，注意使用此方法后，startPlay和startPlayback传参将不再生效（此方法主要用于播放之前需要使用聊天等功能）
/// @param param 传参信息
/// param[@"id"]            = 活动Id，必传
/// param[@"name"]          = 昵称
/// param[@"auth_model"]    = 0 : 校验观看权限(默认)  1 : 不校验观看权限
- (void)preLoadRoomWithParam:(NSDictionary *)param;

/// 观看直播视频，在收到"播放连接成功回调"后，才可使用聊天、签到、问答、抽奖等功能
/// @param param 传参信息
/// param[@"id"]            = 活动Id，必传
/// param[@"name"]          = 昵称
/// param[@"auth_model"]    = 0 : 校验观看权限(默认)  1 : 不校验观看权限
- (BOOL)startPlay:(NSDictionary *)param;

/// 观看回放/点播视频，在收到"播放连接成功回调"后，才可使用聊天、签到、问答、抽奖等功能
/// @param param 传参信息
/// param[@"id"]            = 活动Id，必传
/// param[@"record_id"]     = 回放id，可以通过回放列表获取 getRecordListWithWebinarId
/// param[@"name"]          = 昵称
/// param[@"auth_model"]    = 0 : 校验观看权限(默认)  1 : 不校验观看权限
- (BOOL)startPlayback:(NSDictionary *)param;

/// 暂停播放 （如果是直播，等同于stopPlay）
- (void)pausePlay;

/// 播放出错/暂停播放后恢复播放
/// @return NO 播放器不是暂停状态 或者已经结束
- (BOOL)reconnectPlay;

/// 停止播放
- (void)stopPlay;

/// 设置静音
/// @param mute 是否静音
- (void)setMute:(BOOL)mute;

/// 销毁播放器
- (void)destroyMoivePlayer;

#pragma mark - 连麦互动方法

/// 发送 申请上麦/取消申请 消息
/// @param type 1申请上麦，0取消申请上麦
- (BOOL)microApplyWithType:(NSInteger)type;


/// 发送 申请上麦/取消申请 消息
/// @param type 1申请上麦，0取消申请上麦
/// @param finishBlock finishBlock 消息发送结果
- (BOOL)microApplyWithType:(NSInteger)type finish:(void (^)(NSError *error))finishBlock;


/// 收到邀请后 是否同意上麦
/// @param type 1接受，2拒绝，3超时失败
/// @param finishBlock 结果回调
- (BOOL)replyInvitationWithType:(NSInteger)type finish:(void (^)(NSError *error))finishBlock;

#pragma mark - 辅助方法

/// 获得当前时间视频截图 仅支持化蝶
- (void)takeVideoScreenshot:(void (^)(UIImage* image))screenshotBlock;

/// 清空视频剩余的最后一帧画面
- (void)cleanLastFrame;

/// 设置投屏对象 (投屏功能使用步骤：1、设置DLNAobj 2、收到DLNAobj设备列表回调后，设置投屏设备 3、DLNAobj初始化播放。如果播放过程中多个player使用对同一个DLNAobj，则DLNAobj需要重新初始化播放)
/// @param DLNAobj 投屏VHDLNAControl对象
/// @return YES 可投屏，NO不可投屏
- (BOOL)dlnaMappingObject:(VHDLNAControl *)DLNAobj;

/// 重连socket
- (BOOL)reconnectSocket;

/// 设置播放器背景色，默认黑色
- (void)playerBackgroundColor:(UIColor *)playerBgColor;

/// 设置播放器背景图片
- (void)playerBackgroundImage:(UIImage *)playerBgImage;

/// 设置音频输出设备
+ (void)audioOutput:(BOOL)inSpeaker;

/// 是否启用陀螺仪控制画面模式，仅播放 VR 活动时有效
/// @param usingGyro 是否使用陀螺仪
- (void)setUsingGyro:(BOOL) usingGyro __deprecated_msg("老flash专属功能,H5或化蝶用户不支持");

/// 设置视频显示的方向，用于陀螺仪方向校对，仅播放 VR 活动时，并且开启陀螺仪模式时，必须设置
/// @param orientation 方向
- (void)setUILayoutOrientation:(UIDeviceOrientation) orientation __deprecated_msg("老flash专属功能,H5或化蝶用户不支持");

/// 设置系统声音大小
/// @param size 音量范围[0.0~1.0]
+ (void)setSysVolumeSize:(float) size __deprecated_msg("iOS 7.0+ 弃用");

/// 获取系统声音大小
+ (float) getSysVolumeSize __deprecated_msg("iOS 7.0+ 弃用");

@end

@protocol VHallMoviePlayerDelegate <NSObject, VHallMoviePlayerDeprocatedDelegate>

@optional
/// 视频信息预加载完成回调，前提需使用方法"preLoadRoomWithParam"，收到此回调后，可以使用聊天、签到、问答、抽奖等功能，择机调用startPlay/startPlayback进行播放（可以实现在调用播放之前使用聊天等功能）
/// @param moviePlayer 播放器实例
/// @param activeState 活动状态
/// @param error    非空即预加载成功
- (void)preLoadVideoFinish:(VHallMoviePlayer *)moviePlayer
               activeState:(VHMovieActiveState)activeState
                     error:(NSError *)error;

/// 播放连接成功回调，前提需使用方法"startPlay/startPlayback"，收到此回调后，可以使用聊天、签到、问答、抽奖等功能
/// @param moviePlayer 播放器实例
/// @param info 相关信息
- (void)connectSucceed:(VHallMoviePlayer *)moviePlayer
                  info:(NSDictionary *)info;

/// 直播开始推流消息 注意：H5和互动活动 收到此消息后建议延迟 5s 开始播放
/// @param moviePlayer 播放器实例
- (void)liveDidStart:(VHallMoviePlayer *)moviePlayer;

/// 直播结束消息
/// @param moviePlayer 播放器实例
- (void)liveDidStoped:(VHallMoviePlayer *)moviePlayer;

/// 缓冲开始回调
/// @param moviePlayer 播放器实例
/// @param info 相关信息
- (void)bufferStart:(VHallMoviePlayer *)moviePlayer
               info:(NSDictionary *)info;

/// 缓冲结束回调
/// @param moviePlayer 播放器实例
/// @param info 相关信息
- (void)bufferStop:(VHallMoviePlayer *)moviePlayer
              info:(NSDictionary *)info;

/// 下载速率的回调
/// @param moviePlayer 播放器实例
/// @param info 下载速率信息，单位kbps，字典结构：{content：速度}
- (void)downloadSpeed:(VHallMoviePlayer *)moviePlayer
                 info:(NSDictionary *)info;

/// 视频流类型回调
/// @param moviePlayer 播放器实例moviePlayer:(VHallMoviePlayer *)player
/// @param info 字典结构：{content：流类型(VHStreamType)}
- (void)  moviePlayer:(VHallMoviePlayer *)moviePlayer
    recStreamTypeInfo:(NSDictionary *)info;

/// 播放时错误的回调
/// @param livePlayErrorType 直播错误类型
/// @param info 具体错误信息  字典结构：{code:错误码，content:错误信息} (错误码以及对应含义请前往VhallConst.h查看)
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer
          playError:(VHSaasLivePlayErrorType)livePlayErrorType
               info:(NSDictionary *)info;

/// 当前活动状态回调
/// @param activeState 活动状态
- (void)     moviePlayer:(VHallMoviePlayer *)moviePlayer
    activeStateDidChange:(VHMovieActiveState)activeState;

/// 当前视频播放模式，以及是否为vr活动回调
/// @param playMode 视频播放模式
/// @param isVrVideo 是否为vr活动
- (void)  moviePlayer:(VHallMoviePlayer *)moviePlayer
    loadVideoPlayMode:(VHMovieVideoPlayMode)playMode
            isVrVideo:(BOOL)isVrVideo;

/// 当前视频支持的播放模式列表回调
/// @param playModeList VHMovieVideoPlayMode播放模式组合，如@[@(VHMovieVideoPlayModeMedia),@(VHMovieVideoPlayModeVoice)]
- (void)      moviePlayer:(VHallMoviePlayer *)moviePlayer
    loadVideoPlayModeList:(NSArray *)playModeList;

/// 当前视频支持的清晰度列表回调
/// @param definitionList VHDefinition清晰度组合，如@[@(VHDefinitionOrigin),@(VHDefinitionUHD),@(VHDefinitionHD)]
- (void)        moviePlayer:(VHallMoviePlayer *)moviePlayer
    loadVideoDefinitionList:(NSArray *)definitionList;

/// 播放器状态回调
/// @param moviePlayer 播放器实例
/// @param state 播放器状态
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer
    statusDidChange:(VHPlayerState)state;

/// 视频宽髙回调（支持直播与点播）
/// @param moviePlayer 播放器实例
/// @param size 视频尺寸
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer
          videoSize:(CGSize)size;

#pragma mark - 点播

/// 当前播放时间回调
/// @param moviePlayer 播放器实例
/// @param currentTime 当前播放时间点 1s回调一次，可用于UI刷新
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer
        currentTime:(NSTimeInterval)currentTime;

/// 返回视频打点数据（若存在打点信息）
/// @param moviePlayer 播放器实例
/// @param pointArr 已打点的数据
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer
      videoPointArr:(NSArray <VHVidoePointModel *> *)pointArr;

#pragma mark - 互动

/// 当前活动是否允许举手申请上麦回调
/// @param moviePlayer 播放器实例
/// @param isInteractive 当前活动是否支持互动功能
/// @param state 主持人是否允许举手
- (void)      moviePlayer:(VHallMoviePlayer *)moviePlayer
    isInteractiveActivity:(BOOL)isInteractive
    interactivePermission:(VHInteractiveState)state;

/// 主持人是否同意上麦申请回调
/// @param moviePlayer 播放器实例
/// @param attributes 收到的数据
/// @param error 错误回调 nil：同意上麦  非nil：不同意上麦
- (void)              moviePlayer:(VHallMoviePlayer *)moviePlayer
    microInvitationWithAttributes:(NSDictionary *)attributes
                            error:(NSError *)error;

/// 被主持人邀请上麦
/// @param moviePlayer 播放器实例
/// @param attributes 收到的数据
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer
    microInvitation:(NSDictionary *)attributes;


#pragma mark - 其它

/// 被踢出
/// @param moviePlayer 播放器实例
/// @param isKickout 被踢出 （取消踢出后需要重新进入）
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer
          isKickout:(BOOL)isKickout;

/// 当前是否支持投屏功能
/// @param moviePlayer 播放器实例
/// @param isCast_screen 1支持 0不支持
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer
      isCast_screen:(BOOL)isCast_screen;

/// 主持人显示/隐藏文档
/// @param moviePlayer 播放器实例
/// @param isHave YES 此活动有文档演示
/// @param isShow YES 主持人显示观看端文档，NO 主持人隐藏观看端文档
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer
     isHaveDocument:(BOOL)isHave
     isShowDocument:(BOOL)isShow;

/// 直播文档同步，直播文档有延迟，指定需要延迟的秒数 （默认为直播缓冲时间，即：realityBufferTime/1000.0）
/// @param moviePlayer 播放器实例
- (NSTimeInterval)documentDelayTime:(VHallMoviePlayer *)moviePlayer;

/// 发布公告的回调
/// @param content 公告内容
/// @param pushTime 发布时间
/// @param duration 公告显示时长 0代表永久显示
- (void)             moviePlayer:(VHallMoviePlayer *)moviePlayer
    announcementContentDidChange:(NSString *)content
                        pushTime:(NSString *)pushTime
                        duration:(NSInteger)duration;

/// 当前是否开启问答功能
/// @param moviePlayer 播放器实例
/// @param isQuestion_status 1开启 0关闭
/// @param questionName v6.4 新增问答名称
- (void)  moviePlayer:(VHallMoviePlayer *)moviePlayer
    isQuestion_status:(BOOL)isQuestion_status
        question_name:(NSString *)questionName;

/// 当前是否开启文件下载功能
/// @param moviePlayer 播放器实例
/// @param is_file_download 1开启 0关闭
/// @param file_download_menu 菜单-文件下载
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer is_file_download:(BOOL)is_file_download file_download_menu:(VHallPlayMenuModel *)file_download_menu;

@end

@protocol VHallMoviePlayerDeprocatedDelegate <NSObject>

@optional
/// 视频流类型回调
/// @param moviePlayer 播放器实例
/// @param info 字典结构：{content：流类型(VHStreamType)}
- (void)recStreamtype:(VHallMoviePlayer *)moviePlayer
                 info:(NSDictionary *) info __deprecated_msg("此api名称不规范,推荐使用moviePlayer:recStreamTypeInfo:");

/// 播放时错误的回调
/// @param livePlayErrorType 直播错误类型
/// @param info 具体错误信息  字典结构：{code:错误码，content:错误信息} (错误码以及对应含义请前往VhallConst.h查看)
- (void)playError:(VHSaasLivePlayErrorType)livePlayErrorType
             info:(NSDictionary *) info __deprecated_msg("此api名称不规范,推荐使用moviePlayer:playError:info:");

/// 当前活动状态回调
/// @param activeState 活动状态
- (void)ActiveState:(VHMovieActiveState) activeState __deprecated_msg("此api名称不规范,推荐使用moviePlayer:activeStateDidChange:");

/// 当前视频播放模式，以及是否为vr活动回调
/// @param playMode 视频播放模式
/// @param isVrVideo 是否为vr活动
- (void)VideoPlayMode:(VHMovieVideoPlayMode)playMode
            isVrVideo:(BOOL) isVrVideo __deprecated_msg("此api名称不规范,推荐使用moviePlayer:loadVideoPlayMode:isVrVideo:");

/// 当前视频支持的播放模式列表回调
/// @param playModeList VHMovieVideoPlayMode播放模式组合，如@[@(VHMovieVideoPlayModeMedia),@(VHMovieVideoPlayModeVoice)]
- (void)VideoPlayModeList:(NSArray *) playModeList __deprecated_msg("此api名称不规范,推荐使用moviePlayer:loadVideoPlayModeList:");

/// 当前视频支持的清晰度列表回调
/// @param definitionList VHDefinition清晰度组合，如@[@(VHDefinitionOrigin),@(VHDefinitionUHD),@(VHDefinitionHD)]
- (void)VideoDefinitionList:(NSArray *) definitionList __deprecated_msg("此api名称不规范,推荐使用moviePlayer:loadVideoDefinitionList:");

/// 直播开始推流消息 注意：H5和互动活动 收到此消息后建议延迟 5s 开始播放
- (void) LiveStart __deprecated_msg("此api名称不规范,推荐使用liveDidStart:)");

/// 直播结束消息
- (void) LiveStoped __deprecated_msg("此api名称不规范,推荐使用liveDidStoped:)");

/// 发布公告的回调
/// @param content 公告内容
/// @param time 发布时间
- (void)Announcement:(NSString *)content
         publishTime:(NSString *) time __deprecated_msg("此api名称不规范,推荐使用announcementContentDidChange:pushTime:)");

@end
