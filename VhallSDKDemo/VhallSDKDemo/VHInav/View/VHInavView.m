//
//  VHInavView.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/20.
//

#import "VHInavView.h"
#import "VHInavRenderAlertView.h"

@implementation VHInavCell

- (void)dealloc
{
    VHLog(@"%s释放",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String]);
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor blackColor];
                
        [self setMasonryUI];
    }
    return self;
}
- (void)setMasonryUI
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
}


#pragma mark - 赋值
- (void)setAttendView:(VHRenderView *)attendView
{
    _attendView = attendView;
    
    [self.contentView addSubview:attendView];
    [attendView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.contentView addSubview:self.nickNameLab];
    [self.nickNameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
    }];
    
    [self.contentView addSubview:self.headIcon];
    [self.headIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.size.equalTo(@(CGSizeMake(60, 60)));
    }];

    NSDictionary *userData = attendView.userData.mj_JSONObject;
    NSDictionary *streamAttributes = attendView.streamAttributes.mj_JSONObject;

    NSString * nickName = streamAttributes[@"nickName"];
    self.nickNameLab.text = [VUITool substringToIndex:8 text:nickName isReplenish:YES];
    
    NSString * avatar = streamAttributes[@"avatar"];
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"vh_no_head_icon"]];
    
    NSMutableDictionary * remoteMuteStream = [NSMutableDictionary dictionary];
    
    if (self.isMe) {
        remoteMuteStream = [NSMutableDictionary dictionaryWithDictionary:attendView.muteStream];
    } else {
        remoteMuteStream = [NSMutableDictionary dictionaryWithDictionary:attendView.remoteMuteStream.mj_JSONObject];
    }
    
    BOOL isCloseVideo = [remoteMuteStream[@"video"] boolValue];
    
    self.headIcon.hidden = !isCloseVideo;
    
    VHLog(@"---用户进入房间时传的数据：%@---用户推流上麦时所传数据：%@---此流的 流音视频开启情况：%@",userData,streamAttributes,remoteMuteStream);
}

#pragma mark - 懒加载
- (UILabel *)nickNameLab {
    if (!_nickNameLab) {
        _nickNameLab = [[UILabel alloc] init];
        _nickNameLab.textColor = [UIColor whiteColor];
        _nickNameLab.font = FONT(10);
    }
    return _nickNameLab;
}

- (UIImageView *)headIcon
{
    if (!_headIcon){
        _headIcon = [[UIImageView alloc] init];
        _headIcon.backgroundColor = [UIColor colorWithHex:@"efeff4"];
        _headIcon.contentMode = UIViewContentModeScaleAspectFill;
        _headIcon.layer.cornerRadius = 30;
        _headIcon.layer.masksToBounds = YES;
    } return _headIcon;
}

@end

@interface VHInavView ()<VHRoomDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/// 房间详情
@property (nonatomic, strong) VHRoomInfo * roomInfo;
/// 活动详情
@property (nonatomic, strong) VHWebinarInfoData * webinarInfoData;

/// 互动view
@property (nonatomic, strong) UICollectionView * collectionView;
/// 数据源
@property (nonatomic, strong) NSMutableArray * dataSource;
/// 设备操作
@property (nonatomic, strong) VHInavRenderAlertView * inavRenderAlertView;

@end

@implementation VHInavView
- (void)dealloc
{
    VHLog(@"%s释放",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String]);
}
#pragma mark - 初始化
- (instancetype)initWithWebinarInfoData:(VHWebinarInfoData *)webinarInfoData
{
    if ([super init]) {
        
        self.webinarInfoData = webinarInfoData;
        
        // 添加控件
        [self addViews];
        
        // 初始化UI
        [self masonryUI];
        

    }return self;
}

#pragma mark - 添加UI
- (void)addViews
{
    [self addSubview:self.localRenderView];

    [self addSubview:self.collectionView];
}

