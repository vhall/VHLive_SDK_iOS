//
//  VHFashionStyleInteractView.m
//  UIModel
//
//  Created by 郭超 on 2022/7/21.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHFashionStyleInteractView.h"
#import "VHFashionStyleInteractCollectionView.h"

@interface VHFashionStyleInteractView ()<VHRoomDelegate>

/// 互动View
@property (nonatomic, strong) VHFashionStyleInteractCollectionView * interactView;
/// 当前互动人数
@property (nonatomic, assign) NSInteger  current_inav_num;

@end

@implementation VHFashionStyleInteractView


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
    // 添加本地预览视图
    [self.localRenderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    // 添加互动视频容器
    [self.interactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}
#pragma mark - 上麦推流
- (void)enterRoomPublish
{
    [self.inavRoom enterRoomWithParams:[self playParam]];
}
#pragma mark - 下麦并退出互动房间
- (void)leave
{
    [self.localRenderView removeFromSuperview];
    [self.inavRoom unpublish];
    [self.inavRoom leaveRoom];
}

#pragma mark - --------------VHRoomDelegate---------------
/// 进入房间回调
- (void)room:(VHRoom *)room enterRoomWithError:(NSError *)error
{
    if (error) {
        VH_ShowToast(error.localizedDescription);
    }
}
/// 房间连接成功回调
- (void)room:(VHRoom *)room didConnect:(NSDictionary *)roomMetadata
{
    //开始推流
    [room publishWithCameraView:self.localRenderView];
}

/// 房间发生错误回调
- (void)room:(VHRoom *)room didError:(VHRoomErrorStatus)status reason:(NSString *)reason
{
    if (reason) {
        VH_ShowToast(reason);
    }
}

/// 房间状态改变回调
- (void)room:(VHRoom *)room didChangeStatus:(VHRoomStatus)status
{
    
}

/// 推流成功回调
- (void)room:(VHRoom *)room didPublish:(VHRenderView *)cameraView
{
    // 更新互动人数
    self.current_inav_num = self.current_inav_num + 1;
    // 移除本地预览视频
    self.localRenderView = (VHLocalRenderView *)cameraView;
    
    // 添加自己的视频view
    VHLiveMemberModel *model = [VHLiveMemberModel modelWithVHRenderView:self.localRenderView];
    if(model.videoView.isLocal) { // 如果是本地视频，设置当前视频/音频开启情况
        model.closeCamera = YES;
        model.closeMicrophone = YES;
    }
    model.haveDocPermission = [self.inavRoom.roomInfo.mainSpeakerId isEqualToString:model.account_id];
    
    // 添加
    [self.interactView addAttendWithUser:model];
}

/// 停止推流回调
- (void)room:(VHRoom *)room didUnpublish:(VHRenderView *)cameraView
{
    
}

/// 视频流加入回调（流类型包括音视频、共享屏幕、插播等）
- (void)room:(VHRoom *)room didAddAttendView:(VHRenderView *)attendView
{
    if (attendView.streamType == VHInteractiveStreamTypeVideoPatrol) {
        return;//过滤视频轮巡流
    }
    VUI_Log(@"\n某人上麦:%@，流类型：%d，流视频宽高：%@，流id：%@，是否有音频：%d，是否有视频：%d",attendView.userId,attendView.streamType,NSStringFromCGSize(attendView.videoSize),attendView.streamId,attendView.hasAudio,attendView.hasVideo);
    
    // 更新互动人数
    self.current_inav_num = self.current_inav_num + 1;

    VHLiveMemberModel *model = [VHLiveMemberModel modelWithVHRenderView:(VHLocalRenderView *)attendView];
    model.haveDocPermission = [self.inavRoom.roomInfo.mainSpeakerId isEqualToString:model.account_id];
    
    // 添加
    [self.interactView addAttendWithUser:model];
}

/// 视频流离开回调（流类型包括音视频、共享屏幕、插播等）
- (void)room:(VHRoom *)room didRemovedAttendView:(VHRenderView *)attendView
{
    // 移除
    [self.interactView removeAttendView:(VHLocalRenderView *)attendView];

    if (attendView.streamType == VHInteractiveStreamTypeVideoPatrol) {
        return;// 过滤视频轮巡流
    }
    
    // 更新互动人数
    if (self.current_inav_num > 0) {
        self.current_inav_num = self.current_inav_num - 1;
    }
}

- (void)room:(VHRoom *)room receiveRoomMessage:(VHRoomMessage *)message {
    VUI_Log(@"messageType====%ld",(long)message.messageType);

    // 该消息目标用户是否为自己
    BOOL targetIsMyself = message.targetForMe;
    // 该消息对应的目标用户id
    NSString * targetId = message.targetId;
    // 该消息对应的目标用户昵称
    NSString * targetName = message.targetName;

    // 加入用户id
   NSString * joinUser = room.roomInfo.data[@"join_info"][@"third_party_user_id"];
    // 主持人id
    NSString * host_id = [NSString stringWithFormat:@"%@",room.roomInfo.data[@"webinar"][@"userinfo"][@"user_id"]];
    
    switch (message.messageType) {
        case VHRoomMessageType_vrtc_speaker_switch:
        {// 设置主讲人
            VHLog(@"%@",[NSString stringWithFormat:@"设置%@为主讲人",targetName]);
            // 设置主讲人
            self.inavRoom.roomInfo.mainSpeakerId = targetId;
            self.interactView.mainSpeakerId = targetId;
            NSMutableArray *micUserList = [self.interactView getMicUserList];
            [micUserList enumerateObjectsUsingBlock:^(VHLiveMemberModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                model.haveDocPermission = [targetId isEqualToString:model.account_id];
            }];
            //更新视频view 主讲人标识
            [self.interactView reloadAllData];
        }
            break;
        case VHRoomMessageType_vrtc_disconnect_success:
        {// 用户下麦成功
            if(targetIsMyself) {
                // 自己
                VH_ShowToast(@"您已下麦");
                // 移除自己的视频view
                [self.interactView removeAttendView:self.localRenderView];
                // 下麦并退出互动房间
                if (self.clickLeave) {
                    self.clickLeave();
                }
            }else {
                NSString *name = targetName.length > VH_MaxNickNameCount ? [NSString stringWithFormat:@"%@...",[targetName substringToIndex:VH_MaxNickNameCount]] : targetName;
                NSString *tipText = [NSString stringWithFormat:@"%@已下麦",name];
                VH_ShowToast(tipText);
            }
        }break;
        case VHRoomMessageType_vrtc_big_screen_set:
        {// 设置主屏
            VHLog(@"%@",[NSString stringWithFormat:@"设置%@为主屏",targetName]);
            NSMutableArray *micUserList = [self.interactView getMicUserList];
            [micUserList enumerateObjectsUsingBlock:^(VHLiveMemberModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                model.haveDocPermission = [targetId isEqualToString:model.account_id];
            }];
            //更新视频view 主讲人标识
            [self.interactView reloadAllData];
        }break;
        default:
            break;
    }
    
}

#pragma mark - -----------------------设备状态----------------------------
#pragma mark - 自己的麦克风状态改变
- (void)room:(VHRoom *)room microphoneClosed:(BOOL)isClose
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(room:microphoneClosed:)]) {
        [self.delegate room:room microphoneClosed:isClose];
    }
}
#pragma mark - 自己的摄像头状态改变
- (void)room:(VHRoom *)room screenClosed:(BOOL)isClose
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(room:screenClosed:)]) {
        [self.delegate room:room screenClosed:isClose];
    }
}
#pragma mark - 懒加载
- (VHRoom *)inavRoom {
    if (!_inavRoom) {
        _inavRoom = [[VHRoom alloc] init];
        _inavRoom.delegate = self;
    }
    return _inavRoom;
}

