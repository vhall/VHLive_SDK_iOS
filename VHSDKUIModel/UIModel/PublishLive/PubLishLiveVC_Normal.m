//
//  DemoViewController.m
//  PublishDemo
//
//  Created by liwenlong on 15/10/9.
//  Copyright (c) 2015年 vhall. All rights reserved.
//

#import "PubLishLiveVC_Normal.h"
#import <AVFoundation/AVFoundation.h>
#import "WatchLiveOnlineTableViewCell.h"
#import "WatchLiveChatTableViewCell.h"
#import <VHLiveSDK/VHallApi.h>
#import "UIAlertController+ITTAdditionsUIModel.h"

#import "VHLiveChatView.h"
#import "VHKeyboardToolView.h"
#import "VHBeautyAdjustController.h"
#import "VHBeautyView.h"
#import <VHLiveSDK/VHallApi.h>
#import "OMTimer.h"
@interface PubLishLiveVC_Normal ()<VHallLivePublishDelegate, VHallChatDelegate,VHKeyboardToolViewDelegate>
{
    BOOL  _isAudioStart;
    BOOL  _torchType;
    BOOL  _onlyVideo;
    BOOL  _isFontVideo;
    UIButton * _lastFilterSelectBtn;

    VHallChat         *_chat;       //聊天
    dispatch_source_t _timer;
    long              _liveTime;
    BOOL  _publishSuccess;  //标记当前开播状态
}


@property (strong, nonatomic)VHallLivePublish *engine;
@property (weak, nonatomic) IBOutlet UIView *perView;
@property (weak, nonatomic) IBOutlet UIImageView *logView;
@property (weak, nonatomic) IBOutlet UILabel *bitRateLabel;
@property (weak, nonatomic) IBOutlet UIButton *videoStartAndStopBtn;
@property (weak, nonatomic) IBOutlet UIButton *audioStartAndStopBtn;
@property (weak, nonatomic) IBOutlet UIButton *torchBtn; //闪光灯
@property (weak, nonatomic) IBOutlet UIView *chatContainerView;
@property (weak, nonatomic) IBOutlet UITextField *msgTextField;
@property (weak, nonatomic) IBOutlet UIButton *chatMsgSend;
@property (weak, nonatomic) IBOutlet UIButton *filterBtn;
@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (weak, nonatomic) IBOutlet UIButton *defaultFilterSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *cameraSwapBtn;
@property (weak, nonatomic) IBOutlet UIButton *hideKeyBtn;  //用来点击移除输入工具、美颜级别view或其他弹窗视图的全屏按钮

@property (nonatomic, strong) VHLiveChatView *chatView;
@property (nonatomic, strong) NSMutableArray *chatDataArray;
@property (nonatomic,strong) VHKeyboardToolView * messageToolView;  //输入工具view
@property (weak, nonatomic) IBOutlet UIView *noiseView;
@property (weak, nonatomic) IBOutlet UILabel *noiseLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backbtntopConstraint;
@property (nonatomic, strong) NSMutableDictionary *publishParam;     ///<发直播参数
@property (nonatomic,strong) VHBeautifyKit *beautKit;///美颜
@property (nonatomic,strong) VHBeautyView *beautyView;

@property (nonatomic,strong) VHBeautyAdjustController *adjustVC;

@property (nonatomic,assign) BOOL  isBeauty;//是否可以使用美颜功能

@property (weak, nonatomic) IBOutlet UIButton *audioClose;
///记录房间流状态
@property (nonatomic) BOOL  streamStatus;
///主持人进入房间流异常视图
@property (nonatomic) UIView *middleView;
///流异常提示文本
@property (nonatomic) UILabel *exceptionLabel;
///异常定时器
@property (nonatomic) OMTimer *exceptionTimer;
//左边机位提示
@property (nonatomic) UILabel *tipLabel;
///云导播关闭按钮
@property (nonatomic) UIButton *closeAction;
@end

