//
//  VHWatchVideoView.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/13.
//

#import <UIKit/UIKit.h>

@protocol VHWatchVideoViewDelegate <NSObject>

// 播放连接成功
- (void)connectSucceed:(VHallMoviePlayer *)moviePlayer info:(NSDictionary *)info;

// 主持人显示/隐藏文档
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer
     isHaveDocument:(BOOL)isHave
     isShowDocument:(BOOL)isShow;

// 直播文档同步，直播文档有延迟，指定需要延迟的秒数 （默认为直播缓冲时间，即：realityBufferTime/1000.0）
- (NSTimeInterval)documentDelayTime:(VHallMoviePlayer *)moviePlayer;

/// 发布公告的回调
/// @param content 公告内容
/// @param pushTime 发布时间
/// @param duration 显示时长 单位：秒  最小传入10   0:默认一直显示
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer announcementContentDidChange:(NSString *)content pushTime:(NSString *)pushTime duration:(NSInteger)duration;

/// 当前活动是否允许举手申请上麦回调
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer isInteractiveActivity:(BOOL)isInteractive interactivePermission:(VHInteractiveState)state;

/// 主持人是否同意上麦申请回调
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer microInvitationWithAttributes:(NSDictionary *)attributes error:(NSError *)error;

/// 被主持人邀请上麦
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer microInvitation:(NSDictionary *)attributes;

/// 屏幕旋转
- (void)clickFullIsSelect:(BOOL)isSelect;

/// 是否打开问答
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer isQuestion_status:(BOOL)isQuestion_status question_name:(NSString *)questionName;

/// 直播已结束回调
- (void)liveDidStoped:(VHallMoviePlayer *)moviePlayer;

/// 被踢出
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer isKickout:(BOOL)isKickout;

/// 返回视频打点数据（若存在打点信息）
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer videoPointArr:(NSArray <VHVidoePointModel *> *)pointArr;

@end

@interface VHWatchVideoView : UIView

/// 代理对象
@property (nonatomic, weak) id <VHWatchVideoViewDelegate> delegate;

/// 播放器
@property (nonatomic, strong) VHallMoviePlayer *moviePlayer;

/// 初始化
/// - Parameter webinarId: 活动id
/// - Parameter recordId: 指定回放id
/// - Parameter type: 活动状态
- (instancetype)initWithWebinarId:(NSString *)webinarId type:(VHMovieActiveState)type;

/// 开始播放
- (void)startPlay;

/// 暂停播放
- (void)pausePlay;

/// 停止播放
- (void)stopPlay;

/// 恢复
- (void)reconnectPlay;

/// 播放指定回放视频
/// - Parameter recordId: 回放id
- (void)startPlayBackWithRecordId:(NSString *)recordId;

/// 销毁播放器
- (void)destroyMP;

/// 收到虚拟人数消息
- (void)vhBaseNumUpdateToUpdate_online_num:(NSInteger)update_online_num
                                 update_pv:(NSInteger)update_pv;
/// 收到上下线消息
- (void)reciveOnlineMsg:(NSArray <VHallOnlineStateModel *> *)msgs;

/// 退出全屏
- (void)quitFull;

@end
