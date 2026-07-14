//
//  VHWatchVideoView.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/13.
//

#import "VHDefiniteionsViewModel.h"
#import "VHSliderView.h"
#import "VHWatchVideoView.h"
#import "VHDanmu.h"

@interface VHWatchVideoView ()<VHallMoviePlayerDelegate, VHWebinarInfoDelegate, UIGestureRecognizerDelegate>

/// 活动id
@property (nonatomic, copy) NSString *webinarId;
/// 渠道id
@property (nonatomic, copy, nullable) NSString *channelId;

@property (nonatomic, copy, nullable) NSString *join_nick_name;

@property (nonatomic, copy, nullable) NSString *join_email;
/// 指定回放id
@property (nonatomic, copy) NSString *recordId;
/// 活动状态
@property (nonatomic, assign) VHMovieActiveState type;
// 基础控件
/// 用户View
@property (nonatomic, strong) UIView *userView;
/// 头像
@property (nonatomic, strong) UIImageView *headImg;
/// 昵称
@property (nonatomic, strong) UILabel *nickNameLab;
/// 在线人数
@property (nonatomic, strong) UILabel *onlineLab;
/// 在线人数图片
@property (nonatomic, strong) UIImageView *onlineImg;
/// 更新上线人数
@property (nonatomic, assign) NSInteger all_update_online_num;
/// 热度
@property (nonatomic, strong) UILabel *heatLab;
/// 热度图片
@property (nonatomic, strong) UIImageView *heatImg;
/// 开始播放
@property (nonatomic, strong) UIButton *pipBtn;
/// 后台播放
@property (nonatomic, strong) UIButton *backGroundPlayBtn;
/// 底部背景
@property (nonatomic, strong) UIView *bottomView;
/// 渐变色
@property (nonatomic, strong) CAGradientLayer *bottomGradient;
/// 开始播放
@property (nonatomic, strong) UIButton *startBtn;
/// 进度条
@property (nonatomic, strong) VHSliderView *slider;
/// 时间
@property (nonatomic, strong) UILabel *beginTime;
/// 结束时间
@property (nonatomic, strong) UILabel *endTime;
/// 清晰度切换按钮
@property (nonatomic, strong) UIButton *rateBtn;
/// 清晰度切换按钮
@property (nonatomic, strong) UIButton *definitionBtn;
/// 全屏按钮
@property (nonatomic, strong) UIButton *fullBtn;
/// 弹幕
@property (nonatomic, strong) VHDanmu *danmu;

@property (nonatomic, assign) BOOL isEnablePlayBack;

@property (nonatomic, assign) BOOL isStartPlay;

// 播放器信息
/// 当前视频支持的清晰度
@property (nonatomic, strong) NSMutableArray *definiteionsDataSource;

// slider
@property (nonatomic) float value;                                 // default 0.0. this value will be pinned to min/max
@property (nonatomic) float minimumValue;                          // default 0.0. the current value may change if outside new min value
@property (nonatomic) float maximumValue;                          // default 1.0. the current value may change if outside new max value
@end

@implementation VHWatchVideoView

- (void)dealloc {
    // 移除监听电话
    [[NSNotificationCenter defaultCenter] removeObserver:AVAudioSessionInterruptionNotification];

    VHLog(@"%s释放", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String]);
}

#pragma mark - 初始化
- (instancetype)initWithWebinarId:(NSString *)webinarId  channelId:(NSString* _Nullable)channelId  nickName:(NSString* _Nullable)nickName  email:(NSString* _Nullable)email type:(VHMovieActiveState)type
{
    if ([super init]) {
        self.webinarId = webinarId;
        self.channelId = channelId;
        self.join_email = email;
        self.join_nick_name = nickName;
        self.type = type;

        // 显隐控件
        [self controlsWithIsHidden:type == VHMovieActiveStateLive ? YES : NO];

        // 添加控件
        [self addViews];

        // 初始化UI
        [self masonryUI];

        // 设置进度条监听
        [self.slider addTarget:self action:@selector(slideTouchBegin:) forControlEvents:UIControlEventTouchDown];
        [self.slider addTarget:self action:@selector(slideTouchEnd:) forControlEvents:UIControlEventTouchUpOutside];
        [self.slider addTarget:self action:@selector(slideTouchEnd:) forControlEvents:UIControlEventTouchUpInside];
        [self.slider addTarget:self action:@selector(slideTouchEnd:) forControlEvents:UIControlEventTouchCancel];
        [self.slider addTarget:self action:@selector(slideValueChanged:) forControlEvents:UIControlEventValueChanged];

        // 监听电话
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:nil];

        // 开始播放
        [self startPlay];
        
        // 绑定自动化标识
        [self initKIF];

    }

    return self;
}