@implementation PubLishLiveVC_Normal
#pragma mark ---云导播的新增UI
- (void)directorUIError:(BOOL)isHave{
    UIView *middle = [[UIView alloc] init];
    [self.view addSubview:middle];
    self.middleView = middle;
    self.middleView.backgroundColor = [UIColor colorWithHex:@"#222222"];
    [middle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.width.height.mas_equalTo(200);
    }];
    self.middleView.hidden = isHave;
    UIImageView *middleImageV = [[UIImageView alloc] init];
    middleImageV.image = BundleUIImage(@"warning-outline");
    [middle addSubview:middleImageV];
    [middleImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(CGSizeMake(70, 70)));
        make.centerX.offset(0);
        make.top.offset(30);
    }];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    self.exceptionLabel = tipLabel;
    tipLabel.textColor = [UIColor colorWithHex:@"999999"];
    tipLabel.text = @"未检测到云导播流";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = FONT_FZZZ(16);
    [middle addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(CGSizeMake(200, 50)));
        make.centerX.offset(0);
        make.top.offset(130);
    }];
    UILabel *label = [[UILabel alloc] init];
    NSString *value = [NSString stringWithFormat:@"视频推流到云导播台-%@",self.seatModel.name];
    self.tipLabel = label;
    label.font = FONT_FZZZ(12);
    label.textColor = [UIColor colorWithHex:@"#FFFFFF"];
    self.tipLabel.text = value;
    [self.view addSubview:label];
    if (self.liveVideoType == VHLiveVideoDirectorSeatPushStream) {
        self.tipLabel.hidden = NO;
    }else{
        self.tipLabel.hidden = YES;
    }
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(64);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(50);
    }];
    
    self.closeAction = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view insertSubview:self.closeAction atIndex:self.view.subviews.count - 1];
    [self.closeAction setImage:BundleUIImage(@"DLNA_close") forState:UIControlStateNormal];
    [self.closeAction addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
    [self.closeAction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.top.offset(30);
        make.width.height.mas_equalTo(44);
    }];
}
- (void)clickClose{
    [self stopLiveAlert];
}
- (void)hostEnterClose{
    if (_publishSuccess) {
        //开播后
        [self.engine stopDirectorLive];
        [self.engine destoryDirectorLive];
        _engine = nil;
    }else{
        //开播前
        [self.engine destoryDirectorLive];
        _engine = nil;
    }
}
#pragma mark - Lifecycle
- (id)init
{
    self = LoadVCNibName;
    if (self) {
        [self initDatas];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [VHHelpTool getMediaAccess:^(BOOL videoAccess, BOOL audioAcess) {
        // Do any additional setup after loading the view from its nib.
        self.beautKit = [VHBeautifyKit beautifyManagerWithModuleClass:[VHBFURender class]];
    //    self.beautKit = [VHReflect initBeautyEffectKit];
        [self initViews];
       
        switch (self.liveVideoType) {
            case VHLiveVideoNormal:{
                [self initLiveHardWare];
            }
                break;
            case VHLiveVideoDirectorSeatPushStream:{
                [self directorUIError:YES];
                [self initLiveHardWare];
                self.videoStartAndStopBtn.hidden = YES;
                self.infoView.hidden = YES;
                if(_publishSuccess) { //如果当前已经成功开播，且没有主动停止直播，但由于网络断开等问题导致被动停止，再次开播时，重连流即可
                    [_engine reconnect];
                }else { //发起直播
                    [_engine startSeatPushDirectorLive:self.publishParam checkHostLine:NO];
                }
            }
                break;
            case VHLiveVideoDirectorHostEnter:{
                //需展示云导播台的总画面
                [self initHostEnterDirectorLive];
            }
                break;
            
            default:
                break;
        }
        NSLog(@"-----%@",self.filterBtn);

    }];
}

- (void)initHostEnterDirectorLive{
    self.engine = [[VHallLivePublish alloc] initDirectorHostEnter:self.publishParam fail:^(NSError * error) {
        [UIAlertController showAlertControllerTitle:error.localizedDescription msg:@"" btnTitle:@"确定" callBack:^{
            [self dismissViewControllerAnimated:true completion:nil];
        }];
    }];
    self.engine.liveView.frame   = _perView.bounds;
    self.engine.delegate = self;//监听云导播主房间流状态
    self.engine.liveView.contentMode = UIViewContentModeScaleToFill;
    [self.perView insertSubview:_engine.liveView atIndex:0];
    _chat = [[VHallChat alloc] initWithLivePublish:self.engine];
    _chat.delegate = self;
    
    self.noiseView.hidden = YES;
    self.noiseLabel.hidden = YES;
    self.cameraSwapBtn.hidden = YES;
    self.filterBtn.hidden = YES;
    self.filterView.hidden = YES;
    self.audioClose.hidden = YES;
    self.streamStatus = self.directorOpen;
    if (self.directorOpen) {
        self.videoStartAndStopBtn.enabled = YES;
        self.videoStartAndStopBtn.alpha = 1.0f;
        [self directorUIError:YES];
    }else{
        self.videoStartAndStopBtn.enabled = NO;
        self.videoStartAndStopBtn.alpha = 0.5f;
        [self directorUIError:NO];
    }
}
#pragma mark ---普通直播与云导播机位推流需使用相机和麦克风
- (void)initLiveHardWare{
    //初始化CameraEngine

    [self initCameraEngine];
    //普通直播或云导播机位推流需要请求相机与麦克风权限



    //获取音频权限
    AVAudioSessionRecordPermission permissionStatus = [[AVAudioSession sharedInstance] recordPermission];
    if (permissionStatus == AVAudioSessionRecordPermissionUndetermined) {
       [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
       }];
    } else if (permissionStatus == AVAudioSessionRecordPermissionDenied) {

    } else {
        
    }
    NSLog(@"-----%@",self.filterBtn);
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //云导播以主持人发起直播，不使用摄像头麦克风，回显云导播的总画面
    self.liveVideoType == VHLiveVideoDirectorHostEnter?:[self readCacheStatus];
    
}
- (void)readCacheStatus{
    if ([VHSaveBeautyTool readSaveCacheStatus]) {
        //有缓存去缓存状态
        [VHSaveBeautyTool closeBeauty:[VHSaveBeautyTool beautyViewModelArray][0] beautifyKit:self.beautKit closeBeautyEffect:![VHSaveBeautyTool readBeautyEnableStatus]];
    }else{
        [VHSaveBeautyTool closeBeauty:[VHSaveBeautyTool beautyViewModelArray][0] beautifyKit:self.beautKit closeBeautyEffect:NO];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (_chat) {
        _chat = nil;
    }
    if (_engine) {
        _engine = nil;
    }
    [self.adjustVC saveBeautyConfigModel];
    //[VHReflect destoryBeautyEffectKit];
    [VHBeautifyKit destroy];
    //允许iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    VHLog(@"%@ dealloc",[[self class]description]);
}
#pragma mark --- 云导播以主持人进入前后台需请求接口请求有没有流
- (void)hostEnterRoomIsHaveStream{
    [VHWebinarBaseInfo getDirectorRoomStreamStatus:self.roomId success:^(BOOL isHaveStream) {
        [self haveDirectorStream:isHaveStream];
    } fail:^(NSError * _Nonnull error) {
        
    }];
}
-(void)LaunchLiveDidEnterBackground
{
    if(_publishSuccess) {
        [_engine disconnect];
    }
    [_engine stopVideoCapture];
}

-(void)LaunchLiveWillEnterForeground
{
    if (self.liveVideoType == VHLiveVideoDirectorHostEnter) {
        [self hostEnterRoomIsHaveStream];
    }else{
        [_engine startVideoCapture];
        if(_publishSuccess) {
            [_engine reconnect];
        }
    }
}

//返回
- (IBAction)closeBtnClick:(id)sender
{
    
    [self stopLiveAlert];
}
- (void)stopLiveAlert{
    [UIAlertController showAlertControllerTitle:@"提示" msg:@"您是否要结束直播？" leftTitle:@"取消" rightTitle:@"结束" leftCallBack:^{

    } rightCallBack:^{
        [self stopEngine];
    }];
}
- (void)stopEngine{
    if (self.liveVideoType == VHLiveVideoDirectorHostEnter) {
        if (_publishSuccess) {
            [_engine stopDirectorLive];
            [_engine destoryDirectorLive];
        }else{
            [_engine destoryDirectorLive];
        }
        _engine = nil;
    }else{
        if (_engine.isPublishing) {
             [_engine stopLive];//停止活动
        }
        [_engine destoryObject];
        _engine = nil;
    }

    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self.navigationController popViewControllerAnimated:NO];
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
        return UIInterfaceOrientationMaskPortrait;
    }else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }else
    {
        return UIInterfaceOrientationMaskLandscapeLeft;
    }
}


