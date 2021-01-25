//
//  WatchPlayBackViewController.m
//  VHallSDKDemo
//
//  Created by developer_k on 16/4/12.
//  Copyright © 2016年 vhall. All rights reserved.
//

#import "WatchPlayBackViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WatchLiveChatTableViewCell.h"
#import <VHLiveSDK/VHallApi.h>
#import "VHMessageToolView.h"
#import "MJRefresh.h"
#import "AnnouncementView.h"
#import "DLNAView.h"
#import "VHPlayerView.h"
#import "MBProgressHUD.h"

#define RATEARR @[@1.0,@1.25,@1.5,@2.0,@0.5,@0.67,@0.8]//倍速播放循环顺序

static AnnouncementView* announcementView = nil;
@interface WatchPlayBackViewController ()<VHallMoviePlayerDelegate,UITableViewDelegate,UITableViewDataSource,VHPlayerViewDelegate,DLNAViewDelegate,VHMessageToolBarDelegate>
{
    VHallComment*_comment;
    int  _bufferCount;


    UIButton    *_toolViewBackView;//遮罩
    
    NSArray*_videoLevePicArray;
    NSArray* _definitionList;
    
    
}
@property (nonatomic,strong) VHallMoviePlayer  *moviePlayer;//播放器
@property (weak, nonatomic) IBOutlet UILabel *bufferCountLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *docConentView;//文档容器
@property (weak, nonatomic) IBOutlet UIImageView *docAreaView;
@property (nonatomic,assign) VHMovieVideoPlayMode playModelTemp;
@property (nonatomic,strong) UILabel*textLabel;
@property (nonatomic,strong) VHPlayerView *playMaskView;
@property (nonatomic,assign) CGRect originFrame;
@property (nonatomic,strong) UIView *originView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;

@property (weak, nonatomic) IBOutlet UIButton *getHistoryCommentBtn;
@property (weak, nonatomic) IBOutlet UILabel *liveTypeLabel;

@property (nonatomic,strong) VHMessageToolView * messageToolView;  //输入框
@property (weak, nonatomic) IBOutlet UIView *historyCommentTableView;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *docBtn;
@property (weak, nonatomic) IBOutlet UIButton *detalBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIView *showView;
@property(nonatomic,strong)   DLNAView           *dlnaView;
@property (weak, nonatomic) IBOutlet UIButton *dlnaBtn;
@property (nonatomic,strong) NSMutableArray *commentsArray;//评论

@property (weak, nonatomic) IBOutlet UIButton *definitionBtn;
@property (weak, nonatomic) IBOutlet UIButton *rateBtn;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,assign) int  pageNum;
/// 投屏权限
@property (nonatomic , assign) BOOL   isCast_screen;
@end

@implementation WatchPlayBackViewController

-(UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.frame = CGRectMake(0, 10, self.docAreaView.width, 21);
        _textLabel.text = @"暂未演示文档";
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

-(VHPlayerView *)playMaskView
{
    if (!_playMaskView) {
        _playMaskView  = [[VHPlayerView alloc]init];
        _playMaskView.delegate = self;
    }
    return _playMaskView;
}
#pragma mark - Lifecycle Method
- (void)dealloc
{
    //阻止iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self.backView removeObserver:self forKeyPath:kViewFramePath];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    VHLog(@"%@ dealloc",[[self class]description]);
}

- (id)init
{
    self = LoadVCNibName;
    if (self) {
    }
    return self;
}

-(void)viewWillLayoutSubviews
{
    if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait)
        
    {
        _topConstraint.constant = 20;
        if(iPhoneX)
            _topConstraint.constant = 35;
    }
    else
    {
        _topConstraint.constant = 0;
    }
}

- (void)viewDidLayoutSubviews
{
    if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait){
        _tableView.frame = _historyCommentTableView.bounds;
    }
    _backView.frame = _backView.frame;
    _moviePlayer.moviePlayerView.frame = _backView.bounds;
    _playMaskView.frame = _moviePlayer.moviePlayerView.bounds;
    [self.backView addSubview:_moviePlayer.moviePlayerView];
    [self.backView sendSubviewToBack:_moviePlayer.moviePlayerView];