#pragma mark - 添加UI
- (void)addViews
{
    [self addSubview:self.moviePlayer.moviePlayerView];
    
    [self addSubview:self.userView];
    [self.userView addSubview:self.headImg];
    [self.userView addSubview:self.nickNameLab];
    [self.userView addSubview:self.onlineLab];
    [self.userView addSubview:self.onlineImg];
    [self.userView addSubview:self.heatLab];
    [self.userView addSubview:self.heatImg];
    
    [self addSubview:self.pipBtn];
     [self addSubview:self.backGroundPlayBtn];
    [self addSubview:self.bottomView];
    [self addSubview:self.slider];

    [self.bottomView addSubview:self.startBtn];
    [self.bottomView addSubview:self.beginTime];
    [self.bottomView addSubview:self.endTime];

    [self.bottomView addSubview:self.rateBtn];
    [self.bottomView addSubview:self.definitionBtn];
    [self.bottomView addSubview:self.fullBtn];
}

#pragma mark - 初始化UI
- (void)masonryUI
{
    [self.moviePlayer.moviePlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];

    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(34);
    }];

    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(4);
        make.centerY.mas_equalTo(_userView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];

    [self.nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImg.mas_right).offset(6);
        make.top.mas_equalTo(_headImg.mas_top);
    }];

    [self.onlineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImg.mas_right).offset(6);
        make.bottom.mas_equalTo(_headImg.mas_bottom).offset(-2);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];

    [self.onlineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_onlineImg.mas_right).offset(2);
        make.bottom.mas_equalTo(_headImg.mas_bottom);
    }];

    [self.heatImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_onlineLab.mas_right).offset(4);
        make.bottom.mas_equalTo(_headImg.mas_bottom).offset(-2);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];

    [self.heatLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_heatImg.mas_right).offset(2);
        make.bottom.mas_equalTo(_headImg.mas_bottom);
    }];

    [self.userView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_greaterThanOrEqualTo(_nickNameLab.mas_right).offset(10).priorityHigh();
        make.right.mas_greaterThanOrEqualTo(_heatLab.mas_right).offset(10).priorityHigh();
    }];
    
    [self.pipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
     
     [self.backGroundPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          // 关键：backGroundPlayBtn的右边缘 等于 pipBtn的左边缘 减去10（即左边偏移10像素）
          make.right.mas_equalTo(self.pipBtn.mas_left).offset(-10);
          // 顶部与pipBtn对齐（可选，根据需求调整垂直位置）
          make.top.mas_equalTo(self.pipBtn.mas_top).offset(10);
          make.size.mas_equalTo(CGSizeMake(40, 40));
     }];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];

    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];

    [self.beginTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.startBtn.mas_centerY);
        make.left.mas_equalTo(self.startBtn.mas_right).offset(5);
        make.width.mas_equalTo(55);
    }];

    [self.endTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.startBtn.mas_centerY);
        make.left.mas_equalTo(self.startBtn.mas_right).offset(60);
    }];

    [self.fullBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.startBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];

    [self.definitionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.fullBtn.mas_left).offset(-15);
        make.centerY.mas_equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(25);
    }];

    [self.rateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.definitionBtn.mas_left).offset(-15);
        make.centerY.mas_equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(25);
    }];

    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(self.fullBtn.mas_top).offset(-10);
        make.height.mas_equalTo(2);
    }];
}

#pragma mark - 绑定自动化标识
- (void)initKIF
{
    self.startBtn.accessibilityLabel =      VHTests_Watch_StartBtn;
    self.rateBtn.accessibilityLabel =       VHTests_Watch_RateBtn;
    self.definitionBtn.accessibilityLabel = VHTests_Watch_DefinitionBtn;
    self.fullBtn.accessibilityLabel =       VHTests_Watch_FullBtn;
}

#pragma mark - 刷新布局
- (void)layoutSubviews
{
    [super layoutSubviews];

    _bottomGradient.frame = _bottomView.bounds;
}

#pragma mark - 数据赋值
- (void)updataToWebinarInfo:(VHWebinarInfo *)webinarInfo
{
    [_headImg sd_setImageWithURL:[NSURL URLWithString:webinarInfo.author_avatar] placeholderImage:[UIImage imageNamed:@"vh_no_head_icon"]];

    NSString *nickName = [VUITool isBlankString:webinarInfo.author_nickname] ? @"主持人" : webinarInfo.author_nickname;

    NSInteger const kMaxNicknameLength = 8;

    if (nickName.length > kMaxNicknameLength) {
        nickName = [NSString stringWithFormat:@"%@...", [webinarInfo.author_nickname substringToIndex:kMaxNicknameLength]];
    }

    _nickNameLab.text = [VUITool substringToIndex:kMaxNicknameLength text:nickName isReplenish:YES];

    self.all_update_online_num += webinarInfo.online_virtual;

    NSInteger olNum = [_onlineLab.text integerValue] + webinarInfo.online_real + webinarInfo.online_virtual;

    // 人数
    _onlineLab.text = olNum > 999 ? @"999+" : [NSString stringWithFormat:@"%ld", olNum];

    NSInteger heatNum = [_heatLab.text integerValue] + webinarInfo.pv_real + webinarInfo.pv_virtual;

    //  热度
    _heatLab.text = heatNum > 999 ? @"999+" : [NSString stringWithFormat:@"%ld", heatNum];

    // 显隐逻辑
    _onlineImg.hidden = !webinarInfo.online_show;
    _onlineLab.hidden = !webinarInfo.online_show;

    _heatImg.hidden = !webinarInfo.pv_show;
    _heatLab.hidden = !webinarInfo.pv_show;

    [_heatImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_headImg.mas_bottom).offset(-2);
        make.size.mas_equalTo(CGSizeMake(10, 10));

        if (webinarInfo.online_show) {
            make.left.mas_equalTo(_onlineLab.mas_right).offset(4);
        } else {
            make.left.mas_equalTo(_headImg.mas_right).offset(6);
        }
    }];
}