#pragma mark - Lifecycle(Private)

- (void)registerLiveNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LaunchLiveDidEnterBackground)name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LaunchLiveWillEnterForeground)name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void)initDatas
{
    _isAudioStart = NO;
    _torchType = NO;
    _onlyVideo = NO;
    _isFontVideo = NO;
    _videoResolution = VHHVideoResolution;
    _chatDataArray = [NSMutableArray arrayWithCapacity:0];
}

- (void)initViews
{
    //阻止iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self registerLiveNotification];
    [self.perView addSubview:_closeBtn];
    
    _chatMsgSend.layer.masksToBounds = YES;
    _chatMsgSend.layer.cornerRadius = 15;
    _chatMsgSend.layer.borderWidth  = 1;
    _chatMsgSend.layer.borderColor  = MakeColorRGBA(0xffffff, 0.5).CGColor;
    
    _msgTextField.layer.masksToBounds = YES;
    _msgTextField.layer.cornerRadius = 15;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:_msgTextField.placeholder attributes:
         @{NSForegroundColorAttributeName:[UIColor lightGrayColor],
           NSFontAttributeName:_msgTextField.font}
         ];
    _msgTextField.attributedPlaceholder = attrString;
    
    _audioStartAndStopBtn.hidden = YES;
    
    _filterBtn.hidden = !self.beautifyFilterEnable;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    __weak __typeof(self) weakself = self;
    if(!_chatView) {
        _chatView = [[VHLiveChatView alloc] initWithFrame:CGRectMake(10, 0,_chatContainerView.width-10,_chatContainerView.height - 50) msgTotal:^NSInteger{
            return  weakself.chatDataArray.count;
        } msgSource:^VHActMsg *(NSInteger index) {
            return  weakself.chatDataArray[index];
        }action:nil];
    } else {
        _chatView.frame = CGRectMake(10, 0,_chatContainerView.width-10,_chatContainerView.height - 50);
    }

    [_chatContainerView addSubview:_chatView];
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
        _backbtntopConstraint.constant = iPhoneX? 40 :20;
    }
    if (self.liveVideoType == VHLiveVideoDirectorHostEnter) {
        //兼容竖屏
        self.engine.liveView.frame = self.view.frame;
       
    }else{
        self.engine.displayView.frame = self.view.frame;
    }
}

