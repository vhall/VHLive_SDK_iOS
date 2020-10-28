//
//  WatchRTMPViewController.m
//  VHallSDKDemo
//
//  Created by developer_k on 16/4/13.
//  Copyright © 2016年 vhall. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "WatchLiveViewController.h"
#import "WatchLiveOnlineTableViewCell.h"
#import "WatchLiveChatTableViewCell.h"
#import "WatchLiveQATableViewCell.h"
#import "WatchLiveSurveyTableViewCell.h"
#import "WatchLiveLotteryViewController.h"
#import "VHMessageToolView.h"
#import <VHLiveSDK/VHallApi.h>
#import "MBProgressHUD.h"
#import "AnnouncementView.h"
#import "SignView.h"
#import "BarrageRenderer.h"
#import "SZQuestionItem.h"
#import "VHQuestionCheckBox.h"
#import "Reachability.h"
#import "DLNAView.h"
#import "MicCountDownView.h"
#import "VHinteractiveViewController.h"
#import "VHInvitationAlert.h"
#import "VHSurveyViewController.h"
#import "LaunchLiveViewController.h"
#import "UIAlertController+ITTAdditionsUIModel.h"
#import "MJRefresh.h"

# define DebugLog(fmt, ...) NSLog((@"\n[文件名:%s]\n""[函数名:%s]\n""[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);

static AnnouncementView* announcementView = nil;
@interface WatchLiveViewController ()<VHallMoviePlayerDelegate, VHallChatDelegate, VHallQADelegate, VHallLotteryDelegate,VHallSignDelegate,VHallSurveyDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,VHMessageToolBarDelegate,MicCountDownViewDelegate,VHInvitationAlertDelegate,VHSurveyViewControllerDelegate,DLNAViewDelegate>
{
    __weak IBOutlet UIView *_showView;

    VHallChat         *_chat;       //聊天
    VHallQAndA        *_QA;         //问答
    VHallLottery      *_lottery;    //抽奖
    VHallSign         *_sign;       //签到
    VHallSurvey       *_survey;      //问卷
    BarrageRenderer   *_renderer;   //弹幕
    
    UIImageView       *_logView;    //当播放音频时显示的图片
    WatchLiveLotteryViewController *_lotteryVC; //抽奖VC
//    BOOL _isStart;
    BOOL _isMute;
    BOOL _isAllScreen;
    BOOL _isReciveHistory;
    int  _bufferCount;
    BOOL _fullScreentBtnClick;
    BOOL _isVr;
    BOOL _isRender;//
    BOOL _isQuestion_status;
    BOOL _docShow;  //文档是否显示
    
    NSMutableArray    *_QADataArray;
    NSArray           *_videoLevePicArray;//视频质量等级图片
    NSMutableArray    *_videoPlayModel;//播放模式
//    NSMutableArray    *_videoPlayModelPicArray;//单视频纯音频切换
     UIButton          *_toolViewBackView;//遮罩
     NSMutableDictionary *announcementContentDic;//公告内容
    
    NSArray* _definitionList;
    NSInteger _chatListPage; //聊天记录页码，默认1
}

@property (weak, nonatomic) IBOutlet UILabel *bufferCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *muteBtn;
@property (weak, nonatomic) IBOutlet UIButton *allScreenBtn;
@property (weak, nonatomic) IBOutlet UILabel *bitRateLabel;
@property (weak, nonatomic) IBOutlet UIButton *startAndStopBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *docConentView;//文档tab容器
@property (weak, nonatomic) IBOutlet UIImageView *docAreaView;//文档显示区域
@property (weak, nonatomic) IBOutlet UILabel *liveTypeLabel;
@property(nonatomic,assign) BOOL     connectedNetWork;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIButton *docBtn;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIButton *QABtn;
@property (nonatomic, strong) UIButton *cueSelectedButton;


@property (weak, nonatomic) IBOutlet UITableView *chatView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic,assign) VHMovieVideoPlayMode playModelTemp;
@property (nonatomic,strong) UILabel*textLabel;
@property(nonatomic,strong)  Reachability     *reachAbility;
@property (weak, nonatomic) IBOutlet UIButton *definitionBtn0;
@property (weak, nonatomic) IBOutlet UIButton *definitionBtn1;
@property (weak, nonatomic) IBOutlet UIButton *definitionBtn2;
@property (weak, nonatomic) IBOutlet UIButton *definitionBtn3;
@property (weak, nonatomic) IBOutlet UIButton *playModeBtn0;
@property (weak, nonatomic) IBOutlet UIButton *playModeBtn1;
@property (weak, nonatomic) IBOutlet UIButton *playModeBtn2;
@property (weak, nonatomic) IBOutlet UIButton *playModeBtn3;
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (nonatomic,strong) VHMessageToolView * messageToolView;  //输入框
@property (weak, nonatomic) IBOutlet UIButton *GyroBtn;//陀螺仪开关

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIButton *fullscreenBtn;
@property (weak, nonatomic) IBOutlet UIButton *rendererOpenBtn;
@property (nonatomic, strong) NSArray *surveyResultArray;//问卷结果

@property (nonatomic, strong)NSMutableArray    *chatDataArray;
@property (weak, nonatomic) IBOutlet UIButton *dlnaBtn;
@property(nonatomic,strong)   DLNAView           *dlnaView;


@property (nonatomic, strong) VHallMoviePlayer  *moviePlayer;//播放器

@property (nonatomic, strong) MicCountDownView *countDowwnView;
@property (nonatomic, strong) VHInvitationAlert *invitationAlertView;

//v4.0.0 新版问卷功能类
@property (nonatomic, strong) VHSurveyViewController *surveyController;
/// 投屏权限
@property (nonatomic , assign) BOOL   isCast_screen;
;
@end

@implementation WatchLiveViewController

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


#pragma mark - Private Method

-(void)addPanGestureRecognizer
{
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    panGesture.maximumNumberOfTouches = 1;
    panGesture.minimumNumberOfTouches = 1;
    [_moviePlayer.moviePlayerView addGestureRecognizer:panGesture];
}

-(void)initDatas
{
//    _isStart = YES;
    _isMute = NO;
    _isAllScreen = NO;
    _chatDataArray = [NSMutableArray arrayWithCapacity:0];
    _QADataArray = [NSMutableArray arrayWithCapacity:0];
}