#pragma mark - 显隐控件 直播为true
- (void)controlsWithIsHidden:(BOOL)isHidden
{
    self.slider.hidden = isHidden;
    self.beginTime.hidden = isHidden;
    self.endTime.hidden = isHidden;
    self.rateBtn.hidden = isHidden;
}

#pragma mark - 电话监听
- (void)handleInterruption:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    AVAudioSessionInterruptionType type = [[userInfo objectForKey:AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];

    switch (type) {
        case AVAudioSessionInterruptionTypeBegan:
            // 处理中断开始事件
            // 如果当前正在播放，拔掉耳机，暂停播放
            [self pausePlay];
            break;

        case AVAudioSessionInterruptionTypeEnded: {
            AVAudioSessionInterruptionOptions options = [[userInfo objectForKey:AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];

            if (options & AVAudioSessionInterruptionOptionShouldResume) {
                // 处理中断结束事件
            }

            break;
        }

        default:
            break;
    }
}

#pragma mark - 开始播放
- (void)startPlay
{
    VHLog(@"🍌 === 点击开始播放");
    // 判断是直播还是回放

    if (self.type == VHMovieActiveStateLive) {
        [self.moviePlayer startPlay:[self playParam] isPIP:YES];
    } else if (self.type == VHMovieActiveStateReplay || self.type == VHMovieActiveStatePlayBack) {
        [self.moviePlayer startPlayback:[self playParam] isPIP:YES];
        // 播放从0开始进度条
        [self setValue:0];
    }
  

    // 开始播放弹幕
    [self.danmu start];
}

#pragma mark - 暂停播放
- (void)pausePlay
{
    [self.moviePlayer pausePlay];
    
    // 暂停播放弹幕
    [self.danmu pause];
}

#pragma mark - 停止播放
- (void)stopPlay
{
    [self.moviePlayer stopPlay];
    
    // 停止播放弹幕
    [self.danmu stop];
}

#pragma mark - 恢复
- (void)reconnectPlay
{
    if (self.moviePlayer.playerState == VHPlayerStatePause) {
        [self.moviePlayer reconnectPlay];
    } else {
        [self startPlay];
    }
}

#pragma mark - 播放指定回放视频
- (void)startPlayBackWithRecordId:(NSString *)recordId {
    self.recordId = recordId;
    if (self.type == VHMovieActiveStateReplay || self.type == VHMovieActiveStatePlayBack) {
        [self.moviePlayer startPlayback:[self playParam]];
        // 播放从0开始进度条
        [self setValue:0];
    }
}

#pragma mark - VHMoviePlayerDelegate
#pragma mark - -----------------VHallMoviePlayer 播放器状态相关--------------------
// 播放器预加载
- (void)preLoadVideoFinish:(VHallMoviePlayer *)moviePlayer activeState:(VHMovieActiveState)activeState error:(NSError *)error
{
    VHLog(@"播放器预加载：%@", error);
}

// 播放连接成功
- (void)connectSucceed:(VHallMoviePlayer *)moviePlayer info:(NSDictionary *)info
{
    // 赋值数据
    [self updataToWebinarInfo:moviePlayer.webinarInfo];

    if (self.delegate && [self.delegate respondsToSelector:@selector(connectSucceed:info:)]) {
        [self.delegate connectSucceed:moviePlayer info:info];
    }
}

// 播放器状态
- (void)moviePlayer:(VHallMoviePlayer *)player statusDidChange:(VHPlayerState)state
{
    VHLog(@"播放连接状态：%ld", state);
    
    [VHProgressHud showToast:[NSString stringWithFormat:@"播放状态：%ld",(NSInteger)state]];

    if (state == VHPlayerStatePlaying) {
        VHLog(@"🍌 === 开始播放");
        // 设置总时长
        [self setMaximumValue:player.duration];
    }

    if (state == VHPlayerStatePlaying) {
        self.startBtn.selected = NO;
    } else {
        self.startBtn.selected = YES;
    }
}

// 播放时错误的回调
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer playError:(VHSaasLivePlayErrorType)livePlayErrorType info:(NSDictionary *)info
{
    VHLog(@"播放错误：%@", info);

    if (livePlayErrorType == VHSaasPlaySSOKickout) {
        [VHProgressHud showToast:@"被踢出"];

        if ([self.delegate respondsToSelector:@selector(moviePlayer:isKickout:)]) {
            [self.delegate moviePlayer:moviePlayer isKickout:YES];
        }
    } else {
        NSString *errorStr = [NSString stringWithFormat:@"type == %ld , %@", livePlayErrorType, info[@"content"]];
        [VHProgressHud showToast:errorStr];

        if (livePlayErrorType == VHSaasLivePlayGetUrlError) {
            NSInteger code = [info[@"code"] integerValue];
            if (code == 512536) { return; }
            if ([self.delegate respondsToSelector:@selector(moviePlayer:isKickout:)]) {
                [self.delegate moviePlayer:moviePlayer isKickout:NO];
            }
        }
    }

    if (livePlayErrorType == VHSaasLivePlayCDNConnectError) {
//        // 出现这种报错后 继续重试
//        [self reconnectPlay];
    }
}

// 当前播放时间回调
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer currentTime:(NSTimeInterval)currentTime
{
    [self setValue:currentTime];
}

// 清晰度
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer loadVideoDefinitionList:(NSArray *)definitionList
{
    [self.definiteionsDataSource removeAllObjects];

    for (int i = 0; i < definitionList.count; i++) {
        VHMovieDefinition def = [definitionList[i] intValue];
        VHDefiniteionsViewModel *model = [VHDefiniteionsViewModel new];
        model.def = def;
        switch (model.def) {
            case VHMovieDefinitionOrigin:
                model.title = @"原画";
                break;

            case VHMovieDefinitionUHD:
                model.title = @"超高清";
                break;

            case VHMovieDefinitionHD:
                model.title = @"高清";
                break;

            case VHMovieDefinitionSD:
                model.title = @"标清";
                break;

            case VHMovieDefinitionAudio:
                model.title = @"纯音频";
                break;
            case VHMovieDefinition1080p:
                model.title = @"1080p";
                break;
            default:
                break;
        }

        if (def == self.moviePlayer.curDefinition) {
            model.isSelect = YES;
            [self.definitionBtn setTitle:model.title forState:UIControlStateNormal];
        } else {
            model.isSelect = NO;
        }

        [self.definiteionsDataSource addObject:model];
    }
}

/// 返回视频打点数据（若存在打点信息）
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer
      videoPointArr:(NSArray <VHVidoePointModel *> *)pointArr
{
    if ([self.delegate respondsToSelector:@selector(moviePlayer:videoPointArr:)]) {
        [self.delegate moviePlayer:moviePlayer videoPointArr:pointArr];
    }
}

// 主持人显示/隐藏文档
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer isHaveDocument:(BOOL)isHave isShowDocument:(BOOL)isShow
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(moviePlayer:isHaveDocument:isShowDocument:)]) {
        [self.delegate moviePlayer:moviePlayer isHaveDocument:isHave isShowDocument:isShow];
    }
}

