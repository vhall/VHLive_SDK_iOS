//
//  VHFashionStyleWatchLiveView.m
//  UIModel
//
//  Created by 郭超 on 2022/7/21.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHFashionStyleWatchLiveView.h"

@interface VHFashionStyleWatchLiveView ()<VHallMoviePlayerDelegate,VHWebinarInfoDelegate>

@end

@implementation VHFashionStyleWatchLiveView

- (instancetype)init
{
    if ([super init]) {
        
        // 添加控件
        [self addViews];

    }return self;
}

#pragma mark - 添加UI
- (void)addViews
{
    // 初始化UI
    [self masonryUI];
}

#pragma mark - 初始化UI
- (void)masonryUI
{
    self.moviePlayer.moviePlayerView.frame = self.bounds;
}

#pragma mark - 刷新布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _moviePlayer.moviePlayerView.frame = self.bounds;
}

#pragma mark - VHMoviePlayerDelegate
#pragma mark - -----------------VHallMoviePlayer 播放器状态相关--------------------
// 播放器预加载
- (void)preLoadVideoFinish:(VHallMoviePlayer*)moviePlayer activeState:(VHMovieActiveState)activeState error:(NSError*)error
{
    VHLog(@"播放器预加载：%@",error);
}
// 播放连接成功
- (void)connectSucceed:(VHallMoviePlayer *)moviePlayer info:(NSDictionary *)info
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(connectSucceed:info:)]) {
        [self.delegate connectSucceed:moviePlayer info:info];
    }
}
// 播放器状态
- (void)moviePlayer:(VHallMoviePlayer *)player statusDidChange:(VHPlayerState)state
{
    VHLog(@"播放连接状态：%ld",state);
}
// 播放时错误的回调
- (void)playError:(VHSaasLivePlayErrorType)livePlayErrorType info:(NSDictionary *)info
{
    VHLog(@"播放错误：%@",info);
    NSString * errorStr = info[@"content"];
    VH_ShowToast(errorStr);
}

#pragma mark - -----------------房间相关--------------------
//直播开始回调
- (void)LiveStart{
    if (self.delegate && [self.delegate respondsToSelector:@selector(liveStart)]) {
        [self.delegate liveStart];
    }
}
//直播已结束回调
- (void)LiveStoped
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(liveStoped)]) {
        [self.delegate liveStoped];
    }
}

#pragma mark - -----------------VHallMoviePlayer 上下麦相关--------------------
// 主持人是否允许举手
- (void)moviePlayer:(VHallMoviePlayer *)player isInteractiveActivity:(BOOL)isInteractive interactivePermission:(VHInteractiveState)state
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(moviePlayer:isInteractiveActivity:interactivePermission:)]) {
        [self.delegate moviePlayer:player isInteractiveActivity:isInteractive interactivePermission:state];
    }
}
// 主持人同意上麦回调
- (void)moviePlayer:(VHallMoviePlayer *)player microInvitationWithAttributes:(NSDictionary *)attributes error:(NSError *)error {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(moviePlayer:microInvitationWithAttributes:error:)]) {
        [self.delegate moviePlayer:player microInvitationWithAttributes:attributes error:error];
    }
}
// 主持人邀请你上麦
- (void)moviePlayer:(VHallMoviePlayer *)player microInvitation:(NSDictionary *)attributes
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(moviePlayer:microInvitation:)]) {
        [self.delegate moviePlayer:player microInvitation:attributes];
    }
}
/// 被踢出
- (void)moviePlayer:(VHallMoviePlayer*)player isKickout:(BOOL)isKickout
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(moviePlayer:isKickout:)]) {
        [self.delegate moviePlayer:player isKickout:isKickout];
    }
}

#pragma mark - 懒加载
- (VHallMoviePlayer *)moviePlayer
{
    if (!_moviePlayer) {
        _moviePlayer = [[VHallMoviePlayer alloc] initWithDelegate:self];
        _moviePlayer.movieScalingMode = VHRTMPMovieScalingModeAspectFit;
        _moviePlayer.defaultDefinition = VHMovieDefinitionHD;
        [self addSubview:_moviePlayer.moviePlayerView];
    }return _moviePlayer;
}

@end