- (void)initViews
{
    //阻止iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self registerLiveNotification];

    _moviePlayer = [[VHallMoviePlayer alloc]initWithDelegate:self];
    self.view.clipsToBounds = YES;
    _moviePlayer.movieScalingMode = VHRTMPMovieScalingModeAspectFit;
    _moviePlayer.defaultDefinition = VHMovieDefinitionHD;
    _moviePlayer.bufferTime = (int)_bufferTimes;
//    _moviePlayer.reConnectTimes = 2;
//    [_moviePlayer setRenderViewModel:VHRenderModelDewarpVR];
//   _moviePlayer.defaultDefinition = VHMovieDefinitionHD;

    // chat & QA 在播放之前初始化并设置代理
    _chat = [[VHallChat alloc] initWithMoviePlayer:_moviePlayer];
    _chat.delegate = self;
    _QA = [[VHallQAndA alloc] initWithMoviePlayer:_moviePlayer];
    _QA.delegate = self;
    _lottery = [[VHallLottery alloc] initWithMoviePlayer:_moviePlayer];
    _lottery.delegate = self;
    _sign = [[VHallSign alloc] initWithMoviePlayer:_moviePlayer];
    _sign.delegate = self;
    _survey=[[VHallSurvey alloc] initWithMoviePlayer:_moviePlayer];
    _survey.delegate= self;
    
    _logView = [[UIImageView alloc] initWithImage:BundleUIImage(@"vhallLogo")];
    _logView.backgroundColor = [UIColor whiteColor];
    _logView.contentMode = UIViewContentModeCenter;
    
    self.view.backgroundColor=[UIColor blackColor];
    _moviePlayer.moviePlayerView.frame = self.backView.bounds;
    [self.backView addSubview:_moviePlayer.moviePlayerView];
    [self.backView sendSubviewToBack:_moviePlayer.moviePlayerView];
    [_moviePlayer.moviePlayerView addSubview:_logView];    
    [self.view bringSubviewToFront:self.backView];
    
    _docConentView.hidden = YES;
    _logView.hidden = YES;
    _videoLevePicArray=@[@"原画",@"超清",@"高清",@"标清",@""];
//    _videoPlayModelPicArray=@[@"单视频",@"单音频"];
    _videoPlayModel=[NSMutableArray array];

    //聊天记录上拉刷新，下拉加载更多 (数据更新存在不及时，刚发的消息，需要等几秒才能刷新出来)
//    [self configChatListRefresh];
    if ([self.chatView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.chatView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self initBarrageRenderer];
    
    //申请上麦视图
    _countDowwnView = [[MicCountDownView alloc] initWithFrame:CGRectMake(VHScreenWidth-48, VHScreenHeight-200, 40, 40)];
    [_countDowwnView.button addTarget:self action:@selector(micUpClick:) forControlEvents:UIControlEventTouchUpInside];
    _countDowwnView.delegate = self;
    [self.view addSubview:_countDowwnView];
    
    
    //监听网络变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChange:) name:kReachabilityChangedNotification object:nil];
    _reachAbility = [Reachability reachabilityForInternetConnection];
    [_reachAbility startNotifier];

    self.textLabel.center=CGPointMake(self.docAreaView.width/2, self.docAreaView.height/2);
    [self.docAreaView insertSubview:self.textLabel atIndex:0];
    self.docAreaView.userInteractionEnabled = YES;
}
#pragma mark - 放大手势
- (void)changeImageSize:(UIPinchGestureRecognizer *)pinch
{
    //获取比例
    CGFloat scale=pinch.scale;
    //通过仿射变换实现缩放
      _moviePlayer.documentView.transform=CGAffineTransformScale(_moviePlayer.documentView.transform, scale, scale);
    //防止比例叠加
      pinch.scale=1;
}
-(void)panAction:(UIPanGestureRecognizer *) pan
{
    //获取移动的大小
    CGPoint point=[pan translationInView:pan.view];
    //更改视图的中心点坐标
    CGPoint points=_moviePlayer.documentView.center;
    points.x+=point.x;
    points.y+=point.y;
    _moviePlayer.documentView.center=points;
    //每次都清空一下，消除坐标叠加
    [pan setTranslation:CGPointZero inView:pan.view];
}

- (void)configChatListRefresh {
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadHistoryChatWithPage:_chatListPage + 1 completion:nil];
    }];
    [header setTitle:@"下拉加载更多" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即加载更多" forState:MJRefreshStatePulling];
    [header setTitle:@"暂无更多" forState:MJRefreshStateNoMoreData];
    [header setTitle:@"正在加载更多的数据中..." forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.chatView.mj_header = header;

    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadHistoryChatWithPage:1 completion:nil];
    }];
    [footer setTitle:@"上拉刷新" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在刷新数据中..." forState:MJRefreshStateRefreshing];
    self.chatView.mj_footer = footer;
}
- (void)initBarrageRenderer
{
    _renderer = [[BarrageRenderer alloc]init];
    [_moviePlayer.moviePlayerView addSubview:_renderer.view];
    _renderer.canvasMargin = UIEdgeInsetsMake(20, 10,30, 10);
    // 若想为弹幕增加点击功能, 请添加此句话, 并在Descriptor中注入行为
//    _renderer.view.userInteractionEnabled = YES;
    [_moviePlayer.moviePlayerView sendSubviewToBack:_renderer.view];
}


- (void)destoryMoivePlayer
{
    [_moviePlayer destroyMoivePlayer];
//    [_moviePlayer.moviePlayerView removeFromSuperview];
//    _moviePlayer = nil;
}

- (void)startPlayer {

    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    param[@"id"] =  _roomId;
    param[@"name"] = [UIDevice currentDevice].name;
    param[@"email"] = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    if (_kValue&&_kValue.length>0) {
        param[@"pass"] = _kValue;
    }
    [_moviePlayer startPlay:param];
}

//调查问卷页面
-(void)showSurveyVCWithSruveyModel:(VHallSurvey*)survey
{
//    __weak typeof(self) weakSelf =self;
    NSMutableArray *titleArray=[[NSMutableArray alloc] init];
    NSMutableArray *optionArray=[[NSMutableArray alloc] init];
    NSMutableArray *typeArry  =[[NSMutableArray alloc] init];
    NSMutableArray *isMustSelectArray = [[NSMutableArray alloc] init];

    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"_orderNum" ascending:NO];
    survey.questionArray =[survey.questionArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];

    for (VHallSurveyQuestion *question in survey.questionArray)
    {
        // 选项类型 （0问答 1单选 2多选）
        if (question.type == 0)
        {
            [typeArry addObject:@(3)];
        }else if (question.type ==1)
        {
            [typeArry addObject:@(1)];
        }else if (question.type ==2)
        {
            [typeArry addObject:@(2)];
        }
        else
            continue;

        [titleArray addObject:question.questionTitle];

        if (question.quesionSelectArray !=nil)
        {
            [optionArray addObject:question.quesionSelectArray];
        }else
        {
            [optionArray addObject:@[]];
        }

        if (question.isMustSelect)
        {
            [isMustSelectArray addObject:@"1"];
        }else
        {
            [isMustSelectArray addObject:@"0"];
        }
    }
//    NSArray *resultArray =[[NSMutableArray alloc] init];
    SZQuestionItem *item = [[SZQuestionItem alloc] initWithTitleArray:titleArray andOptionArray:optionArray andResultArray:self.surveyResultArray andQuestonTypes:typeArry isMustSelectArray:isMustSelectArray];
   VHQuestionCheckBox *questionBox=[[VHQuestionCheckBox alloc] initWithItem:item];
    questionBox.survey = survey;
    [self presentViewController:questionBox animated:YES completion:^{

     }];
}

#pragma mark - 注册通知
- (void)registerLiveNotification
{
    [self.view addObserver:self forKeyPath:kViewFramePath options:NSKeyValueObservingOptionNew context:nil];
    //已经进入活跃状态的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive)name:UIApplicationDidBecomeActiveNotification object:nil];
    //监听耳机的插拔
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(outputDeviceChanged:)name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
    
}


#pragma mark - UIButton Event
//申请上麦按钮事件
- (void)micUpClick:(UIButton *)sender {
    
    if(_chat.isAllSpeakBlocked)
    {
        [self showMsgInWindow:@"已开启全体禁言" afterDelay:1];
        return;
    }

    if(_chat.isSpeakBlocked)
    {
        [self showMsgInWindow:@"您已被禁言" afterDelay:1];
        return;
    }

    sender.selected = !sender.selected;
    
    __weak typeof(self) wf = self;
    if (sender.selected) {
        
        //申请上麦
        [_moviePlayer microApplyWithType:1 finish:^(NSError *error) {
            if(error)
            {
                NSString *msg = [NSString stringWithFormat:@"申请上麦失败：%@",error.description];
                [wf showMsgInWindow:msg afterDelay:2];
            }
            else
            {
                [wf showMsgInWindow:@"申请上麦成功" afterDelay:2];
                //开启上麦倒计时
                [wf.countDowwnView countdDown:30];
            }
        }];
    }
    else {
        //取消上麦申请
        [_moviePlayer microApplyWithType:0 finish:^(NSError *error) {
            if(error)
            {
                NSString *msg = [NSString stringWithFormat:@"取消上麦失败：%@",error.description];
                [wf showMsgInWindow:msg afterDelay:2];
            }
            else
            {
                [wf showMsgInWindow:@"已取消申请" afterDelay:2];
                //停止倒计时
                [wf.countDowwnView stopCountDown];

            }
        }];
    }
}