// 直播文档同步，直播文档有延迟，指定需要延迟的秒数 （默认为直播缓冲时间，即：realityBufferTime/1000.0）
- (NSTimeInterval)documentDelayTime:(VHallMoviePlayer *)moviePlayer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(documentDelayTime:)]) {
        return [self.delegate documentDelayTime:moviePlayer];
    }

    return 0;
}

// 房间人数改变回调 （目前仅支持真实人数改变触发此回调）
- (void)onlineChangeRealNum:(NSUInteger)online_real virtualNum:(NSUInteger)online_virtual
{
}

#pragma mark - 发布公告的回调
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer announcementContentDidChange:(NSString *)content pushTime:(NSString *)pushTime duration:(NSInteger)duration
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(moviePlayer:announcementContentDidChange:pushTime:duration:)]) {
        [self.delegate moviePlayer:moviePlayer announcementContentDidChange:content pushTime:pushTime duration:(NSInteger)duration];
    }
}

#pragma mark - 房间相关
#pragma mark - 直播开始回调
- (void)liveDidStart:(VHallMoviePlayer *)moviePlayer
{
}

#pragma mark - 直播已结束回调
- (void)liveDidStoped:(VHallMoviePlayer *)moviePlayer
{
    [VHProgressHud showToast:@"直播已结束"];

    if ([self.delegate respondsToSelector:@selector(liveDidStoped:)]) {
        [self.delegate liveDidStoped:moviePlayer];
    }
}