//    _moviePlayer.documentView.frame = self.docAreaView.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initViews];
    _commentsArray=[NSMutableArray array];//初始化评论数组
    
    _moviePlayer = [[VHallMoviePlayer alloc]initWithDelegate:self];
    _moviePlayer.moviePlayerView.frame = self.view.bounds;
    _moviePlayer.timeout = (int)_timeOut;
    _moviePlayer.defaultDefinition = VHMovieDefinitionSD;
    
    [self play];
    _docConentView.hidden = YES;
    
    //播放器
    _moviePlayer.moviePlayerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.backView.height);//self.view.bounds;
    
    //遮盖
    self.playMaskView.frame = _moviePlayer.moviePlayerView.bounds;
    [_moviePlayer.moviePlayerView addSubview:self.playMaskView];
    
    [self.backView addSubview:_moviePlayer.moviePlayerView];
    [self.backView sendSubviewToBack:_moviePlayer.moviePlayerView];
    
    
    if (self.playModelTemp == VHMovieVideoPlayModeTextAndVoice ) {
        self.liveTypeLabel.text = @"语音回放中";
    }else{
        self.liveTypeLabel.text = @"";
    }
    
    [self textButtonClick:nil];
    
//    //预加载视频
//    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
//    param[@"id"] =  _roomId;
//    param[@"name"] = [UIDevice currentDevice].name;
//    param[@"email"] = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    if (_kValue&&_kValue.length>0) {
//        param[@"pass"] = _kValue;
//    }
//    [_moviePlayer preLoadRoomWithParam:param];

}
#pragma mark - Private Method
- (void)initViews
{
    //阻止iOS设备锁屏
    self.view.backgroundColor=[UIColor blackColor];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self registerLiveNotification];
//    _moviePlayer = [[VHallMoviePlayer alloc]initWithDelegate:self];
//    _moviePlayer.moviePlayerView.frame = self.view.bounds;
//    _moviePlayer.timeout = (int)_timeOut;
//    _moviePlayer.defaultDefinition = VHMovieDefinitionSD;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, VH_SW, _historyCommentTableView.height)];
    _tableView.backgroundColor = MakeColorRGB(0xe2e8eb);
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tag = -1;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorColor = MakeColorRGB(0xe2e8eb);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_historyCommentTableView addSubview:_tableView];
    
    _comment = [[VHallComment alloc] initWithMoviePlayer:_moviePlayer];
    
    _videoLevePicArray=@[@"原画",@"超清",@"高清",@"标清",@"语音开启",@""];
    
    self.textLabel.center=CGPointMake(self.docAreaView.width/2, self.docAreaView.height/2);
    [self.docAreaView addSubview:self.textLabel];
    
    [self configTableViewRefresh];
}

- (void)destoryMoivePlayer
{
    [_moviePlayer destroyMoivePlayer];
}

//注册通知
- (void)registerLiveNotification
{
    [self.backView addObserver:self forKeyPath:kViewFramePath options:NSKeyValueObservingOptionNew context:nil];
    //已经进入活跃状态的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive)name:UIApplicationDidBecomeActiveNotification object:nil];
    //监听耳机的插拔
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(outputDeviceChanged:)name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
}

- (void)play
{
    if (_moviePlayer.moviePlayerView) {
        [MBProgressHUD showHUDAddedTo:_moviePlayer.moviePlayerView animated:YES];
    }
    //todo
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    param[@"id"] =  _roomId;
    param[@"name"] = [UIDevice currentDevice].name;
    param[@"email"] = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    if (_kValue&&_kValue.length) {
        param[@"pass"] = _kValue;
    }
    
    VHLog(@"开始=== %f",[[NSDate date] timeIntervalSince1970]);
    [_moviePlayer startPlayback:param];
}