- (IBAction)stopWatchBtnClick:(id)sender
{
    _definitionBtn0.hidden = YES;
    if (_moviePlayer.playerState == VHPlayerStatePlaying)//暂停
    {
        [MBProgressHUD hideHUDForView:_moviePlayer.moviePlayerView animated:NO];
        _bitRateLabel.text = @"";
        _bufferCount = 0;
        _bufferCountLabel.text = [NSString stringWithFormat:@"卡顿：%d",_bufferCount];
        _startAndStopBtn.selected = NO;
        [_moviePlayer pausePlay];
        
        if (self.playModelTemp == VHMovieVideoPlayModeTextAndVoice || self.playModelTemp == VHMovieVideoPlayModeVoice) {
            self.liveTypeLabel.text = @"已暂停语音直播";
        }else{
            self.liveTypeLabel.text = @"";
        }
    }
    else if (_moviePlayer.playerState == VHPlayerStatePause)
    {
        [_moviePlayer reconnectPlay];
    }
    else if (_moviePlayer.playerState == VHPlayerStateStoped)
    {
        [self startPlayer];
    }
    
//    if (_moviePlayer.playerState == VHPlayerStateStoped || _moviePlayer.playerState == VHPlayerStateStreamStoped)
//    {
//        [MBProgressHUD hideHUDForView:_moviePlayer.moviePlayerView animated:NO];
//         [MBProgressHUD showHUDAddedTo:_moviePlayer.moviePlayerView animated:YES];
//        _bufferCount = 0;
//        _bufferCountLabel.text = [NSString stringWithFormat:@"卡顿：%d",_bufferCount];
//        if(_moviePlayer.playerState == VHPlayerStateStreamStoped)
//        {
//            [_moviePlayer reconnectPlay];
//            if (self.playModelTemp == VHMovieVideoPlayModeTextAndVoice || self.playModelTemp == VHMovieVideoPlayModeVoice) {
//                self.liveTypeLabel.text = @"语音直播中";
//            }else{
//                _definitionBtn0.hidden = NO;
//                self.liveTypeLabel.text = @"";
//            }
//            return;
//        }
//        else
//        {
////            NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
////            param[@"id"] =  _roomId;
////            param[@"name"] = [UIDevice currentDevice].name;
////            param[@"email"] = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
////            if (_kValue&&_kValue.length>0) {
////                param[@"pass"] = _kValue;
////            }
////            [_moviePlayer startPlay:param];
//            [self startPlayer];
//        }
//    }
}


#pragma mark 点击聊天输入框蒙版
-(void)toolViewBackViewClick
{
    [_messageToolView endEditing:YES];
    [_toolViewBackView removeFromSuperview];
}

#pragma mark - 返回上层界面按钮
- (IBAction)closeBtnClick:(id)sender
{
    __weak typeof(self) weakSelf = self;
     [_renderer stop];
    [_moviePlayer stopPlay];
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf destoryMoivePlayer];
    }];
}

#pragma mark - 静音
- (IBAction)muteBtnClick:(UIButton *)sender
{
    _isMute = !_isMute;
    [_moviePlayer setMute:_isMute];
    sender.selected = _isMute;
    [VHallMoviePlayer audioOutput:YES];
}

#pragma mark - RTMP屏幕自适应
- (IBAction)allScreenBtnClick:(id)sender
{
    _isAllScreen = !_isAllScreen;
    if (_isAllScreen) {
        _moviePlayer.movieScalingMode = VHRTMPMovieScalingModeAspectFill;

    }else{
        _moviePlayer.movieScalingMode = VHRTMPMovieScalingModeAspectFit;
    }
}
#pragma mark 发送聊天按钮
- (IBAction)sendChatBtnClick:(id)sender
{
    if(_chat.isAllSpeakBlocked)
    {
        [self showMsgInWindow:@"已开启全体禁言" afterDelay:1];
        return;
    }

    if(_chat.isSpeakBlocked)
    {
        [self showMsgInWindow:@"您已被禁言" afterDelay:1];
        return;
    }
    
    _toolViewBackView=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, VH_SW, VH_SH)];
    _toolViewBackView.backgroundColor=[UIColor clearColor];
    [_toolViewBackView addTarget:self action:@selector(toolViewBackViewClick) forControlEvents:UIControlEventTouchUpInside];
    _messageToolView=[[VHMessageToolView alloc] initWithFrame:CGRectMake(0, _toolViewBackView.height-[VHMessageToolView  defaultHeight], VHScreenWidth, [VHMessageToolView defaultHeight]) type:3];
    _messageToolView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    _messageToolView.delegate=self;
    _messageToolView.hidden=NO;
    _messageToolView.maxLength=140;
    [_toolViewBackView addSubview:_messageToolView];
    [self.view addSubview:_toolViewBackView];
    [_messageToolView beginTextViewInView];
}

#pragma mark - Lifecycle Method
- (id)init
{
    self = LoadVCNibName;
    if (self) {
        [self initDatas];
    }
    return self;
}

-(BOOL)shouldAutorotate
{
    if (_fullScreentBtnClick) {
        return YES;
    }else if (_isVr)
    {
        return NO;
    }
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (_fullScreentBtnClick) {
        return YES;
    }else if (_isVr)
    {
        return NO;
    }
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

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initViews];
//    [self startPlayer];
    //预加载视频
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    param[@"id"] =  _roomId;
    param[@"name"] = [UIDevice currentDevice].name;
    param[@"email"] = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    if (_kValue&&_kValue.length>0) {
        param[@"pass"] = _kValue;
    }
    [_moviePlayer preLoadRoomWithParam:param];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self startPlayer];
    [_moviePlayer reconnectPlay];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_moviePlayer pausePlay];

    [_countDowwnView stopCountDown];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(announcementView && !announcementView.hidden)
    {
        announcementView.content = announcementView.content;
    }
    //开启扬声器播放
    [VHallMoviePlayer audioOutput:YES];
}

-(void)viewWillLayoutSubviews
{
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait)
        
    {
        _topConstraint.constant = 20;
        if(iPhoneX)
            _topConstraint.constant = 35;
        _fullscreenBtn.selected = NO;
    }
    else
    {
        _topConstraint.constant = 0;
        _fullscreenBtn.selected = YES;
    }
    
    if (_isVr && _GyroBtn.selected) {
        [_moviePlayer setUILayoutOrientation:[[UIDevice currentDevice]orientation]];
    }
    
    _fullScreentBtnClick=NO;
}

- (void)viewDidLayoutSubviews
{
    _moviePlayer.moviePlayerView.frame = self.backView.bounds;
    
//    if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait)
//        _moviePlayer.documentView.frame= self.docAreaView.bounds;
    _logView.frame = _moviePlayer.moviePlayerView.bounds;
    _lotteryVC.view.frame = _showView.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self destoryMoivePlayer];
    
    if (_chat) {
        _chat = nil;
    }
    
    if (_QA) {
        _QA = nil;
    }
    
    if (_lottery) {
        _lottery = nil;
    }
    
    if (_lotteryVC) {
        [_lotteryVC.view removeFromSuperview];
        [_lotteryVC removeFromParentViewController];
        [_lotteryVC destory];
        _lotteryVC = nil;
    }
    
    if (_sign) {
        _sign.delegate = nil;
    }
    if (_survey) {
        _survey.delegate = nil;
    }
    //阻止iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self.view removeObserver:self forKeyPath:kViewFramePath];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    VHLog(@"%@ dealloc",[[self class]description]);
}

#pragma mark - Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
  __weak  typeof(self) weakSelf =self;