#pragma mark - 被踢出
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer isKickout:(BOOL)isKickout
{
    [VHProgressHud showToast:isKickout ? @"被踢出" : @"取消踢出"];

    if ([self.delegate respondsToSelector:@selector(moviePlayer:isKickout:)]) {
        [self.delegate moviePlayer:moviePlayer isKickout:isKickout];
    }
}

#pragma mark - 互动
/// 当前活动是否允许举手申请上麦回调
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer isInteractiveActivity:(BOOL)isInteractive interactivePermission:(VHInteractiveState)state
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(moviePlayer:isInteractiveActivity:interactivePermission:)]) {
        [self.delegate moviePlayer:moviePlayer isInteractiveActivity:isInteractive interactivePermission:state];
    }
}

/// 主持人是否同意上麦申请回调
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer microInvitationWithAttributes:(NSDictionary *)attributes error:(NSError *)error
{
    [VHProgressHud showToast:@"主持同意上麦"];

    if (self.delegate && [self.delegate respondsToSelector:@selector(moviePlayer:microInvitationWithAttributes:error:)]) {
        [self.delegate moviePlayer:moviePlayer microInvitationWithAttributes:attributes error:error];
    }
}

/// 被主持人邀请上麦
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer microInvitation:(NSDictionary *)attributes
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(moviePlayer:microInvitation:)]) {
        [self.delegate moviePlayer:moviePlayer microInvitation:attributes];
    }
}

/// 是否打开问答
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer isQuestion_status:(BOOL)isQuestion_status question_name:(NSString *)questionName
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(moviePlayer:isQuestion_status:question_name:)]) {
        [self.delegate moviePlayer:moviePlayer isQuestion_status:isQuestion_status question_name:questionName];
    }
}

/// 当前是否开启文件下载功能
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer is_file_download:(BOOL)is_file_download file_download_menu:(VHallPlayMenuModel *)file_download_menu
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(moviePlayer:is_file_download:file_download_menu:)]) {
        [self.delegate moviePlayer:moviePlayer is_file_download:is_file_download file_download_menu:file_download_menu];
    }
}

#pragma mark - 画中画
/// 即将开启画中画
- (void)pictureInPictureControllerWillStart {
     [self.moviePlayer setPictureInPictureControls:YES];
}
/// 已经开启画中画
- (void)pictureInPictureControllerDidStart {

}
/// 开启画中画失败
/// - Parameter error: 错误信息
- (void)pictureInPictureWithFailedToStartPictureInPictureWithError:(NSError *)error {
    
}
/// 即将关闭画中画
- (void)pictureInPictureControllerWillStop {
    
}
/// 已经关闭画中画
- (void)pictureInPictureControllerDidStop {
    [self.moviePlayer reconnectPlay];
}

///画中画模式下点击画中画中播放&暂停按键状态变化回调
/// - Parameter  （isPlaying为YES表示播放，NO表示暂停）
- (void)pictureInPicturePlaybackStateDidChange:(BOOL)isPlaying{
     if(isPlaying){
         NSInteger currentPlaybackTime = (NSInteger)self.moviePlayer.currentPlaybackTime;
         NSInteger duration = (NSInteger)self.moviePlayer.duration;
         //如果播放完毕，则设置进度重新播放
         if(currentPlaybackTime == duration){
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self.moviePlayer setCurrentPlaybackTime:0];
                 [self.moviePlayer reconnectPlay];
             });
         }
         else{
             [self.moviePlayer reconnectPlay];
         }
     }
}

/// 关闭画中画且恢复播放界面
/// - Parameter completionHandler: 恢复是否完成
- (void)pictureInPictureWithRestoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL restored))completionHandler {
     completionHandler(YES);
}

#pragma mark - 收到虚拟人数消息
- (void)vhBaseNumUpdateToUpdate_online_num:(NSInteger)update_online_num
                                 update_pv:(NSInteger)update_pv
{
    self.all_update_online_num = self.all_update_online_num + update_online_num;

    NSInteger olNum = [_onlineLab.text integerValue] + update_online_num;

    _onlineLab.text = olNum > 999 ? @"999+" : [NSString stringWithFormat:@"%ld", olNum];

    NSInteger heatNum = [_heatLab.text integerValue] + update_pv;

    _heatLab.text = heatNum > 999 ? @"999+" : [NSString stringWithFormat:@"%ld", heatNum];
}

#pragma mark - 聊天消息
- (void)reciveChatMsg:(NSArray <VHallChatModel *> *)msgs
{
    VHallChatModel * msgModel = msgs[0];

    // 显示弹幕
    [self.danmu sendWithMsgModel:msgModel superView:self.moviePlayer.moviePlayerView];
}

#pragma mark - 收到上下线消息
- (void)reciveOnlineMsg:(NSArray <VHallOnlineStateModel *> *)msgs
{
    for (VHallOnlineStateModel *m in msgs) {
        NSInteger olNum = [m.concurrent_user integerValue] + self.all_update_online_num;

        _onlineLab.text = olNum > 999 ? @"999+" : [NSString stringWithFormat:@"%ld", olNum];

        NSInteger heatNum = [_heatLab.text integerValue] + ([m.event isEqualToString:@"online"] ? 1 : 0);

        _heatLab.text = heatNum > 999 ? @"999+" : [NSString stringWithFormat:@"%ld", heatNum];
    }
}