#pragma mark - 关闭
- (IBAction)closeBtnClick:(id)sender
{
//    if (_moviePlayer) {     //注意释放播放器对象，否则可能出现页面卡死等现象
//        [_moviePlayer destroyMoivePlayer];
//        _moviePlayer = nil;
//    }
    
    NSLog(@"*****************OK_-3");

    [_moviePlayer pausePlay];
    
    NSLog(@"*****************OK_-2");

    [_moviePlayer destroyMoivePlayer];
    
    NSLog(@"*****************OK_4");
    
    _moviePlayer = nil;
    
    NSLog(@"*****************OK_5");

//    [self.view removeFromSuperview];
//    [self removeFromParentViewController];
    
    [self dismissViewControllerAnimated:YES completion:^{
//        [_moviePlayer destroyMoivePlayer];
    }];
}

#pragma mark - 屏幕自适应
- (IBAction)allScreenBtnClick:(UIButton*)sender
{
    NSInteger mode = self.moviePlayer.movieScalingMode+1;
    if(mode>3)
        mode = 0;
    self.moviePlayer.movieScalingMode = mode;

}
#pragma mark - 倍速播放
- (IBAction)rateBtnClick:(UIButton*)sender
{
    if(self.moviePlayer.playerState == VHPlayerStatePlaying || self.moviePlayer.playerState == VHPlayerStatePause)
    {
        sender.tag++;
        if( sender.tag >= 7)
            sender.tag = 0;
        
        [sender setTitle:[NSString stringWithFormat:@"%.2f",[RATEARR[sender.tag] floatValue]] forState:UIControlStateNormal];
        
        self.moviePlayer.rate = [RATEARR[sender.tag] floatValue];
    }
}
#pragma mark - 码率选择
- (IBAction)definitionBtnCLicked:(UIButton *)sender {
    
    if(_definitionList.count==0)
        return;
    
    int _leve = _moviePlayer.curDefinition;
    BOOL isCanPlayDefinition = NO;
    
    while (!isCanPlayDefinition) {
        _leve = _leve+1;
        if(_leve>4)
            _leve = 0;
        for (NSNumber* definition in _definitionList) {
            if(definition.intValue == _leve)
            {
                isCanPlayDefinition = YES;
                break;
            }
        }
    }
    
    if(_moviePlayer.curDefinition == _leve)
        return;
    
    [MBProgressHUD hideHUDForView:_moviePlayer.moviePlayerView animated:NO];
    [MBProgressHUD showHUDAddedTo:_moviePlayer.moviePlayerView animated:YES];
    [_moviePlayer setCurDefinition:_leve];
    [_definitionBtn setImage:BundleUIImage(_videoLevePicArray[_moviePlayer.curDefinition]) forState:UIControlStateNormal];
    _playModelTemp=_moviePlayer.playMode;
}

#pragma mark - 详情
- (IBAction)detailsButtonClick:(UIButton *)sender {
    self.docConentView.hidden = YES;
    [_commentBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_docBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_detalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self getHistoryComment];
    
}

#pragma mark - 文档
- (IBAction)textButtonClick:(UIButton *)sender {
    [_docBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_detalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.docConentView.hidden = NO;
    
}
- (IBAction)detailBtnClick:(id)sender {
//暂时无用
//    [_docBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_detalBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

#pragma mark - 历史记录
- (IBAction)historyCommentButtonClick:(id)sender
{
    [_tableView.mj_header beginRefreshing];
}

#pragma mark - 视频控制
- (void)Vh_playerButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected)
    {
        [self.moviePlayer pausePlay];
    }
    else
    {
        if (self.moviePlayer.playerState == VHPlayerStateStoped || self.moviePlayer.playerState == VHPlayerStateComplete)
        {
            [self.moviePlayer setCurrentPlaybackTime:0];
        }
        else
        {
            [self.moviePlayer reconnectPlay];
        }
    }
}

//全屏播放
- (void)Vh_fullScreenButtonAction:(UIButton *)button {
    
    [self setDeciceOrientationLanscapeRight:button.selected];
}