//  __weak  typeof(VHallSurvey) *weakSurvey = _survey;
    if (_chatBtn.selected)
    {
        id model = [_chatDataArray objectAtIndex:indexPath.row];
        if ([model isKindOfClass:[VHallOnlineStateModel class]])
        {
            static NSString * indetify = @"WatchLiveOnlineCell";
            cell = [tableView dequeueReusableCellWithIdentifier:indetify];
            if (!cell) {
                cell = [[WatchLiveOnlineTableViewCell alloc]init];
            }
            ((WatchLiveOnlineTableViewCell *)cell).model = model;
        } else if([model isKindOfClass:[VHallSurveyModel class]])
        {
            static NSString * indetify = @"WatchLiveSurveyTableViewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:indetify];
            if (!cell) {
                cell = [[WatchLiveSurveyTableViewCell alloc]init];
            }
            ((WatchLiveSurveyTableViewCell *)cell).model = model;
              ((WatchLiveSurveyTableViewCell *)cell).clickSurveyItem=^(VHallSurveyModel *model)
            {
                [weakSelf performSelector:@selector(clickSurvey:) withObject:model];
            };
        }
        else
        {
            static NSString * indetify = @"WatchLiveChatCell";
            cell = [tableView dequeueReusableCellWithIdentifier:indetify];
            if (!cell) {
                cell = [[WatchLiveChatTableViewCell alloc]init];
            }
            ((WatchLiveChatTableViewCell *)cell).model = model;
        }
    }
    else if (_QABtn.selected)
    {
        static NSString * qaIndetify = @"WatchLiveQACell";
        cell = [tableView dequeueReusableCellWithIdentifier:qaIndetify];
        if (!cell) {
            cell = [[WatchLiveQATableViewCell alloc]init];
        }
        ((WatchLiveQATableViewCell *)cell).model = [_QADataArray objectAtIndex:indexPath.row];
    }
   else
    {
        static NSString * qaIndetify = @"identifiCell";
        cell = [tableView dequeueReusableCellWithIdentifier:qaIndetify];
        if (!cell) {
            cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:qaIndetify];
        }
    }
    cell.width = self.view.bounds.size.width;
    return cell;
}



-(NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    if (_chatBtn.selected) {
        return _chatDataArray.count;
    }
    
    if (_QABtn.selected) {
        return _QADataArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (_chatBtn.selected)
    {
        id mode = [_chatDataArray objectAtIndex:indexPath.row];
        if ([mode isKindOfClass:[VHallOnlineStateModel class]])
        {
            height = 60;
        }
        else
        {
            height = 60;
        }
    }
    
    if (_QABtn.selected)
    {
        height = 120;
    }
    return height;
}

#pragma mark - VHMoviePlayerDelegate
- (void)preLoadVideoFinish:(VHallMoviePlayer*)moviePlayer activeState:(VHMovieActiveState)activeState error:(NSError*)error
{
    if(error) {
        NSLog(@"视频预加载失败---error = %@   活动状态 = %zd",error,activeState);
        [UIAlertController showAlertControllerTitle:@"视频预加载失败" msg:error.localizedDescription btnTitle:@"确定" callBack:nil];
    }else {
        if(activeState == VHMovieActiveStateLive) {
            [self startPlayer];
        } else {
            [UIAlertController showAlertControllerTitle:@"提示" msg:@"当前活动未在直播" btnTitle:@"确定" callBack:nil];
        }
        //刷新聊天历史
        [self performSelector:@selector(chatButtonClick:) withObject:self.chatBtn afterDelay:1];
    }
}

- (void)moviePlayer:(VHallMoviePlayer *)player statusDidChange:(int)state
{
    
//    VHPlayerStateStoped                 = 0,    //停止   可调用startPlay: startPlayback: 状态转为VHallPlayerStateStarting
//    VHPlayerStateStarting               = 1,    //启动中
//    VHPlayerStatePlaying                = 2,    //播放中 可调用stopPlay pausePlay 状态转为VHallPlayerStateStoped/VHallPlayerStatePaused
//    VHPlayerStateStreamStoped           = 3,    //直播流停止 暂停pausePlay/流连接错误触发 可调用stopPlay reconnectPlay状态转为VHallPlayerStateStoped/VHallPlayerStatePlaying
//    VHPlayerStatePause                  = 4,    //回放暂停状态

    NSLog(@"^^^^^^^^^ %ld",(long)state);
    
    switch (state) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            _startAndStopBtn.selected = YES;
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;

        default:
            break;
    }

}
-(void)connectSucceed:(VHallMoviePlayer *)moviePlayer info:(NSDictionary *)info
{
    [self performSelector:@selector(chatButtonClick:) withObject:self.chatBtn afterDelay:1];

  //  [_startAndStopBtn setTitle:@"停止播放" forState:UIControlStateNormal];
    _startAndStopBtn.selected = YES;
    [_definitionBtn0 setImage:BundleUIImage(_videoLevePicArray[_moviePlayer.curDefinition]) forState:UIControlStateNormal];
}

-(void)bufferStart:(VHallMoviePlayer *)moviePlayer info:(NSDictionary *)info
{
    _bufferCount++;
    _bufferCountLabel.text = [NSString stringWithFormat:@"卡顿：%d",_bufferCount];
    [MBProgressHUD hideHUDForView:_moviePlayer.moviePlayerView animated:NO];
    [MBProgressHUD showHUDAddedTo:_moviePlayer.moviePlayerView animated:YES];
}

-(void)bufferStop:(VHallMoviePlayer *)moviePlayer info:(NSDictionary *)info
{
    [MBProgressHUD hideHUDForView:_moviePlayer.moviePlayerView animated:YES];

}

-(void)downloadSpeed:(VHallMoviePlayer *)moviePlayer info:(NSDictionary *)info
{
    NSString * content = info[@"content"];
    _bitRateLabel.text = [NSString stringWithFormat:@"%@ kb/s",content];
//    VHLog(@"downloadSpeed:%@",[info description]);
}

- (void)recStreamtype:(VHallMoviePlayer*)moviePlayer info:(NSDictionary*)info
{
    VHStreamType streamType = (VHStreamType)[info[@"content"] intValue];
    if (streamType == VHStreamTypeVideoAndAudio) {
        _logView.hidden = YES;
    } else if(streamType == VHStreamTypeOnlyAudio){
        _logView.hidden = NO;
    }
}

- (void)playError:(VHSaasLivePlayErrorType)livePlayErrorType info:(NSDictionary *)info;
{
    [MBProgressHUD hideHUDForView:_moviePlayer.moviePlayerView animated:YES];
    void (^resetStartPlay)(NSString * msg) = ^(NSString * msg){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.bitRateLabel.text = @"";
            self.startAndStopBtn.selected = NO;
            [self detailsButtonClick: nil];
            [self showMsgInWindow:msg afterDelay:2];
        });
    };

    NSString * msg = @"";
    switch (livePlayErrorType) {
        case VHSaasLivePlayParamError:
        {
            msg = @"参数错误";
            resetStartPlay(msg);
        }
            break;
        case VHSaasLivePlayRecvError:
        {
            msg = @"对方已经停止直播";
            resetStartPlay(msg);
        }
            break;
        case VHSaasLivePlayCDNConnectError:
        {
            msg = @"CDNConnect Error";
            resetStartPlay(msg);
        }
            break;
        case VHSaasLivePlayGetUrlError:
        {
            msg = @"获取活动信息错误";
            [self detailsButtonClick: nil];
            [self showMsgInWindow:info[@"content"] afterDelay:2];
        }
            break;
        default:
            break;
    }
}