#pragma mark - 进度条
- (void)setValue:(float)value {
    _value = value;
    [self.slider setValue:value animated:YES];
    [self setTimeText:value];
}

- (void)setMinimumValue:(float)minimumValue {
    _minimumValue = minimumValue;
    self.slider.minimumValue = _minimumValue;
}

- (void)setMaximumValue:(float)maximumValue {
    _maximumValue = maximumValue;
    self.slider.maximumValue = _maximumValue;
    self.endTime.text = [NSString stringWithFormat:@"/ %@", [VUITool timeFormatted:_maximumValue isAuto:NO]];
}

- (void)slideTouchBegin:(UISlider *)slider
{
    [self.moviePlayer pausePlay];
}

- (void)slideTouchEnd:(UISlider *)slider
{
    [self.moviePlayer setCurrentPlaybackTime:slider.value];    
}

- (void)slideValueChanged:(UISlider *)slider
{
    
}

- (void)actionTapGesture:(UITapGestureRecognizer *)sender {
    CGPoint touchPoint = [sender locationInView:_slider];
    CGFloat value = (_slider.maximumValue - _slider.minimumValue) * (touchPoint.x / _slider.frame.size.width);

    [self.moviePlayer setCurrentPlaybackTime:value];
}

#pragma mark - 进度值
- (void)setTimeText:(float)value {
    self.beginTime.text = [NSString stringWithFormat:@"%@", [VUITool timeFormatted:_value isAuto:NO]];
}

#pragma mark - 按钮点击事件
#pragma mark - 点击播放
- (void)playButtonClick:(UIButton *)sender
{
    if (sender.selected) {
        [self reconnectPlay];
    } else {
        [self.moviePlayer pausePlay];
    }
}

#pragma mark - 切换倍速
- (void)rateBtnAction
{
    NSArray *rateAry = [NSArray arrayWithObjects:@"0.5", @"1", @"1.5", @"2", nil];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    for (int i = 0; i < rateAry.count; i++) {
        NSString *rateStr = rateAry[i];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:rateStr
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *_Nonnull action) {
            [VHProgressHud showToast:[NSString stringWithFormat:@"已切换为%@x倍速", rateStr]];
            self.moviePlayer.rate = [rateStr floatValue];
            [self.rateBtn setTitle:[NSString stringWithFormat:@"%.1fx", [rateStr floatValue]]
                          forState:UIControlStateNormal];
        }];
        [alertAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
        alertAction.accessibilityLabel = [NSString stringWithFormat:@"%@_%@",VHTests_Watch_RateBtn,rateStr];
        [alertController addAction:alertAction];
    }

    UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) { }];
    [cancelAlertAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    [alertController addAction:cancelAlertAction];
    [[VUITool viewControllerWithView:self] presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 切换清晰度
- (void)definitionBtnAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    for (int i = 0; i < self.definiteionsDataSource.count; i++) {
        VHDefiniteionsViewModel *model = self.definiteionsDataSource[i];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:model.title
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *_Nonnull action) {
            [VHProgressHud showToast:[NSString stringWithFormat:@"已切换为%@播放", model.title]];
            self.moviePlayer.curDefinition = model.def;
            [self.definitionBtn setTitle:model.title
                                forState:UIControlStateNormal];
            CGFloat width = [VUITool getWidthWithText:model.title
                                                width:0
                                               height:25
                                                 font:FONT(12)] + 10;

            if (width < 40) {
                width = 40;
            }

            [self.definitionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(width);
            }];
        }];
        [alertAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
        alertAction.accessibilityLabel = [NSString stringWithFormat:@"%@_%@",VHTests_Watch_DefinitionBtn,model.title];
        [alertController addAction:alertAction];
    }

    UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) { }];
    [cancelAlertAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    [alertController addAction:cancelAlertAction];
    [[VUITool viewControllerWithView:self] presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 切换横竖屏
- (void)fullBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;

    if (self.delegate && [self.delegate respondsToSelector:@selector(clickFullIsSelect:)]) {
        [self.delegate clickFullIsSelect:sender.selected];
    }
}

#pragma mark - 退出全屏
- (void)quitFull
{
    self.fullBtn.selected = NO;

    if ([self.delegate respondsToSelector:@selector(clickFullIsSelect:)]) {
        [self.delegate clickFullIsSelect:self.fullBtn.selected];
    }
}

#pragma mark - 点击画中画
- (void)pipButtonClick {
    if ([self.delegate respondsToSelector:@selector(clickPIP)]) {
        [self.delegate clickPIP];
    }
}

- (void)backGroundPlayButtonClick {
     self.isEnablePlayBack  = !self.isEnablePlayBack ;
     if ([self.delegate respondsToSelector:@selector(clickBackGroundPlay:)]) {
          [self.delegate clickBackGroundPlay: self.isEnablePlayBack];
    }
     if(self.isEnablePlayBack){
          [_backGroundPlayBtn setImage:[UIImage imageNamed:@"vh_background_select"] forState:UIControlStateNormal];
     }else{
          [_backGroundPlayBtn setImage:[UIImage imageNamed:@"vh_background_play"] forState:UIControlStateNormal];
     }
}

#pragma mark - 销毁播放器
- (void)destroyMP
{
    if (_moviePlayer) {
        [_moviePlayer stopPlay];
        [_moviePlayer destroyMoivePlayer];
        _moviePlayer = nil;
    }
    
    if (_danmu) {
        [_danmu stop];
    }

    [self removeFromSuperview];
}

#pragma mark - 懒加载
- (NSDictionary *)playParam
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];

    param[@"id"] =  self.webinarId;
    param[@"record_id"] = self.recordId;
    param[@"name"] = [VHallApi currentUserNickName];
    param[@"auth_model"] = @(1);
    param[@"channel_id"] = self.channelId;
    //使用昵称和邮箱进行初始化，播放时必须带有对应昵称和邮箱参数进行播放。其他情况可以不携带name和email参数
    param[@"name"] = self.join_nick_name;
    param[@"email"] = self.join_email;
    return param;
}