#pragma mark - 初始化推流器
- (void)initCameraEngine
{
    AVCaptureVideoOrientation captureVideoOrientation;
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait)
    {
        captureVideoOrientation = AVCaptureVideoOrientationPortrait;
    }else {
        captureVideoOrientation = AVCaptureVideoOrientationLandscapeRight;//设备左转，摄像头在左边
    }
    
    VHPublishConfig* config = [VHPublishConfig configWithType:VHPublishConfigTypeDefault];
    config.orientation = captureVideoOrientation;
//    config.pushType = VHStreamTypeOnlyAudio; //音频直播
    config.pushType = VHStreamTypeVideoAndAudio; //默认视频直播
    config.publishConnectTimes = 2;
    config.videoBitRate = self.videoBitRate<=0?700:self.videoBitRate;
    config.videoCaptureFPS = self.videoCaptureFPS<=0?15:self.videoCaptureFPS;
    config.isOpenNoiseSuppresion = self.isOpenNoiseSuppresion;
    config.videoResolution = self.videoResolution<=0?2:self.videoResolution;
    config.audioBitRate = self.audioBitRate<=0?64:self.audioBitRate;
    config.captureDevicePosition = AVCaptureDevicePositionFront;
    if(self.beautifyFilterEnable)
    {
        config.beautifyFilterEnable = YES;
        config.captureDevicePosition = AVCaptureDevicePositionFront;
        _isFontVideo = YES;
    }
    
  
    if (self.beautKit) {
        config.beautifyFilterEnable = NO;
        config.advancedBeautifyEnable = YES;
        self.engine = [[VHallLivePublish alloc] initWithBeautyConfig:config handleError:^(NSError *error) {
            NSLog(@"error===%@",error.localizedDescription);
            self.isBeauty = (error!=nil)?NO:YES;//是否可以使用美颜功能
        }];
    }else{
        self.engine = [[VHallLivePublish alloc] initWithConfig:config];
        if (self.beautifyFilterEnable) {
            [self filterSettingBtnClick:_defaultFilterSelectBtn];
        }
    }
    self.engine.delegate = self;

    self.engine.displayView.frame   = _perView.bounds;
    [self.perView insertSubview:_engine.displayView atIndex:0];
    
//    //开始视频采集、并显示预览界面
    [self.engine startVideoCapture];

    
    _noiseView.hidden = !_isOpenNoiseSuppresion;

    // chat 模块
    if (self.liveVideoType != VHLiveVideoDirectorSeatPushStream) {
        _chat = [[VHallChat alloc] initWithLivePublish:self.engine];
        _chat.delegate = self;
    }
}