- (VHLocalRenderView *)localRenderView
{
    if (!_localRenderView) {
        VHFrameResolutionValue resolution = VHFrameResolution480x360;
        if (self.current_inav_num > 0 && self.current_inav_num <= 5) {
            resolution = VHFrameResolution480x360;
        } else if (self.current_inav_num > 5 && self.current_inav_num < 10) {
            resolution = VHFrameResolution320x240;
        }else{
            resolution = VHFrameResolution240x160;
        }

        NSDictionary *options = @{VHFrameResolutionTypeKey:@(resolution),VHStreamOptionStreamType:@(VHInteractiveStreamTypeAudioAndVideo)};
        _localRenderView = [[VHLocalRenderView alloc] initCameraViewWithFrame:CGRectZero options:options];
        [_localRenderView setDeviceOrientation:UIDeviceOrientationPortrait];
        [_localRenderView setScalingMode:VHRenderViewScalingModeAspectFill];
        [self addSubview:_localRenderView];
    }
    return _localRenderView;
}

- (VHFashionStyleInteractCollectionView *)interactView
{
    if (!_interactView) {
        _interactView = [[VHFashionStyleInteractCollectionView alloc] init];
        [self addSubview:_interactView];
    }
    return _interactView;
}

- (NSDictionary *)playParam {
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    param[@"id"] =  _roomId;
    if (_kValue &&_kValue.length>0) {
        param[@"pass"] = _kValue;
    }
    param[@"name"] = [UIDevice currentDevice].name;
    param[@"email"] = [NSString stringWithFormat:@"%@@qq.com",[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    return param;
}

@end