- (void)monitorVideoPlayback
{
    double currentTime = floor(self.moviePlayer.currentPlaybackTime);
    double totalTime = floor(self.moviePlayer.duration);
    
    if(isnan(totalTime))
        return;
    
    //设置时间
    [self setTimeLabelValues:currentTime totalTime:totalTime];
    self.playMaskView.proSlider.value = ceil(currentTime);
}

- (void)setTimeLabelValues:(double)currentTime totalTime:(double)totalTime {
    self.playMaskView.proSlider.minimumValue = 0.f;
    self.playMaskView.proSlider.maximumValue = totalTime;
    self.playMaskView.currentTimeLabel.text = [self timeFormat:currentTime];
    self.playMaskView.totalTimeLabel.text = [self timeFormat:totalTime];
}

- (NSString *)timeFormat:(NSTimeInterval)duration
{
    int minute = 0, hour = 0, secend = duration;
    minute = (secend % 3600)/60;
    hour = secend / 3600;
    secend = secend % 60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, secend];
}

//电池栏在左屏
- (void)setDeciceOrientationLanscapeRight:(BOOL)isLandscapeRight
{
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        NSNumber *num = [[NSNumber alloc] initWithInt:(isLandscapeRight?UIInterfaceOrientationLandscapeRight:UIInterfaceOrientationPortrait)];
        [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)num];
        [UIViewController attemptRotationToDeviceOrientation];
        //这行代码是关键
    }
    SEL selector=NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation =[NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val =isLandscapeRight?UIInterfaceOrientationLandscapeRight:UIInterfaceOrientationPortrait;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
    [[UIApplication sharedApplication] setStatusBarHidden:isLandscapeRight withAnimation:UIStatusBarAnimationSlide];
    
}

- (void)Vh_progressSliderTouchBegan:(UISlider *)slider {
    [self.moviePlayer pausePlay];
    [self.playMaskView cancelAutoFadeOutControlBar];
}