#pragma mark - 发起/停止直播
- (IBAction)startVideoPlayer:(UIButton *)sender
{
    switch (self.liveVideoType) {
        case VHLiveVideoDirectorHostEnter:{
            [self.engine startDirectorLive];
            [_chatDataArray removeAllObjects];
            [_chatView update];
            [self chatShow:YES];
            _publishSuccess = YES;
            self.videoStartAndStopBtn.hidden = YES;
            self.bitRateLabel.hidden = YES;
        }
            break;
        case VHLiveVideoDirectorSeatPushStream:{
            //机位推流-进入页面机位就往主播台推流
        }
            break;
        case VHLiveVideoNormal:{
            //普通直播
#if (TARGET_IPHONE_SIMULATOR)
    VH_ShowToast(@"无法在模拟器上发起直播！");
    return;
#endif
    
    if(sender.selected == NO) {  //开始直播
        [ProgressHud showLoading];
        
        if(_publishSuccess) { //如果当前已经成功开播，且没有主动停止直播，但由于网络断开等问题导致被动停止，再次开播时，重连流即可
            [_engine reconnect];
        }else { //发起直播
            [_engine startLive:self.publishParam];
            [_chatDataArray removeAllObjects];
            [_chatView update];
        }
    }else { //停止直播
       
        
        [UIAlertController showAlertControllerTitle:@"提示" msg:@"您是否要结束直播？" leftTitle:@"取消" rightTitle:@"结束" leftCallBack:^{

        } rightCallBack:^{
            [_engine stopLive];//停止直播
            [_engine destoryObject];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
        }
            break;
        default:
            break;
    }

}

//发起/停止纯音频直播
- (IBAction)startAudioPlayer
{
//    TODO:暂时不支持此功能，但保留。
//    if (!_isAudioStart)
//    {
//        _isVideoStart = YES;
//        [self startVideoPlayer];
//
//        _logView.hidden = NO;
//        _chatBtn.hidden = NO;
//        [_hud show:YES];

//        NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
//        param[@"id"] =  _roomId;
//        param[@"access_token"] = _token;
//        param[@"is_single_audio"] = @"1";   // 0 ：视频， 1：音频
//        [_engine startLive:param];
//    }else{
//        _logView.hidden = YES;
//        _bitRateLabel.text = @"";
//        _chatBtn.hidden = YES;
//        [_hud hide:YES];
//        [_audioStartAndStopBtn setTitle:@"音频直播" forState:UIControlStateNormal];
//        [_engine disconnect];//停止向服务器推流
//    }
//    _isAudioStart = !_isAudioStart;
}

#pragma mark - 基础操作
- (IBAction)swapBtnClick:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    btn.enabled = NO;
    _isFontVideo = !_isFontVideo;

    BOOL success=  [_engine swapCameras:_isFontVideo ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack];
    
    if(success) {
        _torchBtn.hidden = _isFontVideo;
        //禁止快速切换摄像头
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            btn.enabled = YES;
        });
    }
}

- (IBAction)torchBtnClick:(UIButton*)sender
{
    _torchType = !_torchType;
    sender.selected = _torchType;
    [_engine setDeviceTorchModel:_torchType ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
}

- (IBAction)onlyVideoBtnClick:(UIButton*)sender
{
    _onlyVideo = !_onlyVideo;
    sender.selected = _onlyVideo;
    _engine.isMute = _onlyVideo;
}

- (BOOL)emCheckMicrophoneAvailability{
    __block BOOL ret = NO;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
        [session performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            ret = granted;
        }];
    } else {
        ret = YES;
    }
    return ret;
}

#pragma mark - 直播代理
//活动信息回调
- (void)publish:(VHallLivePublish *)publishObject webinarInfo:(VHWebinarInfo *)webinarInfo {
    VHLog(@"接收到活动信息");
    if(webinarInfo.liveType == VHWebinarLiveType_Audio) { //音频直播
        self.cameraSwapBtn.hidden = YES;
    }
}

-(void)firstCaptureImage:(UIImage *)image {
    VHLog(@"第一张图片");
}

