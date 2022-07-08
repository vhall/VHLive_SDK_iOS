//
//  VHVideoRoundModel.m
//  UIModel
//
//  Created by 郭超 on 2022/6/21.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHVideoRoundModel.h"
#import "Reachability.h"
#import <VHInteractive/VHRoom.h>

@interface VHVideoRoundModel ()<VHRoomDelegate>
/// 互动房间
@property (nonatomic, strong) VHRoom * videoRoundRoom;
/// 视频轮巡RenderView
@property (nonatomic, strong) VHLocalRenderView * videoRoundRenderView;
/// roomID
@property (nonatomic, copy) NSString * roomId;
/// 网络监听
@property(nonatomic, strong) Reachability * reachAbility;

@end

@implementation VHVideoRoundModel

- (void)dealloc
{
    [_reachAbility stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    if ([super init]) {
        //程序进入前后台监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        //监听网络变化
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChange:) name:kReachabilityChangedNotification object:nil];
        _reachAbility = [Reachability reachabilityForInternetConnection];
        [_reachAbility startNotifier];
    }return self;
}
#pragma mark  网络变化
- (void)networkChange:(NSNotification *)notification
{
    Reachability *currReach = [notification object];
    
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    
    //对连接改变做出响应处理动作
    NetworkStatus status = [currReach currentReachabilityStatus];
    
    switch (status) {
        case NotReachable:
        {
            //如果没有连接到网络就弹出提醒实况
            VH_ShowToast(@"网络断开");
            [self closeVideoRound];
        }
            break;
        case ReachableViaWiFi:
        {
            //wifi
            //请求最新数据
            [self getRoundUsers];
        }
            break;
        case ReachableViaWWAN:
        {
            //数据网络
            //请求最新数据
            [self getRoundUsers];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 开启轮询
- (void)videoRoundUsers:(NSArray *)uids roomId:(NSString *)roomId
{
    self.roomId = roomId;
    
    BOOL isHave = NO;
    for (NSString * userId in uids) {
        if ([userId isEqualToString:[VHallApi currentUserID]]) {
            isHave = YES;
            break;
        }
    }
    if (isHave) {
        // 开始轮询
        [self startVideoRoundRoomId:self.roomId];
    }else{
        // 关闭轮询
        [self closeVideoRound];
    }
}

#pragma mark - 开始轮询
- (void)startVideoRoundRoomId:(NSString *)roomId
{
    // 如果在推流 则不去调用加入房间等操作
    if (self.videoRoundRoom.isPublishing && self.videoRoundRoom.status == VHRoomStatusConnected) {
        return;
    }
    [self.videoRoundRoom enterRoomWithRoomId:roomId];
}

#pragma mark - 关闭轮询
- (void)closeVideoRound
{
    if (_videoRoundRoom) {
        [_videoRoundRoom leaveRoom];
        _videoRoundRoom = nil;
    }
    if (_videoRoundRenderView) {
        _videoRoundRenderView = nil;
    }
}

#pragma mark - VHRoomDelegate
- (void)room:(VHRoom *)room enterRoomWithError:(NSError *)error {
    if(error == nil) { //加入房间成功
        [self.videoRoundRoom publishWithCameraView:self.videoRoundRenderView];
    }else{
        VHLog(@"加入错误:%@",error.description);
    }
}

// 房间连接成功回调
- (void)room:(VHRoom *)room didConnect:(NSDictionary *)roomMetadata {
    VUI_Log(@"房间连接成功");
}

//推流成功
- (void)room:(VHRoom *)room didPublish:(VHRenderView *)cameraView {
    VUI_Log(@"推流成功");
}

// 停止推流成功
- (void)room:(VHRoom *)room didUnpublish:(VHRenderView *)cameraView {
    VUI_Log(@"停止推流成功");
}

//错误回调
- (void)room:(VHRoom *)room didError:(VHRoomErrorStatus)status reason:(NSString *)reason {
    VUI_Log(@"房间错误：%@---status：%zd",reason,status);
}

//房间状态变化
- (void)room:(VHRoom *)room didChangeStatus:(VHRoomStatus)status {
    VUI_Log(@"房间状态变化：%zd",status);
}

#pragma mark - 轮询列表
- (void)getRoundUsers
{
    __weak __typeof(self)weakSelf = self;
    [self.videoRoundRoom getRoundUsersWithIs_next:@"0" success:^(NSDictionary *response) {
        NSDictionary * data = response[@"data"];
        NSMutableArray * users = [NSMutableArray array];
        for (NSDictionary * dic in data[@"list"]) {
            [users addObject:dic[@"account_id"]];
        }
        [weakSelf videoRoundUsers:users roomId:weakSelf.roomId];
    } fail:^(NSError *error) {
        
    }];
}
#pragma mark - 切换前后台
//前台
- (void)appWillEnterForeground {
    [self getRoundUsers];
}

//后台
- (void)appEnterBackground {
    // 关闭轮询
    [self closeVideoRound];
}

#pragma mark - 懒加载

- (VHRoom *)videoRoundRoom {
    if (!_videoRoundRoom) {
        _videoRoundRoom = [[VHRoom alloc] init];
        _videoRoundRoom.delegate = self;
    }
    return _videoRoundRoom;
}

- (VHLocalRenderView *)videoRoundRenderView {
    if (!_videoRoundRenderView) {
        NSDictionary *options = @{VHStreamOptionMixVideo:@NO,VHStreamOptionMixAudio:@NO,VHStreamOptionStreamType:@(VHInteractiveStreamTypeVideoPatrol)};
        _videoRoundRenderView = [[VHLocalRenderView alloc] initCameraViewWithFrame:CGRectMake(0, 0, VHScreenWidth, VHScreenHeight) options:options];
        _videoRoundRenderView.scalingMode = VHRenderViewScalingModeAspectFit;
        [_videoRoundRenderView muteAudio];
    }
    return _videoRoundRenderView;
}

@end