- (void)Vh_progressSliderValueChanged:(UISlider *)slider {
    double currentTime = floor(slider.value);
    double totalTime = floor(self.moviePlayer.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
}

- (void)Vh_progressSliderTouchEnded:(UISlider *)slider {
    [self.moviePlayer setCurrentPlaybackTime:floor(slider.value)];
//    [self.moviePlayer reconnectPlay];
    [self.playMaskView autoFadeOutControlBar];
}

#pragma mark - VHMoviePlayerDelegate
- (void)playError:(VHSaasLivePlayErrorType)livePlayErrorType info:(NSDictionary *)info;
{
    [MBProgressHUD hideHUDForView:self.moviePlayer.moviePlayerView animated:YES];
    NSString * msg = @"";
    switch (livePlayErrorType) {
        case VHSaasLivePlayGetUrlError:
        {
            msg = info[@"content"];
            [self showMsg:msg afterDelay:2];
            NSLog( @"播放失败 %@ %@",info[@"code"],info[@"content"]);
        }
            break;
        case VHSaasVodPlayError:
        {
            msg = @"播放超时,请检查网络后重试";
            [self showMsg:msg afterDelay:2];
            NSLog( @"播放失败 %@ %@",info[@"code"],info[@"content"]);
        }
            break;
        default:
            break;
    }
    
    _playMaskView.playButton.selected  = NO;
}


- (void)moviePlayer:(VHallMoviePlayer*)player isHaveDocument:(BOOL)isHave isShowDocument:(BOOL)isShow
{
    VHLog(@"isShowDocument %d",(int)isShow);

    if(isHave)
    {
        self.textLabel.center=CGPointMake(self.docAreaView.width/2, self.docAreaView.height/2);
        [self.docAreaView insertSubview:self.textLabel atIndex:0];
        
        _moviePlayer.documentView.frame = self.docAreaView.bounds;
        [self.docAreaView addSubview:_moviePlayer.documentView];
    }
    _moviePlayer.documentView.hidden = !isShow;
}

-(void)VideoPlayMode:(VHMovieVideoPlayMode)playMode isVrVideo:(BOOL)isVrVideo
{
    VHLog(@"---%ld",(long)playMode);
    self.playModelTemp = playMode;
    self.liveTypeLabel.text = @"";

    switch (playMode) {
        case VHMovieVideoPlayModeNone:
        case VHMovieVideoPlayModeMedia:

            break;
        case VHMovieVideoPlayModeTextAndVoice:
        {
            self.liveTypeLabel.text = @"语音直播中";
        }

            break;

        case VHMovieVideoPlayModeTextAndMedia:
            
            break;
        default:
            break;
    }

    [self alertWithMessage:playMode];
}

-(void)ActiveState:(VHMovieActiveState)activeState
{
    VHLog(@"activeState-%ld",(long)activeState);
}


/**
 *  该直播支持的清晰度列表
 *
 *  @param definitionList  支持的清晰度列表
 */
- (void)VideoDefinitionList:(NSArray*)definitionList
{
    VHLog(@"可用分辨率%@ 当前分辨率：%ld",definitionList,(long)_moviePlayer.curDefinition);
    _definitionList = definitionList;
    _definitionBtn.hidden = NO;
    [_definitionBtn setImage:BundleUIImage(_videoLevePicArray[_moviePlayer.curDefinition]) forState:UIControlStateNormal];
    if (_moviePlayer.curDefinition == VHMovieDefinitionAudio) {
        _playModelTemp=VHMovieVideoPlayModeVoice;
    }
}

- (void)Announcement:(NSString*)content publishTime:(NSString*)time
{
    VHLog(@"公告:%@",content);
    
    if(!announcementView)
    { //横屏时frame错误
        if (_showView.width < [UIScreen mainScreen].bounds.size.height)
        {
            announcementView = [[AnnouncementView alloc]initWithFrame:CGRectMake(0, 0, _showView.width, 35) content:content time:nil];
        }else
        {
            announcementView = [[AnnouncementView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, 35) content:content time:nil];
        }
        
    }
    announcementView.content = [content stringByAppendingString:time];
    [_showView addSubview:announcementView];
}


-(void)bufferStart:(VHallMoviePlayer *)moviePlayer info:(NSDictionary *)info
{
    NSLog(@"bufferStart");
    [MBProgressHUD hideHUDForView:_moviePlayer.moviePlayerView animated:NO];
    [MBProgressHUD showHUDAddedTo:_moviePlayer.moviePlayerView animated:YES];
}

-(void)bufferStop:(VHallMoviePlayer *)moviePlayer info:(NSDictionary *)info
{
    NSLog(@"bufferStop");
    [MBProgressHUD hideHUDForView:_moviePlayer.moviePlayerView animated:YES];
}

- (void)moviePlayer:(VHallMoviePlayer *)player statusDidChange:(VHPlayerState)state
{
    VHLog(@"播放状态 === %zd",state);
    
    switch (state) {
        case VHPlayerStateStoped:
            _playMaskView.playButton.selected  = NO;
            break;
        case VHPlayerStateStarting:
            _playMaskView.playButton.selected  = NO;
            break;
        case VHPlayerStatePlaying:
            [MBProgressHUD hideHUDForView:self.moviePlayer.moviePlayerView animated:YES];
            _playMaskView.playButton.selected  = YES;
            
            VHLog(@"播放中=== %f",[[NSDate date] timeIntervalSince1970]);

            float rate = self.moviePlayer.rate;
            int index = 0;
            if(fabs(rate - 1.0) <= 0.01)
                index = 0;
            else if(fabs(rate - 1.25) <= 0.01)
                index = 1;
            else if(fabs(rate - 1.5) <= 0.01)
                index = 2;
            else if(fabs(rate - 2.0) <= 0.01)
                index = 3;
            else if(fabs(rate - 0.5) <= 0.01)
                index = 4;
            else if(fabs(rate - 0.67) <= 0.01)
                index = 5;
            else if(fabs(rate - 0.8) <= 0.01)
                index = 6;
                
            [_rateBtn setTitle:[NSString stringWithFormat:@"%.2f",[RATEARR[index] floatValue]] forState:UIControlStateNormal];
            
            break;
        case VHPlayerStatePause:
            _playMaskView.playButton.selected  = NO;
            break;
        case VHPlayerStateStreamStoped:
            _playMaskView.playButton.selected  = NO;
            break;
//        case VHPlayerStateComplete:/// 回放播放完成
//            _playMaskView.playButton.selected  = NO;
        default:
            break;
    }
}

- (void)moviePlayer:(VHallMoviePlayer*)player currentTime:(NSTimeInterval)currentTime
{
    [self monitorVideoPlayback];
}
- (void)moviePlayer:(VHallMoviePlayer *)player isCast_screen:(BOOL)isCast_screen
{
    self.isCast_screen = isCast_screen;
}

#pragma mark - ObserveValueForKeyPath
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:kViewFramePath])
    {
//        CGRect frame = [[change objectForKey:NSKeyValueChangeNewKey]CGRectValue];
        _moviePlayer.moviePlayerView.frame = self.backView.bounds;
        //[self.backView addSubview:self.hlsMoviePlayer.view];
        [self.backView sendSubviewToBack:self.moviePlayer.moviePlayerView];
        
        //更新键盘工具view的frame
        _toolViewBackView.frame = CGRectMake(0, 0, VHScreenWidth, VHScreenHeight);
        [_messageToolView updateFrame];
        if(_messageToolView.activityButtomView) {
            [_toolViewBackView removeFromSuperview];
        }
    }
}