-(void)publishStatus:(VHLiveStatus)liveStatus withInfo:(NSDictionary *)info {
    NSString *content = info[@"content"];
    
    switch (liveStatus)
    {
        case VHLiveStatusUploadSpeed:
        {
            _bitRateLabel.text = [NSString stringWithFormat:@"%@ kb/s",content];
        }
            break;
        case VHLiveStatusPushConnectSucceed:
        {
            [ProgressHud hideLoading];
            switch (self.liveVideoType) {
                case VHLiveVideoNormal:{
                    [self chatShow:YES];
                    _publishSuccess = YES;
                    _videoStartAndStopBtn.selected = YES;
                }
                    
                    break;
                case VHLiveVideoDirectorSeatPushStream:{
                    //云导播以机位推流进入,
                    _publishSuccess = YES;
                    _videoStartAndStopBtn.hidden = YES;
                    _videoStartAndStopBtn.selected = YES;
                }
                    break;
                
                default:
                    break;
            }
           
            //设置画面填充模式
            [_engine setContentMode:VHRTMPMovieScalingModeAspectFill];
            if (self.liveVideoType == VHLiveVideoDirectorSeatPushStream) {
                VH_ShowToast(@"直播开始");
            }
        }
            break;
        case VHLiveStatusSendError:
        {
            content = @"流发送失败";
            [self publishWithErrorMsg:content];
        }
            break;
        case VHLiveStatusPushConnectError:
        {
            NSString *str =[NSString stringWithFormat:@"连接失败:%@",content];
            [self publishWithErrorMsg:str];
        }
            break;
        case VHLiveStatusParamError:
        {
            content = @"参数错误";
            [self publishWithErrorMsg:content];
        }
            break;
        case VHLiveStatusGetUrlError:
        {
            [self publishWithErrorMsg:content];
        }
            break;
        case VHLiveStatusUploadNetworkOK:
        {
            _bitRateLabel.textColor = [UIColor greenColor];
            VHLog(@"kLiveStatusNetworkStatus:%@",content);
        }
            break;
        case VHLiveStatusUploadNetworkException:
        {
            _bitRateLabel.textColor = [UIColor redColor];
            VHLog(@"kLiveStatusNetworkStatus:%@",content);
        }
            break;
        case  VHLiveStatusAudioRecoderError : //音频采集失败
        {
            [self publishWithErrorMsg:content];
            
        }
            break;
        case VHLiveStatusDirectorError:{
            [UIAlertController showAlertControllerTitle:content msg:@"" btnTitle:@"确定" callBack:^{
                [_engine stopVideoCapture];
                [_engine destoryObject];
                _engine = nil;
            }];
        }
            break;
        default:
            break;
    }
}

//推流失败提示
- (void)publishWithErrorMsg:(NSString *)msg {
    [ProgressHud hideLoading];
    
    _bitRateLabel.text = @"";
    _videoStartAndStopBtn.selected = NO;
    [self chatShow:NO];
    [UIAlertController showAlertControllerTitle:msg msg:@"" btnTitle:@"确定" callBack:nil];
}

- (VHBeautyView *)beautyView{
    if (!_beautyView) {
        _beautyView = [[VHBeautyView alloc] init];
    }
    return _beautyView;
}
- (VHBeautyAdjustController *)adjustVC{
    if (!_adjustVC) {
        _adjustVC = [[VHBeautyAdjustController alloc] init];
    }
    return _adjustVC;
}
#pragma mark - 美颜设置
- (IBAction)filterBtnClick:(UIButton *)sender
{

    if (self.beautKit) {
        //有新美颜模块
        if (self.isBeauty) {
            //可用状态
//            VHBeautyAdjustController *just = [[VHBeautyAdjustController alloc] init];
//            [just refreshEffect:self.beautKit];
//            [self presentViewController:just animated:YES completion:nil];
//            return;
            [self.adjustVC refreshEffect:self.beautKit];
            [self presentViewController:self.adjustVC animated:YES completion:nil];
        }else{
            //不可用状态
            [VHAlertView showAlertWithTitle:kServerNotAvaliable content:nil cancelText:nil cancelBlock:nil confirmText:@"确定" confirmBlock:^{
            
        }];
        }
    }else{
    //    [_chatMsgInput resignFirstResponder];
        _filterBtn.selected = !_filterBtn.selected;
        if(_filterBtn.selected)
        {
            _hideKeyBtn.hidden = NO;
            _filterView.alpha = 0.0f;
            [UIView animateWithDuration:0.3f animations:^{
                _filterView.alpha = 1.0f;
            }];
        }
        else
        {
            _hideKeyBtn.hidden = YES;
            _filterView.alpha = 1.0f;
            [UIView animateWithDuration:0.3f animations:^{
                _filterView.alpha = 0.0f;
            }];
        }
    }
}

- (IBAction)filterSettingBtnClick:(UIButton *)sender
{
    if (sender.selected) {
        return;
    }
    
    if (_lastFilterSelectBtn) {
        [_lastFilterSelectBtn setBackgroundColor:MakeColorRGBA(0x000000,0.5)];
        _lastFilterSelectBtn.selected = NO;
    }
    
    sender.selected = YES;
    [sender setBackgroundColor:MakeColorRGBA(0xfd3232,0.5)];
    _lastFilterSelectBtn = sender;
    
    switch (sender.tag) {
        case 1:[self.engine setBeautify:10.0f Brightness:1.0f  Saturation:1.0f Sharpness:0.0f];break;
        case 2:[self.engine setBeautify:8.0f  Brightness:1.05f Saturation:1.0f Sharpness:0.0f];break;
        case 3:[self.engine setBeautify:6.0f  Brightness:1.10f Saturation:1.0f Sharpness:0.0f];break;
        case 4:[self.engine setBeautify:4.0f  Brightness:1.15f Saturation:1.0f Sharpness:0.0f];break;
        case 5:[self.engine setBeautify:2.0f  Brightness:1.2f  Saturation:1.0f Sharpness:0.0f];break;
        default:break;
    }
}