- (VHallMoviePlayer *)moviePlayer
{
    if (!_moviePlayer) {
        _moviePlayer = [[VHallMoviePlayer alloc] initWithDelegate:self];
        _moviePlayer.movieScalingMode = 2;
        _moviePlayer.defaultDefinition = VHMovieDefinitionOrigin;
        _moviePlayer.default_live_subtitle = YES;
//        _moviePlayer.initialPlaybackTime = 180;
        // 创建双击手势识别器
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        tapGesture.numberOfTapsRequired = 2;
        // 将手势识别器添加到视图中
        [_moviePlayer.moviePlayerView addGestureRecognizer:tapGesture];
    }

    return _moviePlayer;
}
// 双击手势处理方法
- (void)handleDoubleTap:(UITapGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        __weak __typeof(self)weakSelf = self;
        [_moviePlayer takeVideoScreenshot:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 创建一个 UIView 对象
                UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 90)];
                img.image = image;
                // 将视图添加到父视图中
                [weakSelf.moviePlayer.moviePlayerView addSubview:img];
                // 延迟 2 秒执行移除视图的操作
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [img removeFromSuperview];
                });
            });
        }];
    }
}

- (VHDanmu *)danmu
{
    if (!_danmu) {
        _danmu = [[VHDanmu alloc] init];
    }
    return _danmu;
}
- (UIView *)userView
{
    if (!_userView) {
        _userView = [UIView new];
        _userView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.3];
        _userView.layer.masksToBounds = YES;
        _userView.layer.cornerRadius = 34 / 2;
    }

    return _userView;
}

- (UIImageView *)headImg
{
    if (!_headImg) {
        _headImg = [UIImageView new];
        _headImg.layer.masksToBounds = YES;
        _headImg.layer.cornerRadius = 28 / 2;
    }

    return _headImg;
}

- (UILabel *)nickNameLab
{
    if (!_nickNameLab) {
        _nickNameLab = [UILabel new];
        _nickNameLab.font = FONT(12);
        _nickNameLab.textColor = [UIColor whiteColor];
    }

    return _nickNameLab;
}

- (UILabel *)onlineLab
{
    if (!_onlineLab) {
        _onlineLab = [UILabel new];
        _onlineLab.hidden = YES;
        _onlineLab.font = FONT(10);
        _onlineLab.text = @"1";
        _onlineLab.textColor = [UIColor colorWithHex:@"#CECED1"];
    }

    return _onlineLab;
}

- (UIImageView *)onlineImg
{
    if (!_onlineImg) {
        _onlineImg = [UIImageView new];
        _onlineImg.hidden = YES;
        _onlineImg.image = [UIImage imageNamed:@"vh_fs_online_btn"];
    }

    return _onlineImg;
}

- (UILabel *)heatLab
{
    if (!_heatLab) {
        _heatLab = [UILabel new];
        _heatLab.hidden = YES;
        _heatLab.font = FONT(10);
        _heatLab.text = @"1";
        _heatLab.textColor = [UIColor colorWithHex:@"#CECED1"];
    }

    return _heatLab;
}

- (UIImageView *)heatImg
{
    if (!_heatImg) {
        _heatImg = [UIImageView new];
        _heatImg.hidden = YES;
        _heatImg.image = [UIImage imageNamed:@"vh_fs_heat_btn"];
    }

    return _heatImg;
}