-(void)moviePlayeExitFullScreen:(NSNotification*)note
{
    if(announcementView && !announcementView.hidden)
    {
        announcementView.content = announcementView.content;
    }
}

- (void)didBecomeActive
{
    if(announcementView && !announcementView.hidden)
    {
        announcementView.content = announcementView.content;
    }
}

- (void)outputDeviceChanged:(NSNotification*)notification
{
    NSInteger routeChangeReason = [[[notification userInfo]objectForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason)
    {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
        {
            VHLog(@"AVAudioSessionRouteChangeReasonNewDeviceAvailable");
            VHLog(@"Headphone/Line plugged in");
        }
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            VHLog(@"AVAudioSessionRouteChangeReasonOldDeviceUnavailable");
            VHLog(@"Headphone/Line was pulled. Stopping player....");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.moviePlayer reconnectPlay];
            });
        }
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
        {
            // called at start - also when other audio wants to play
            VHLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
        }
            break;
        default:
            break;
    }
}


#pragma mark - 拉取前20条评论

-(void)getHistoryComment
{
    [_commentsArray removeAllObjects];
    [self historyCommentButtonClick:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_commentTextField resignFirstResponder];
    return YES;
}
- (IBAction)sendCommentBtnClick:(id)sender
{
    _toolViewBackView=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, VH_SW, VH_SH)];
    [_toolViewBackView addTarget:self action:@selector(toolViewBackViewClick) forControlEvents:UIControlEventTouchUpInside];
    _messageToolView=[[VHMessageToolView alloc] initWithFrame:CGRectMake(0, _toolViewBackView.height-[VHMessageToolView  defaultHeight], VHScreenWidth, [VHMessageToolView defaultHeight])];
    _messageToolView.delegate = self;
    _messageToolView.maxLength = 140;
    [_toolViewBackView addSubview:_messageToolView];
    [self.view addSubview:_toolViewBackView];
    [_messageToolView beginTextViewInView];
}