-(void)VideoPlayMode:(VHMovieVideoPlayMode)playMode isVrVideo:(BOOL)isVrVideo
{
    _chatBtn.enabled = YES;
    
//    [self performSelector:@selector(chatButtonClick:) withObject:nil afterDelay:1];
    _isVr = isVrVideo;
    if (!_isRender)
    {
        if (isVrVideo)
        {
            _GyroBtn.hidden = NO;
            _GyroBtn.selected = YES;
//            [_moviePlayer setRenderViewModel:VHRenderModelDewarpVR];
            [_moviePlayer setUsingGyro:YES];
            
        }else
        {
            _GyroBtn.hidden =YES;
            _GyroBtn.selected = NO;
//            [_moviePlayer setRenderViewModel:VHRenderModelOrigin];
            [_moviePlayer setUsingGyro:NO];
            [self addPanGestureRecognizer];
        }
        _isRender =YES;
    }
    
    
    
    
    VHLog(@"---%ld",(long)playMode);
    self.liveTypeLabel.text = @"";
    _playModelTemp = playMode;
    switch (playMode) {
        case VHMovieVideoPlayModeNone:
        case VHMovieVideoPlayModeMedia:
        case VHMovieVideoPlayModeTextAndMedia:
//            [_playModeBtn0 setImage:UIImage(_videoPlayModelPicArray[0]) forState:UIControlStateNormal];
            _playModeBtn0.selected = NO;
            _playModeBtn0.enabled=YES;
            break;
        case VHMovieVideoPlayModeTextAndVoice:
        case VHMovieVideoPlayModeVoice:
        {
            self.liveTypeLabel.text = @"语音直播中";
        }
            _playModeBtn0.enabled=NO;
            break;
        default:
            break;
    }

    [self alertWithMessage:playMode];
}

-(void)VideoPlayModeList:(NSArray*)playModeList
{
    for (NSNumber *playMode in playModeList) {
        switch ([playMode intValue]) {
            case VHMovieVideoPlayModeMedia:
                [_videoPlayModel addObject:@"1"];
                break;
            case VHMovieVideoPlayModeTextAndVoice:
                [_videoPlayModel addObject:@"2"];
                break;
            case VHMovieVideoPlayModeTextAndMedia:
                [_videoPlayModel addObject:@"3"];
                break;
            case VHMovieVideoPlayModeVoice:
                [_videoPlayModel addObject:@"4"];
                break;
            default:
                break;
        }
    }
}

-(void)ActiveState:(VHMovieActiveState)activeState
{
    VHLog(@"activeState-%ld",(long)activeState);
}

- (void)VideoDefinitionList: (NSArray*)definitionList
{
    VHLog(@"可用分辨率%@ 当前分辨率：%ld",definitionList,(long)_moviePlayer.curDefinition);
    _definitionList = definitionList;
    _definitionBtn0.hidden = NO;
    [_definitionBtn0 setImage:BundleUIImage(_videoLevePicArray[_moviePlayer.curDefinition]) forState:UIControlStateNormal];
    if (_moviePlayer.curDefinition == VHMovieDefinitionAudio) {
        _playModelTemp=VHMovieVideoPlayModeVoice;
        _playModeBtn0.selected = YES;
    }
}

- (void)LiveStart{
    VHLog(@"LiveStart");
    
    __weak typeof(self) wf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [UIAlertController showAlertControllerTitle:@"提示" msg:@"直播已开始" btnTitle:@"确定" callBack:^{
            [wf startPlayer];
        }];
    });
}
- (void)LiveStartDefinition
{
    
}
- (void)LiveStoped
{
    VHLog(@"直播已结束");
    [MBProgressHUD hideHUDForView:_moviePlayer.moviePlayerView animated:YES];
    _startAndStopBtn.selected = NO;
    [_moviePlayer stopPlay];
    
    [UIAlertController showAlertControllerTitle:@"提示" msg:@"直播已结束" btnTitle:@"确定" callBack:nil];
}
// 主持人是否允许举手
- (void)moviePlayer:(VHallMoviePlayer *)player isInteractiveActivity:(BOOL)isInteractive interactivePermission:(VHInteractiveState)state
{
    //显示举手按钮
    if (isInteractive && (state == VHInteractiveStateHave)) {
        [_countDowwnView showCountView];
    }
    //隐藏举手按钮
    else {
        [_countDowwnView hiddenCountView];
    }
}
// 主持人同意上麦回调
- (void)moviePlayer:(VHallMoviePlayer *)player microInvitationWithAttributes:(NSDictionary *)attributes error:(NSError *)error {
    
    if (!error) {
        //退出全屏
        [self rotateScreen:NO];
        _fullscreenBtn.selected = NO;
        //进入互动
        VHinteractiveViewController *controller = [[VHinteractiveViewController alloc] init];
        controller.roomId = self.roomId;
        controller.pushResolution = self.interactResolution;
        controller.inavBeautifyFilterEnable = self.interactBeautifyEnable;
        controller.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:controller animated:YES completion:^{
            
        }];
    }
}
// 主持人邀请你上麦
- (void)moviePlayer:(VHallMoviePlayer *)player microInvitation:(NSDictionary *)attributes
{
    _invitationAlertView = [[VHInvitationAlert alloc]initWithDelegate:self tag:1000 title:@"上麦邀请" content:@"主持人邀请您上麦，是否接受？"];
    [self.view addSubview:_invitationAlertView];
}
- (void)moviePlayer:(VHallMoviePlayer*)player isKickout:(BOOL)isKickout
{
    VHLog(@"您已被踢出");
    _startAndStopBtn.selected = NO;
    
    [self kickOut];
}
- (void)moviePlayer:(VHallMoviePlayer *)player isCast_screen:(BOOL)isCast_screen
{
    self.isCast_screen = isCast_screen;
}
- (void)moviePlayer:(VHallMoviePlayer *)player isQuestion_status:(BOOL)isQuestion_status
{
    _isQuestion_status = isQuestion_status;
}
- (void)moviePlayer:(VHallMoviePlayer*)player isHaveDocument:(BOOL)isHave isShowDocument:(BOOL)isShow
{
    if(isHave)
    {
        if(_docShow != isShow) {
            [self showMsgInWindow:isShow ? @"主持人打开文档" : @"主持人关闭文档" afterDelay:1];
            _docShow = isShow;
        }
        self.textLabel.center=CGPointMake(self.docAreaView.width/2, self.docAreaView.height/2);
        [self.docAreaView insertSubview:self.textLabel atIndex:0];
        
        _moviePlayer.documentView.frame = self.docAreaView.bounds;
        [self.docAreaView addSubview:_moviePlayer.documentView];
    }
    _moviePlayer.documentView.hidden = !isShow;
    
    _moviePlayer.documentView.userInteractionEnabled = YES;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [_moviePlayer.documentView addGestureRecognizer:pan];
    UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(changeImageSize:)];
    [_moviePlayer.documentView addGestureRecognizer:pin];
}

//返回文档延迟时间
- (NSTimeInterval)documentDelayTime:(VHallMoviePlayer *)player {
    return player.realityBufferTime / 1000.0 + 3;
}

#pragma mark - VHInvitationAlertDelegate
- (void)alert:(VHInvitationAlert *)alert clickAtIndex:(NSInteger)index
{
    [alert removeFromSuperview];
    alert = nil;
    if(index == 1)
    {
        [self.moviePlayer replyInvitationWithType:1 finish:nil];
        
        //退出全屏
        [self rotateScreen:NO];
        _fullscreenBtn.selected = NO;
        
        //进入互动
        VHinteractiveViewController *controller = [[VHinteractiveViewController alloc] init];
        controller.roomId = self.roomId;
        controller.pushResolution = self.interactResolution;
        controller.inavBeautifyFilterEnable = self.interactBeautifyEnable;
        controller.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:controller animated:YES completion:^{
            
        }];
    }
    else if(index == 0)
    {
        [self.moviePlayer replyInvitationWithType:2 finish:nil];
    }
}
#pragma mark - MicCountDownViewDelegate
//举手倒计时结束回调
- (void)countDownViewDidEndCountDown:(MicCountDownView *)view {
    //取消上麦申请
    [_moviePlayer microApplyWithType:0 finish:^(NSError *error) {
        if(error)
            NSLog(@"取消申请上麦失败 %@",error.domain);
    }];
}