- (UIButton *)pipBtn
{
    if (!_pipBtn) {
        _pipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pipBtn setImage:[UIImage imageNamed:@"vh_pip_icon"] forState:UIControlStateNormal];
        [_pipBtn addTarget:self action:@selector(pipButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pipBtn;
}

- (UIButton *)backGroundPlayBtn
{
      
    if (!_backGroundPlayBtn) {
         self.isEnablePlayBack = NO;
         _backGroundPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backGroundPlayBtn setImage:[UIImage imageNamed:@"vh_background_play"] forState:UIControlStateNormal];
        [_backGroundPlayBtn addTarget:self action:@selector(backGroundPlayButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backGroundPlayBtn;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        // 初始化渐变色 layer
        self.bottomGradient = [CAGradientLayer layer];
        _bottomGradient.colors = @[(__bridge id)[UIColor colorWithHexString:@"#000000" alpha:0].CGColor, (__bridge id)[UIColor colorWithHexString:@"#000000" alpha:.5].CGColor];
        _bottomGradient.locations = @[@0, @1];
        _bottomGradient.startPoint = CGPointMake(0, 0);
        _bottomGradient.endPoint = CGPointMake(0, 1);
        // 默认为 kCAGradientLayerAxial
        _bottomGradient.type = kCAGradientLayerAxial;
        [_bottomView.layer addSublayer:_bottomGradient];
    }

    return _bottomView;
}

- (UIButton *)rateBtn {
    if (!_rateBtn) {
        _rateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rateBtn.titleLabel.font = FONT(12);
        _rateBtn.backgroundColor = [UIColor clearColor];
        _rateBtn.layer.masksToBounds = YES;
        _rateBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _rateBtn.layer.borderWidth = 1;
        _rateBtn.layer.cornerRadius = 25 / 2;
        [_rateBtn setTitle:@"倍速" forState:UIControlStateNormal];
        [_rateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rateBtn addTarget:self action:@selector(rateBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }

    return _rateBtn;
}

- (UIButton *)definitionBtn {
    if (!_definitionBtn) {
        _definitionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _definitionBtn.titleLabel.font = FONT(12);
        _definitionBtn.backgroundColor = [UIColor clearColor];
        _definitionBtn.layer.masksToBounds = YES;
        _definitionBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _definitionBtn.layer.borderWidth = 1;
        _definitionBtn.layer.cornerRadius = 25 / 2;
        [_definitionBtn setTitle:@"原画" forState:UIControlStateNormal];
        [_definitionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_definitionBtn addTarget:self action:@selector(definitionBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }

    return _definitionBtn;
}

- (NSMutableArray *)definiteionsDataSource
{
    if (!_definiteionsDataSource) {
        _definiteionsDataSource = [NSMutableArray array];
    }

    return _definiteionsDataSource;
}

- (UIButton *)startBtn
{
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startBtn.selected = NO;
        _startBtn.layer.masksToBounds = YES;
        _startBtn.layer.cornerRadius = 25 / 2;
        [_startBtn setImage:[UIImage imageNamed:@"vh_stop_da"] forState:UIControlStateNormal];
        [_startBtn setImage:[UIImage imageNamed:@"vh_start_da"] forState:UIControlStateSelected];
        [_startBtn addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _startBtn;
}

- (UILabel *)beginTime
{
    if (!_beginTime) {
        _beginTime = [UILabel new];
        _beginTime.font = FONT(12);
        _beginTime.textColor = [UIColor colorWithHex:@"#FFFFFF"];
        _beginTime.text = @"00:00";
    }

    return _beginTime;
}

- (UILabel *)endTime
{
    if (!_endTime) {
        _endTime = [UILabel new];
        _endTime.font = FONT(12);
        _endTime.textColor = [UIColor colorWithHex:@"#FFFFFF"];
        _endTime.text = @"/ 00:00";
    }

    return _endTime;
}

- (VHSliderView *)slider
{
    if (!_slider) {
        _slider = [[VHSliderView alloc] init];
        [_slider setThumbImage:[UIImage imageNamed:@"vh_watchplayback_jinduanniu_select"] forState:UIControlStateNormal];
        _slider.minimumTrackTintColor = VHMainColor;
        _slider.maximumTrackTintColor = [UIColor colorWithHex:@"#7F807F"];
        _slider.minimumValue = 0.0;
        _slider.continuous = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
        tapGesture.delegate = self;
        [_slider addGestureRecognizer:tapGesture];
    }

    return _slider;
}

- (UIButton *)fullBtn {
    if (!_fullBtn) {
        _fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullBtn setImage:[UIImage imageNamed:@"vh_full_open"] forState:UIControlStateNormal];
        [_fullBtn setImage:[UIImage imageNamed:@"vh_full_close"] forState:UIControlStateSelected];
        [_fullBtn addTarget:self action:@selector(fullBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _fullBtn;
}

@end
