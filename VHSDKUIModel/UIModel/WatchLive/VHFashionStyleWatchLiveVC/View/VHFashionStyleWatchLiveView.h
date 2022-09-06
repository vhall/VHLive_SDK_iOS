//
//  VHFashionStyleWatchLiveView.h
//  UIModel
//
//  Created by 郭超 on 2022/7/21.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VHFashionStyleWatchLiveViewDelegate <NSObject>

// 播放连接成功
- (void)connectSucceed:(VHallMoviePlayer *)moviePlayer info:(NSDictionary *)info;

//直播开始回调
- (void)liveStart;

//直播已结束回调
- (void)liveStoped;

// 主持人是否允许举手
- (void)moviePlayer:(VHallMoviePlayer *)player isInteractiveActivity:(BOOL)isInteractive interactivePermission:(VHInteractiveState)state;

// 主持人同意上麦回调
- (void)moviePlayer:(VHallMoviePlayer *)player microInvitationWithAttributes:(NSDictionary *)attributes error:(NSError *)error;

// 主持人邀请你上麦
- (void)moviePlayer:(VHallMoviePlayer *)player microInvitation:(NSDictionary *)attributes;

// 被踢出
- (void)moviePlayer:(VHallMoviePlayer*)player isKickout:(BOOL)isKickout;

@end

@interface VHFashionStyleWatchLiveView : UIView

/// 代理对象
@property (nonatomic, weak) id <VHFashionStyleWatchLiveViewDelegate> delegate;

/// 播放器
@property (nonatomic, strong) VHallMoviePlayer  * moviePlayer;

/// 活动id
@property(nonatomic,copy)NSString * roomId;
/// 活动观看密码
@property(nonatomic,copy)NSString * kValue;
/// 互动美颜开关
@property (nonatomic, assign) BOOL interactBeautifyEnable;

@end

NS_ASSUME_NONNULL_END