#pragma mark - Announcement
- (void)Announcement:(NSString*)content publishTime:(NSString*)time
{
    VHLog(@"公告:%@",content);
    if (!announcementContentDic)
    {
        announcementContentDic =[[NSMutableDictionary alloc] init];
    }
    [announcementContentDic setObject:content forKey:@"announceContent"];
    [announcementContentDic setObject:time forKey:@"announceTime"];
    
    
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

#pragma mark - VHallChatDelegate
- (void)reciveOnlineMsg:(NSArray *)msgs
{
    if (msgs.count > 0) {
        [_chatDataArray addObjectsFromArray:msgs];
        if (_chatBtn.selected) {
            [_chatView reloadData];
            [_chatView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_chatDataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}

- (void)reciveChatMsg:(NSArray *)msgs
{
    if (msgs.count > 0) {
        [_chatDataArray addObjectsFromArray:msgs];
        if (_chatBtn.selected) {
            [_chatView reloadData];
            [_chatView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_chatDataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        VHallChatModel* model = [msgs objectAtIndex:0];
        BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
        descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
        descriptor.params[@"text"] = model.text;
        descriptor.params[@"textColor"] = MakeColorRGB(0xffffff);//MakeColor(random()%255, random()%255, random()%255, 1);
        //@(100 * (double)random()/RAND_MAX+50) 随机速度
        descriptor.params[@"speed"] = @(100);// 固定速度
        descriptor.params[@"direction"] = @(BarrageWalkDirectionR2L);
        descriptor.params[@"side"] = @(BarrageWalkSideDefault);
//        descriptor.params[@"clickAction"] = ^{
//        };
        [_renderer receive:descriptor];
    }
}

- (void)reciveCustomMsg:(NSArray *)msgs
{
    if (msgs.count > 0) {
        [_chatDataArray addObjectsFromArray:msgs];
        if (_chatBtn.selected) {
            [_chatView reloadData];
            [_chatView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_chatDataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}

- (void)forbidChat:(BOOL) forbidChat
{
    [self showMsgInWindow:forbidChat?@"被禁言":@"取消禁言" afterDelay:2];
}
- (void)allForbidChat:(BOOL) allForbidChat
{
    [self showMsgInWindow:allForbidChat?@"全体禁言":@"取消全体禁言" afterDelay:2];
}
#pragma mark - VHallQAndADelegate
//主播开启问答
- (void)vhallQAndADidOpened:(VHallQAndA *)QA
{
    [self showMsgInWindow:@"主播开启了问答" afterDelay:2];
    _isQuestion_status = YES;
}
//主播关闭问答
- (void)vhallQAndADidClosed:(VHallQAndA *)QA
{
    [self showMsgInWindow:@"主播关闭了问答" afterDelay:2];
    [self chatButtonClick: self.chatBtn];
    _isQuestion_status = NO;
}
//发送问答
- (void)reciveQAMsg:(NSArray *)msgs
{
    for (VHallQAModel * qaModel in msgs) {
        [_QADataArray addObject:qaModel.questionModel];

        if (qaModel.answerModels.count > 0) {
            [_QADataArray addObjectsFromArray:qaModel.answerModels];
        }
    }

    if (_QABtn.selected) {
        [_chatView reloadData];
    }
}

#pragma mark - VHallLotteryDelegate
- (void)startLottery:(VHallStartLotteryModel *)msg
{
    if (_lotteryVC) {
        [_lotteryVC.view removeFromSuperview];
        [_lotteryVC removeFromParentViewController];
        _lotteryVC = nil;
    }
    
    _lotteryVC = [[WatchLiveLotteryViewController alloc] init];
    _lotteryVC.lottery = _lottery;
    _lotteryVC.view.frame = _showView.bounds;
    [_showView addSubview:_lotteryVC.view];
}

- (void)endLottery:(VHallEndLotteryModel *)msg
{
    if (!_lotteryVC) {
        _lotteryVC = [[WatchLiveLotteryViewController alloc] init];
        _lotteryVC.lottery = _lottery;
        _lotteryVC.view.frame = _showView.bounds;
        [_showView addSubview:_lotteryVC.view];
    }
    _lotteryVC.lotteryOver = YES;
    _lotteryVC.endLotteryModel = msg;
}

#pragma mark - VHallSignDelegate
- (void)startSign
{
//    NSLog(@"开始签到");
    __weak typeof(self) weakSelf = self;
    [SignView showSignBtnClickedBlock:^BOOL{
        [weakSelf SignBtnClicked];
        return NO;
    }];
}

- (void)SignBtnClicked
{
    __weak typeof(self) weakSelf = self;
    [_sign signSuccessIsStop:NO success:^{
      [SignView close];
      [weakSelf showMsgInWindow:@"签到成功" afterDelay:2];
    } failed:^(NSDictionary *failedData) {
        [weakSelf showMsgInWindow:[NSString stringWithFormat:@"%@,错误码%@",failedData[@"content"],failedData[@"code"]] afterDelay:2];
        [_sign cancelSign];
        [SignView close];
    }];
}

- (void)signRemainingTime:(NSTimeInterval)remainingTime
{
    NSLog(@"距结束%d秒",(int)remainingTime);
    [SignView remainingTime:remainingTime];
}

- (void)stopSign
{   [SignView close];
    [self showMsgInWindow:@"签到结束" afterDelay:2];
}

#pragma mark - 收到问卷回调 VHallSurveyDelegate
/*flsh活动，发布问卷以下两个方法都会回调。如果使用webView的方式加载问卷，在-receivedSurveyWithURL:处理，如果仍保留旧版加载问卷方式，在-receiveSurveryMsgs:方法处理，处理方式不变。H5活动发布问卷，只回调-receivedSurveyWithURL：。
 */

- (void)receivedSurveyWithURL:(NSURL *)surveyURL
{
    VHallSurveyModel *model = [[VHallSurveyModel alloc] init];
    model.surveyURL = surveyURL;
    [_chatDataArray addObject:model];//添加问卷消息到聊天列表

    if (_chatBtn.selected) {
        [_chatView reloadData];
        [_chatView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_chatDataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

-(void)receiveSurveryMsgs:(NSArray*)msgs
{
}

#pragma mark 显示问卷详情
-(void)clickSurvey:(id)mode
{
    if (![VHallApi isLoggedIn]) {
        [self showMsgInWindow:@"请登录" afterDelay:2];
        return;
    }
    
    VHallSurveyModel *model =mode;
    //获取问卷详情，使用原生绘制问卷，可通过此接口获取问卷详情数据，更具问卷文档解析数据
    [_survey getSurveryRequestWithSurveyId:model.surveyId webInarId:_roomId success:^(NSDictionary *result) {
        NSLog(@"问卷数据 %@",result);
        if ([result[@"code"] integerValue] == 200) {
            
        } else {
            
        }
    } failed:^(NSDictionary *failedData) {
        
    }];
    
    
    //v4.0.0 及已上线 使用webview 加载h5问卷详情
    if (model.surveyURL)
    {
        if (!_surveyController) {
            _surveyController = [[VHSurveyViewController alloc] init];
            _surveyController.delegate = self;
        }
        _surveyController.view.frame = self.view.bounds;
        _surveyController.url = model.surveyURL;
        [self.view addSubview:_surveyController.view];
    }
    // v4.0.0 版本以下
    else
    {
//        __weak typeof(self) weakSelf =self;
//        [self rotateScreen:NO];
//        self.fullscreenBtn.enabled =NO;
//        [_survey getSurveryContentWithSurveyId:model.surveyId webInarId:_roomId success:^(VHallSurvey *survey) {
//            weakSelf.fullscreenBtn.enabled =YES;
//            [weakSelf showSurveyVCWithSruveyModel:survey];
//        } failed:^(NSDictionary *failedData) {
//            weakSelf.fullscreenBtn.enabled =YES;
//            NSString* code = [NSString stringWithFormat:@"%@", failedData[@"code"]];
//        }];
        
        //如果未升级SDK，但是需要使用webView的方式展示问卷，使用以下方式加载。如不使用webView的方式仍使用以上方法即可。
        NSURL *surveyURL = [self surveyURLWithRoomId:self.roomId model:model];
        if (!_surveyController) {
            _surveyController = [[VHSurveyViewController alloc] init];
            _surveyController.delegate = self;
        }
        _surveyController.view.frame = self.view.bounds;
        _surveyController.url = surveyURL;
        [self.view addSubview:_surveyController.view];
    }
}
#pragma mark 问卷详情回调 VHSurveyViewControllerDelegate
- (void)surveyviewControllerDidCloseed:(UIButton *)sender {
    [_surveyController.view removeFromSuperview];
    _surveyController = nil;
}
- (void)surveyViewControllerWebViewDidClosed:(VHSurveyViewController *)vc {
    [_surveyController.view removeFromSuperview];
    _surveyController = nil;
}
//提交成功
- (void)surveyViewControllerWebViewDidSubmit:(VHSurveyViewController *)vc msg:(NSDictionary *)body {
    [_surveyController.view removeFromSuperview];
    _surveyController = nil;
    [self showMsgInWindow:@"提交成功" afterDelay:2];
}

#pragma mark - UIPanGestureRecognizer
-(void)handlePan:(UIPanGestureRecognizer*)pan
{
    float baseY = 200.0f;
    CGPoint translation = CGPointZero;
    static float volumeSize = 0.0f;
    CGPoint currentLocation = [pan translationInView:self.view];
    if (pan.state == UIGestureRecognizerStateBegan)
    {
        translation = [pan translationInView:self.view];
        volumeSize = [VHallMoviePlayer getSysVolumeSize];
    }else if(pan.state == UIGestureRecognizerStateChanged)
    {
        float y = currentLocation.y-translation.y;
        float changeSize = ABS(y)/baseY;
        if (y>0){
            [VHallMoviePlayer setSysVolumeSize:volumeSize-changeSize];
        }else{
            [VHallMoviePlayer setSysVolumeSize:volumeSize+changeSize];
        }
    }
}

#pragma mark - ObserveValueForKeyPath
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:kViewFramePath])
    {
        _moviePlayer.moviePlayerView.frame = self.backView.bounds;
        _logView.frame = _moviePlayer.moviePlayerView.bounds;
        _lotteryVC.view.frame = _showView.bounds;
        [SignView layoutView:self.view.bounds];
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




-(void)didBecomeActive
{
    
    
    NSString *content =nil;
    NSString *time =nil;
    if (announcementContentDic !=nil)
    {
        content =[ announcementContentDic objectForKey:@"announceContent"];
        time =[announcementContentDic    objectForKey:@"announceTime"];
    }
    
    if(announcementView !=nil)
    {
        [announcementView setContent:[content stringByAppendingString:time]];
        
    }
    
    
}


#pragma mark - 详情
- (IBAction)detailsButtonClick:(UIButton *)sender {
    self.docConentView.hidden = YES;
    self.chatView.hidden = YES;
    self.bottomView.hidden = YES;
    
    self.detailBtn.selected = YES;
    self.docBtn.selected = NO;
    self.chatBtn.selected = NO;
    self.QABtn.selected = NO;
    
    self.cueSelectedButton = sender;
    
    [self.detailBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.docBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.chatBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.QABtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

#pragma mark - 文档
- (IBAction)textButtonClick:(UIButton *)sender {
    self.docConentView.hidden = NO;
    self.chatView.hidden = YES;
    self.bottomView.hidden = YES;
    self.detailBtn.selected = NO;
    self.docBtn.selected = YES;
    self.chatBtn.selected = NO;
    self.QABtn.selected = NO;
    
    self.cueSelectedButton = sender;
    
    [self.detailBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.docBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.chatBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.QABtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

}

#pragma mark - 聊天
- (IBAction)chatButtonClick:(UIButton *)sender {
    self.docConentView.hidden = YES;
    self.chatView.hidden = NO;
    self.bottomView.hidden = NO;
    self.detailBtn.selected = NO;
    self.docBtn.selected = NO;
    self.chatBtn.selected = YES;
    self.QABtn.selected = NO;
    
    self.cueSelectedButton = sender;
    
    [self.detailBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.docBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.chatBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.QABtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    [_chatView reloadData];
    
    if (!_isReciveHistory)
    {
        __weak typeof(self) weakSelf = self;
        [self loadHistoryChatWithPage:1 completion:^{
            if(_chatDataArray.count > 0) {
                [weakSelf.chatView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_chatDataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }];
        _isReciveHistory = YES;
    }
}

//获取历史聊天记录
- (void)loadHistoryChatWithPage:(NSInteger)page completion:(void(^)(void))completion{
    __weak typeof(self) ws = self;
    [_chat getHistoryWithStartTime:nil pageNum:page pageSize:20 success:^(NSArray <VHallChatModel *> *msgs) {
        if(page == 1) {
            ws.chatDataArray = [NSMutableArray arrayWithArray:msgs];
            _chatListPage = 1;
        }else {
            if (msgs.count > 0) {
                _chatListPage ++;
                NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, msgs.count)];
                [ws.chatDataArray insertObjects:msgs atIndexes:indexes];
            }
        }
        [ws.chatView reloadData];
        [ws.chatView.mj_header endRefreshing];
        [ws.chatView.mj_footer endRefreshing];
        completion ? completion() : nil;
    } failed:^(NSDictionary *failedData) {
        NSString* errorInfo = [NSString stringWithFormat:@"%@---%@", failedData[@"content"], failedData[@"code"]];
        NSLog(@"获取历史聊天记录失败：%@",errorInfo);
        [ws.chatView.mj_footer endRefreshing];
        [ws.chatView.mj_header endRefreshing];
        completion ? completion() : nil;
    }];
}

#pragma mark - 问答
- (IBAction)QAButtonClick:(UIButton *)sender {
    
    if (!_isQuestion_status) {
        [self showMsgInWindow:@"主播关闭了问答" afterDelay:2];
        return;
    }

    self.docConentView.hidden = YES;
    self.chatView.hidden = NO;
    self.bottomView.hidden = NO;
    self.detailBtn.selected = NO;
    self.docBtn.selected = NO;
    self.chatBtn.selected = NO;
    self.QABtn.selected = YES;
    
    self.cueSelectedButton = sender;
    
    [self.detailBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.docBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.chatBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.QABtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [_chatView reloadData];

    if(_QADataArray.count==0)
    {
        __weak typeof(self) weakself = self;
        [_QA getQAndAHistoryWithType:YES success:^(NSArray *msgs) {
            [weakself reciveQAMsg:msgs];
        } failed:^(NSDictionary *failedData) {
            
        }];
    }
}

#pragma mark -
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
    [self showMsgInWindow:message afterDelay:1];
}


- (IBAction)definitionBtnCLicked:(UIButton *)sender {
    if(!_startAndStopBtn.selected)return;
    if(_definitionList.count==0)
        return;
    
    int _leve = _moviePlayer.curDefinition;
    BOOL isCanPlayDefinition = NO;
    
    while (!isCanPlayDefinition) {
        _leve = _leve+1;
        if(_leve>=4)
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
    _playModeBtn0.selected = NO;
    [_definitionBtn0 setImage:BundleUIImage(_videoLevePicArray[_moviePlayer.curDefinition]) forState:UIControlStateNormal];
    _playModelTemp=_moviePlayer.playMode;
}

- (IBAction)playModeBtnCLicked:(UIButton *)sender {
    if(!_startAndStopBtn.selected)return;
    UIButton *btn =(UIButton*)sender;
    btn.selected = !sender.selected;
    if (btn.selected)
    {
        _playModelTemp=VHMovieVideoPlayModeVoice;
        _playModeBtn0.selected = YES;
//        [_playModeBtn0 setImage:UIImage(_videoPlayModelPicArray[1]) forState:UIControlStateNormal];
    }else
    {
        _playModeBtn0.selected = NO;
        _playModelTemp=VHMovieVideoPlayModeMedia;
//        [_playModeBtn0 setImage:UIImage(_videoPlayModelPicArray[0]) forState:UIControlStateNormal];
    }
    
    
    [MBProgressHUD hideHUDForView:_moviePlayer.moviePlayerView animated:NO];
    [MBProgressHUD showHUDAddedTo:_moviePlayer.moviePlayerView animated:YES];
    if (_playModelTemp == VHMovieVideoPlayModeVoice ||_playModelTemp == VHMovieVideoPlayModeTextAndVoice) {
        [_moviePlayer setCurDefinition:VHMovieDefinitionAudio];
        _logView.hidden=NO;
        self.liveTypeLabel.text = @"语音直播中";
    }
    else {
        [_moviePlayer setCurDefinition:VHMovieDefinitionOrigin];
        _logView.hidden=YES;
        _definitionBtn0.hidden = NO;
        self.liveTypeLabel.text = @"";
    }
    [_definitionBtn0 setImage:BundleUIImage(_videoLevePicArray[_moviePlayer.curDefinition]) forState:UIControlStateNormal];
}

#pragma mark 弹幕开关
- (IBAction)barrageBtnClick:(id)sender
{
//    UIButton *btn = (UIButton*)sender;
//    btn.selected = !btn.selected;
    
    _rendererOpenBtn.selected = !_rendererOpenBtn.selected;
    if (_rendererOpenBtn.selected)
    {
        [_renderer start];
      
    }else
    {
        [_renderer stop];
    }
}

#pragma mark 陀螺开关

- (IBAction)startGyroClick:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    if (btn.selected)
    {
        [_moviePlayer setUsingGyro:YES];
    }else
    {
        [_moviePlayer setUsingGyro:NO];
    }
    
}

#pragma mark messageToolViewDelegate
- (void)didSendText:(NSString *)text
{
    if ([text isEqualToString:@""]) {
        [self showMsgInWindow:@"发送的消息不能为空" afterDelay:2];
        return;
    }
    __weak typeof(self) wf = self;
    if (self.cueSelectedButton == _chatBtn) {
        [_chat sendMsg:text success:^{
            
        } failed:^(NSDictionary *failedData) {
            
            NSString* code = [NSString stringWithFormat:@"%@ %@", failedData[@"code"],failedData[@"content"]];
            [wf showMsgInWindow:code afterDelay:2];
        }];
        
        return;
    }
    
    if (self.cueSelectedButton == _QABtn) {
        
        [_QA sendMsg:text success:^{
            
            
        } failed:^(NSDictionary *failedData) {
            
            NSString* code = [NSString stringWithFormat:@"%@ %@", failedData[@"code"],failedData[@"content"]];
            [wf showMsgInWindow:code afterDelay:2];
        }];
        
        return;
    }
}



#pragma mark  网络变化


- (void)networkChange:(NSNotification *)notification {
    Reachability *currReach = [notification object];
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    
    //对连接改变做出响应处理动作
    NetworkStatus status = [currReach currentReachabilityStatus];
    //如果没有连接到网络就弹出提醒实况
    if(status == NotReachable)
    {
        _connectedNetWork =NO;
        return;
    }
    if (status == ReachableViaWiFi || status == ReachableViaWWAN) {
        if ((_connectedNetWork == NO) && _moviePlayer) {
            [_moviePlayer reconnectSocket];
        }
        _connectedNetWork =YES;
        
    }
}

- (IBAction)fullscreenBtnClicked:(UIButton*)sender {

    _fullScreentBtnClick =YES;
    if(_fullscreenBtn.isSelected)
    {//退出全屏
        [self rotateScreen:NO];
    }
    else
    {//全屏
        [self rotateScreen:YES];
    }
}

- (void)rotateScreen:(BOOL)isLandscapeRight
{
    if(isLandscapeRight && self.view.width>self.view.height)return;
    if(!isLandscapeRight && self.view.width<self.view.height)return;

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

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



-(DLNAView *)dlnaView
{
    if (!_dlnaView) {
        _dlnaView = [[DLNAView alloc] initWithFrame:self.view.bounds];
        _dlnaView.delegate = self;
    }
    return _dlnaView;
}
- (IBAction)DlNAClick:(id)sender
{
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
- (IBAction)customMsgBtnClick:(id)sender
{
    NSMutableDictionary * json = [NSMutableDictionary dictionary];
    json[@"key"] = @"value";
    json[@"num"] = @"0.12";
    json[@"name"] = @"小明";
    NSString * jsonStr = [self jsonStringWithObject:json];
//    NSString *jsonStr = @"{\"key\":\"value\",\"name\":\"小明\",\"phone\":18300001111}";
    __weak typeof(self) wf = self;
    if (_chatBtn.selected == YES) {
        [_chat sendCustomMsg:jsonStr success:^{
            [wf showMsgInWindow:@"发送成功" afterDelay:1];
        } failed:^(NSDictionary *failedData) {
            
            NSString* code = [NSString stringWithFormat:@"%@ %@", failedData[@"code"],failedData[@"content"]];
            [wf showMsgInWindow:code afterDelay:2];
        }];
    }
}

- (IBAction)changeDocFrameBtnClick:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if(sender.selected)
    {
        _moviePlayer.documentView.frame = CGRectMake(100, 100, 160, 90);
        [self.view addSubview:_moviePlayer.documentView];
    }
    else{
        _moviePlayer.documentView.frame = self.docAreaView.bounds;
        [self.docAreaView addSubview:_moviePlayer.documentView];
    }
}


#pragma mark - private

- (void)kickOut {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您已被踢出房间" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self kickOutAction];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:NO completion:nil];
}

- (void)kickOutAction {
    [_renderer stop];
    [_moviePlayer stopPlay];
    [_moviePlayer destroyMoivePlayer];
    
    UIViewController *vc = self;
    Class homeVcClass = NSClassFromString(@"VHHomeViewController");
    while (![vc isKindOfClass:homeVcClass]) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma waring 版本低于4.0.0 问卷Web URL拼接方式
- (NSURL *)surveyURLWithRoomId:(NSString *)roomId model:(VHallSurveyModel *)model
{
    NSString *timeStamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];//时间戳
    NSString *string = [NSString stringWithFormat:@"https://cnstatic01.e.vhall.com/questionnaire/%@.html?",model.surveyId];
    NSString *domain = [NSString stringWithFormat:@"https://e.vhall.com&webinar_id=%@&r=%@",roomId,timeStamp];
    NSString *string1 = [NSString stringWithFormat:@"%@survey_id=%@&user_id=%@&domain=%@",string,model.surveyId,model.joinId,domain];
    return [NSURL URLWithString:string1];
}
// 字典转json字符串方法
- (NSString *)jsonStringWithObject:(id)dict
{
    if(!dict) return @"";
    if([dict isKindOfClass:[NSString class]])return dict;
    
    NSString *jsonString = @"";
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:0
                                                         error:&error];
    if (error) {
        VHLog(@"%@",error);
        return @"";
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return (jsonString.length>0)?jsonString:@"";
}

@end