#pragma mark - Chat && QA
- (void)chatShow:(BOOL)isShow
{
    if(isShow)
    {
        _chatContainerView.alpha = 0.0f;
        [UIView animateWithDuration:0.3f animations:^{
            _chatContainerView.alpha = 1.0f;
        }];
        _closeBtn.hidden = YES;
        _infoView.hidden = NO;
        [self showTimeInfo];
    }
    else
    {
        _chatContainerView.alpha = 1.0f;
        [UIView animateWithDuration:0.3f animations:^{
            _chatContainerView.alpha = 0.0f;
        }];
        _closeBtn.hidden = NO;
        _infoView.hidden = YES;
        if(_timer)
        {
            dispatch_source_cancel(_timer);
            _timer = nil;
        }
        if (self.liveVideoType != VHLiveVideoDirectorHostEnter) {
            _bitRateLabel.text = @"0 kb/s";
            _bitRateLabel.textColor = [UIColor greenColor];
        }
        _timeLabel.text    = @"00:00:00";
    }
}

//点击"我来说两句"
- (IBAction)sendMsgButtonClick:(UIButton *)sender {
    [self.messageToolView becomeFirstResponder];
}

#pragma mark Chat && QA(VHallChatDelegate)
- (void)reciveOnlineMsg:(NSArray <VHallOnlineStateModel *> *)msgs
{
    if (msgs.count > 0) {
        for (VHallOnlineStateModel *m in msgs) {
            VHActMsg * msg = [[VHActMsg alloc]initWithMsgType:ActMsgTypeMsg];
            msg.actId= m.room;
            msg.joinId= m.join_id;
            msg.formUserIcon= m.avatar;
            msg.formUserName= m.user_name;
            msg.formUserId= m.account_id;
            msg.time= m.time;

            NSString *event;
            NSString *role;
            if([m.event isEqualToString:@"online"]) {
                event = @"进入";
            }else if([m.event isEqualToString:@"offline"]){
                event = @"离开";
            }
            
            if([m.role isEqualToString:@"host"]) {
                //role = @"主持人";
                role = VH_MB_HOST;
            }else if([m.role isEqualToString:@"guest"]) {
//                role = @"嘉宾";
                role = VH_MB_GUEST;
            }else if([m.role isEqualToString:@"assistant"]) {
//                role = @"助手";
                role = VH_MB_ASSIST;
            }else if([m.role isEqualToString:@"user"]) {
                role = @"观众";
            }
            
            msg.text = [NSString stringWithFormat:@"%@\n[%@] %@房间:%@ 在线:%@ 参会:%@",m.time,role,event,msg.actId, m.concurrent_user, m.attend_count];
            [_chatDataArray addObject:msg];
        }
        [_chatView update];
    }
}