#pragma mark - 点击聊天输入框蒙版
-(void)toolViewBackViewClick
{
    [_messageToolView endEditing:YES];
    [_toolViewBackView removeFromSuperview];
}
#pragma mark - messageToolViewDelegate
- (void)didSendText:(NSString *)text
{
    if ([text isEqualToString:@""]) {
        [self showMsgInWindow:@"发送的消息不能为空" afterDelay:2];
        return;
    }
    __weak typeof(self) weakSelf=self;
    if(text.length>0)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [_comment sendComment:text success:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            _commentTextField.text = @"";
            [weakSelf showMsg:@"发表成功" afterDelay:1];
            [weakSelf getHistoryComment];
            
        } failed:^(NSDictionary *failedData) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString* code = [NSString stringWithFormat:@"%@ %@", failedData[@"code"],failedData[@"content"]];
            [weakSelf showMsg:code afterDelay:2];
        }];
    }
}

#pragma mark - alertView
-(void)alertWithMessage:(VHMovieVideoPlayMode)state
{
    NSString*message = nil;
    switch (state) {
        case VHMovieVideoPlayModeNone:
            message = @"无内容";
            break;
        case VHMovieVideoPlayModeMedia:
            message = @"纯视频";
            break;
        case VHMovieVideoPlayModeTextAndVoice:
            message = @"文档＋声音";
            break;
        case VHMovieVideoPlayModeTextAndMedia:
            message = @"文档＋视频";
            break;

        default:
            break;
    }
    [self showMsg:message afterDelay:1];
}

#pragma mark  - tableView Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =nil;
    if (_commentsArray.count !=0)
    {
        id model = [_commentsArray objectAtIndex:indexPath.row];
        static NSString * indetify = @"WatchLiveChatCell";
        cell = [tableView dequeueReusableCellWithIdentifier:indetify];
        if (!cell) {
            cell = [[WatchLiveChatTableViewCell alloc]init];
        }
        ((WatchLiveChatTableViewCell *)cell).model = model;
    }
    else
    {
        static  NSString *indetify = @"identifyCell";
        cell = [tableView dequeueReusableCellWithIdentifier:indetify];
        if (!cell) {
            cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetify];
        }
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return _commentsArray.count ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - TableViewRefresh
- (void)configTableViewRefresh {
    __weak typeof(self)weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        [weakSelf loadData:1];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadData:weakSelf.pageNum + 1];
    }];
}

- (void)loadData:(NSInteger)page
{
    if(page==1)
        [_commentsArray removeAllObjects];
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_comment getHistoryCommentPageCountLimit:20 offSet:_commentsArray.count success:^(NSArray *msgs) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        if (msgs.count > 0)
        {
            weakSelf.pageNum++;
            
            [weakSelf.commentsArray addObjectsFromArray:msgs];
            [weakSelf.tableView reloadData];
            
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            if (msgs == nil || weakSelf.commentsArray.count <= 5){
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
    } failed:^(NSDictionary *failedData) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        NSString* code = [NSString stringWithFormat:@"%@,%@",failedData[@"content"], failedData[@"code"]];
        NSLog(@"%@",code);
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if( [failedData[@"code"] intValue] == 10407)
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}

-(DLNAView *)dlnaView
{
    if (!_dlnaView) {
        _dlnaView = [[DLNAView alloc] initWithFrame:self.view.bounds];
        _dlnaView.type = 1;
        _dlnaView.delegate = self;
    }
    return _dlnaView;
}

- (IBAction)dlnaClick:(id)sender {

    if (!self.isCast_screen) {
        [self showMsg:@"无投屏权限，如需使用请咨询您的销售人员或拨打客服电话：400-888-9970" afterDelay:1];
        return;
    }
    if(![self.dlnaView showInView:self.view moviePlayer:_moviePlayer])
    {
        [self showMsg:@"投屏失败，投屏前请确保当前视频正在播放" afterDelay:1];
        return;
    }

    [_moviePlayer pausePlay];
    
    __weak typeof(self)wf = self;
    self.dlnaView.closeBlock = ^{
        [wf.moviePlayer reconnectPlay];
    };
}
#pragma mark - 如果投屏功能出错回调走这里
- (void)dlnaControlState:(DLNAControlStateType)type errormsg:(NSString *)msg
{
    [self showMsg:msg afterDelay:1];
}
#pragma mark - 旋转
-(BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
@end