#pragma mark - 初始化UI
- (void)masonryUI
{
    [self.localRenderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark - 刷新布局
- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - 进入房间
- (void)enterRoomBtn
{
    [self.inavRoom enterRoomWithParams:self.inavRoomParam];
}
#pragma mark - VHRoomDelegate
#pragma mark - 进入房间回调
- (void)room:(VHRoom *)room enterRoomWithError:(NSError *)error
{
    if (error) {
        [self errorLeaveInavDelegate];
    }
    [VHProgressHud showToast:error ? error.localizedDescription : @"进入房间成功"];
}
#pragma mark - 房间连接成功回调
- (void)room:(VHRoom *)room didConnect:(NSDictionary *)roomMetadata
{
    [VHProgressHud showToast:@"房间连接成功"];
    // 获取房间详情
    self.roomInfo = room.roomInfo;
    // 开始推流
    [self.inavRoom publishWithCameraView:self.localRenderView];
}

#pragma mark - 房间发生错误回调
- (void)room:(VHRoom *)room didError:(VHRoomErrorStatus)status reason:(NSString *)reason
{
    if (status == VHRoomErrorKickout) {
        [VHProgressHud showToast:@"被踢出"];
        if ([self.delegate respondsToSelector:@selector(isKickout:)]) {
            [self.delegate isKickout:YES];
        }
    } else {
        [VHProgressHud showToast:@"互动异常"];
        if ([self.delegate respondsToSelector:@selector(leaveRoom)]) {
            [self.delegate leaveRoom];
        }
    }
}

#pragma mark - 房间状态改变回调
- (void)room:(VHRoom *)room didChangeStatus:(VHRoomStatus)status
{
    if (status == VHRoomStatusDisconnected || status == VHRoomStatusError) {
        [self errorLeaveInavDelegate];
    }
    VHLog(@"房间状态改变 === %ld",status);
}

#pragma mark - 推流成功回调
- (void)room:(VHRoom *)room didPublish:(VHRenderView *)cameraView
{
    [VHProgressHud showToast:@"推流成功"];
    
    [self.dataSource addObject:cameraView];
    [self reloadDataSource];
}

#pragma mark - 停止推流回调
- (void)room:(VHRoom *)room didUnpublish:(VHRenderView *)cameraView
{
    [VHProgressHud showToast:@"停止推流"];
}

#pragma mark - 视频流加入回调（流类型包括音视频、共享屏幕、插播等）
- (void)room:(VHRoom *)room didAddAttendView:(VHRenderView *)attendView
{
    if (attendView.streamType == VHInteractiveStreamTypeVideoPatrol) {
        return;//过滤视频轮巡的流
    }
    // 添加视频流
    VHLog(@"\n某人上麦:%@，流类型：%d，流视频宽高：%@，流id：%@，是否有音频：%d，是否有视频：%d",attendView.userId,attendView.streamType,NSStringFromCGSize(attendView.videoSize),attendView.streamId,attendView.hasAudio,attendView.hasVideo);
    
    [self.dataSource addObject:attendView];
    [self reloadDataSource];
}

#pragma mark - 视频流离开回调（流类型包括音视频、共享屏幕、插播等）
- (void)room:(VHRoom *)room didRemovedAttendView:(VHRenderView *)attendView
{
    if (attendView.streamType == VHInteractiveStreamTypeVideoPatrol) {
        return;//过滤视频轮巡的流
    }
    VHLog(@"某人下麦:%@",attendView.userId);
    
    [self.dataSource removeObject:attendView];
    [self reloadDataSource];
}

#pragma mark - 流音视频开启情况
- (void)room:(VHRoom *)room didUpdateOfStream:(NSString *)streamId muteStream:(NSDictionary *)muteStream
{
    for (VHLocalRenderView * attendView in self.dataSource) {
        if ([attendView.streamId isEqual:streamId]) {
            attendView.remoteMuteStream = muteStream;
            break;
        }
    }
    [self reloadDataSource];
}

#pragma mark - 互动相关消息回调（推荐使用） v6.1及以上
- (void)room:(VHRoom *)room receiveRoomMessage:(VHRoomMessage *)message
{
    switch (message.messageType) {
        case VHRoomMessageType_vrtc_connect_agree: {// 某个用户发起的上麦申请被主持人同意
        }
            break;
        case VHRoomMessageType_vrtc_connect_refused: {// 某个用户发起的上麦申请被主持人拒绝
        }
            break;
        case VHRoomMessageType_vrtc_disconnect_success: {// 用户下麦成功
            if(message.targetForMe) {
                [VHProgressHud showToast:@"您已被下麦"];
                [self.inavRenderAlertView disMissContentView];
                if ([self.delegate respondsToSelector:@selector(unApplyAction)]) {
                    [self.delegate unApplyAction];
                }
            }
        }break;
        case VHRoomMessageType_vrtc_mute: {//静音消息
            if(message.targetForMe) {
                [self reloadDataSource];
            }
        }break;
        case VHRoomMessageType_vrtc_mute_cancel: {//取消静音消息
            if(message.targetForMe) {
                [self reloadDataSource];
            }
        }break;
        case VHRoomMessageType_vrtc_frames_forbid: {//关闭摄像头消息
            if(message.targetForMe) {
                [self reloadDataSource];
            }
        }break;
        case VHRoomMessageType_vrtc_frames_display: {//开启摄像头消息
            if(message.targetForMe) {
                [self reloadDataSource];
            }
        }break;
        case VHRoomMessageType_vrtc_big_screen_set: {//用户互动流画面被设置为旁路大画面
            // 更新主讲人id
            self.roomInfo.main_screen = message.targetId;
            // 判断是自己
            if (message.targetForMe) {
                [VHProgressHud showToast:@"您已被设为主讲人"];
            }
            // 排序
            [self reloadDataSource];
        }break;
        case VHRoomMessageType_vrtc_speaker_switch:
        {//设置主讲人
        }break;

        default:
            break;
    }
}

#pragma mark - 是否是主讲人
- (BOOL)haveDocPermission:(VHRenderView *)attendView {
    if([self.roomInfo.main_screen isEqualToString:attendView.userId]) {
        return YES;
    }else {
        return NO;
    }
}

#pragma mark - 排序 设置主讲人在第一个
- (void)reloadDataSource
{
    // 刷新设备状态
    [self clickInavRenderAlertViewIsShow:NO];
    
    // 主画面放在第一位
    if (self.dataSource.count > 0) {
        for (VHRenderView * attendView in self.dataSource.reverseObjectEnumerator) {
            if ([self haveDocPermission:attendView]){
                [self.dataSource removeObject:attendView];
                [self.dataSource insertObject:attendView atIndex:0];
                break;
            }
        }
    }
    // 刷新
    [self.collectionView reloadData];
}

#pragma mark - -----------------------设备状态----------------------------
#pragma mark - 自己的麦克风状态改变
- (void)room:(VHRoom *)room microphoneClosed:(BOOL)isClose
{
    [VHProgressHud showToast:[NSString stringWithFormat:@"%@麦克风",isClose ? @"关闭" : @"打开"]];
}

#pragma mark - 自己的摄像头状态改变
- (void)room:(VHRoom *)room screenClosed:(BOOL)isClose
{
    [VHProgressHud showToast:[NSString stringWithFormat:@"%@摄像头 ",isClose ? @"关闭" : @"打开"]];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VHInavCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VHInavCell" forIndexPath:indexPath];
    VHLocalRenderView * attendView = self.dataSource[indexPath.row];
    cell.isMe = [self.localRenderView isEqual:attendView];
    cell.attendView = attendView;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark - 弹出设备权限操作
- (void)clickInavRenderAlertViewIsShow:(BOOL)isShow
{
    NSDictionary *remoteMuteStream = self.localRenderView.remoteMuteStream.mj_JSONObject;
    if (!remoteMuteStream) {
        remoteMuteStream = self.localRenderView.muteStream;
    }
    BOOL isCloseVideo = [remoteMuteStream[@"video"] boolValue];
    BOOL isCloseAudio = [remoteMuteStream[@"audio"] boolValue];

    [self.inavRenderAlertView showCameraStatus:!isCloseVideo micStatus:!isCloseAudio isShow:isShow];
    
    __weak __typeof(self)weakSelf = self;
    // 点击摄像头
    self.inavRenderAlertView.cameraAction = ^(BOOL cameraStatus) {
        cameraStatus ? [weakSelf.localRenderView muteVideo] : [weakSelf.localRenderView unmuteVideo];
    };
    
    // 点击麦克风
    self.inavRenderAlertView.micAction = ^(BOOL micStatus) {
        micStatus ? [weakSelf.localRenderView muteAudio] : [weakSelf.localRenderView unmuteAudio];
    };
    
    // 翻转
    self.inavRenderAlertView.overturnAction = ^{
        [weakSelf.localRenderView switchCamera];
    };
    
    // 点击下麦
    self.inavRenderAlertView.unApplyAction = ^{
        if ([weakSelf.delegate respondsToSelector:@selector(unApplyAction)]) {
            [weakSelf.delegate unApplyAction];
        }
    };

}

#pragma mark - UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat wid = Screen_Width / 2 - 1;
    CGFloat hi = Screen_Width * 9 / 16 / 2 - 1;
    return CGSizeMake(wid, hi);
}
//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark - 切换旁路
- (void)errorLeaveInavDelegate
{
    if ([self.delegate respondsToSelector:@selector(errorLeaveInav)]) {
        [self.delegate errorLeaveInav];
    }
}
#pragma mark - 销毁播放器
- (void)destroyMP
{
    if (_dataSource) {
        [_dataSource removeAllObjects];
    }
    if (_localRenderView) {
        [_localRenderView removeFromSuperview];
        _localRenderView = nil;
    }
    if (_inavRoom) {
        [_inavRoom unpublish];
        [_inavRoom leaveRoom];
    }
    [self removeFromSuperview];
}

#pragma mark - 懒加载
- (NSDictionary *)inavRoomParam {
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    param[@"id"] =  self.webinarInfoData.webinar.data_id;
    param[@"name"] = [VHallApi currentUserNickName];
    param[@"auth_model"] = @(1);
    return param;
}
- (VHRoom *)inavRoom {
    if (!_inavRoom) {
        _inavRoom = [[VHRoom alloc] init];
        // 设置代理
        _inavRoom.delegate = self;
    } return _inavRoom;
}
- (VHLocalRenderView *)localRenderView
{
    if (!_localRenderView) {
        // 设置推流分辨率
        VHFrameResolutionValue resolution = VHFrameResolution480x360;
        NSDictionary *options = @{VHFrameResolutionTypeKey:@(resolution),VHStreamOptionStreamType:@(VHInteractiveStreamTypeAudioAndVideo)};
        // 初始化
        _localRenderView = [[VHLocalRenderView alloc] initCameraViewWithFrame:CGRectZero options:options];
        // 设置预览画面方向
        [_localRenderView setDeviceOrientation:UIDeviceOrientationPortrait];
        // 画面填充模式
        [_localRenderView setScalingMode:VHRenderViewScalingModeAspectFit];
    } return _localRenderView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Width * 9 / 16) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[VHInavCell class] forCellWithReuseIdentifier:@"VHInavCell"];
    }
    return _collectionView;
}
- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (VHInavRenderAlertView *)inavRenderAlertView
{
    if (!_inavRenderAlertView){
        _inavRenderAlertView = [[VHInavRenderAlertView alloc] initWithFrame:[VUITool viewControllerWithView:self].view.frame];
        [[VUITool viewControllerWithView:self].view addSubview:_inavRenderAlertView];
        [_inavRenderAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
        }];
    }return _inavRenderAlertView;
}

@end