- (void)reciveChatMsg:(NSArray <VHallChatModel *> *)msgs
{
    if (msgs.count > 0) {
        for (VHallChatModel *m in msgs) {
            VHActMsg * msg = [[VHActMsg alloc]initWithMsgType:ActMsgTypeMsg];
            msg.actId= m.room;
            msg.joinId= m.join_id;
            msg.formUserIcon= m.avatar;
            msg.formUserName= m.user_name;
            msg.formUserId= m.account_id;
            msg.time= m.time;
            
            NSString *contextText = [NSString stringWithFormat:@"%@\n%@",m.text ? m.text : @"",m.imageUrls.count>0 ? [m.imageUrls componentsJoinedByString : @";"] : @""];
            
            msg.text = [NSString stringWithFormat:@"%@\n%@",m.time, contextText];
            
            [_chatDataArray addObject:msg];
        }
        [_chatView update];
    }
}
#pragma mark ---云导播新增房间流状态
- (void)directorStream:(BOOL)haveStream{
    NSLog(@"%@", [NSString stringWithFormat:@"房间%@流",haveStream?@"有":@"没有"]);
    [self haveDirectorStream:haveStream];
}
#pragma mark --- 有没有流与有没有开播
- (void)haveDirectorStream:(BOOL)haveStream{
    if (_publishSuccess) {
        self.videoStartAndStopBtn.hidden = YES;
        self.closeBtn.hidden = YES;
        //开播接到流房间流信息 显示倒计时
        if (haveStream) {
            //销毁定时器
            self.engine.liveView.hidden = NO;
            self.engine.liveView.backgroundColor = [UIColor clearColor];
            [self.exceptionTimer stop];
            self.exceptionTimer = nil;
            self.middleView.hidden = YES;
        }else{
            //开启定时器
            self.engine.liveView.hidden = YES;
            self.engine.liveView.backgroundColor =  [UIColor colorWithHex:@"222222"];
            [self.exceptionTimer resume];
            self.middleView.hidden = NO;
        }
    }else{
        //未开播接到房间流信息
        if (haveStream) {
            self.engine.liveView.hidden = NO;
            self.middleView.hidden = YES;
            self.videoStartAndStopBtn.enabled = YES;
            self.videoStartAndStopBtn.alpha = 1.0f;
        }else{
            self.engine.liveView.hidden = YES;
            self.exceptionLabel.text = @"未检测到云导播推流";
            self.middleView.hidden = NO;
            self.videoStartAndStopBtn.enabled = NO;
            self.videoStartAndStopBtn.alpha = 0.5f;
        }
    }
}
#pragma mark - 懒加载
- (OMTimer *)exceptionTimer
{
    if (!_exceptionTimer)
    {
        _exceptionTimer = [[OMTimer alloc] init];
        _exceptionTimer.timerInterval = 60*60*24*365;
        _exceptionTimer.precision = 100;
        _exceptionTimer.isAscend = YES;
        @weakify(self);
        _exceptionTimer.progressBlock = ^(OMTime *progress) {
            @strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.exceptionLabel.text = [NSString stringWithFormat:@"云导播推流异常 %@:%@:%@", progress.hour, progress.minute, progress.second];
            });
        };
    }
    return _exceptionTimer;
}
- (void)destoryTimer{
    [self.exceptionTimer stop];
}

-(void)showTimeInfo{
    if(_timer)
    {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    _liveTime = 0;
    dispatch_queue_t queue = dispatch_queue_create("my queue", 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 0), 1 * NSEC_PER_SEC, 0);//间隔1秒
    dispatch_source_set_event_handler(_timer, ^(){
        _liveTime++;
        NSString *strInfo = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",_liveTime/3600,(_liveTime/60)%60,_liveTime%60];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(_timeLabel)
            {
                _timeLabel.text = strInfo;
            }
        });
    });
    dispatch_resume(_timer);
}

- (IBAction)hideKey:(id)sender {
    //关闭键盘输入
    [_messageToolView resignFirstResponder];
 
    _hideKeyBtn.hidden = YES;
    
    //关闭美颜级别弹窗
    _filterBtn.selected = NO;
    [UIView animateWithDuration:0.3f animations:^{
        _filterView.alpha = 0.0f;
    }];
}

- (IBAction)noiseSliderValueVhange:(UISlider *)sender {
    _noiseLabel.text = [NSString stringWithFormat:@"音频增益：%f",sender.value];
    [_engine setVolumeAmplificateSize:sender.value];
}

#pragma mark - VHKeyboardToolViewDelegate
/*! 发送按钮事件回调*/
- (void)keyboardToolView:(VHKeyboardToolView *)view sendText:(NSString *)text {
    if(text == nil || text.length <= 0) {
        VH_ShowToast(@"发送内容不能为空");
        return;
    }
    
    [self hideKey:nil];
    [_chat sendMsg:text success:^{
        
    } failed:^(NSDictionary *failedData) {
        NSString* string = [NSString stringWithFormat:@"(%@)%@", failedData[@"code"],failedData[@"content"]];
        VH_ShowToast(string);
    }];
}



- (VHKeyboardToolView *)messageToolView
{
    if (!_messageToolView)
    {
        _messageToolView = [[VHKeyboardToolView alloc] init];
        _messageToolView.delegate = self;
        [self.view addSubview:_messageToolView];
    }
    return _messageToolView;
}

- (NSMutableDictionary *)publishParam
{
    if (!_publishParam)
    {
        _publishParam = [[NSMutableDictionary alloc]init];
        _publishParam[@"id"] = _roomId;
        _publishParam[@"access_token"] = _token;
        _publishParam[@"nickname"] = _nick_name;
        _publishParam[@"seat"] = self.seatModel.seat_id?:@"";//机位推流为必传参数
    }
    return _publishParam;
}
- (void)beautyKitModule:(VHBeautifyKit *)module{
    self.beautKit = module;
}
@end
