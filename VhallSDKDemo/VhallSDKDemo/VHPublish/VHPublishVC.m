//
//  VHPublishVC.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/4/17.
//

#import "AppDelegate.h"
#import "VHLiveWeakTimer.h"
#import "VHPublishToolView.h"
#import "VHPublishVC.h"
#import "VHSpeedMonitor.h"

@interface VHPublishVC ()<VHallLivePublishDelegate>

/// 视频直播推流
@property (nonatomic, strong) VHallLivePublish *livePublish;
/// 工具栏
@property (nonatomic, strong) VHPublishToolView *toolView;
/// 开始按钮
@property (nonatomic, strong) UIButton *startBtn;
/// 网速检测
@property (nonatomic, strong) VHSpeedMonitor *speedMonitor;
/// 计时器
@property (nonatomic, strong) NSTimer *timer;
/// 是否横屏
@property (nonatomic, assign) BOOL isFull;

@end

@implementation VHPublishVC
#pragma mark - 释放
- (void)dealloc
{
    VHLog(@"%s释放", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String]);
}

#pragma mark - 控制器生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self screenChangeWithIsFull:self.screenLandscape];

    // 设为YES则保持常亮，不自动锁屏，默认为NO会自动锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // 设为YES则保持常亮，不自动锁屏，默认为NO会自动锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"勿动,隔夜测试";//lss_4aab3f7e

    // 设置样式
    [self setWithUI];

    // 初始化
    [self initWithData];

    // 开始检测网速
    [self.speedMonitor startNotifier];

    self.timer = [VHLiveWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

#pragma mark - 开启计时器
- (void)timerAction
{
    int kbps = (int)[self.speedMonitor getInterfaceSpeedInKbps];

    self.toolView.kbpsLab.text = [NSString stringWithFormat:@"%d kbps/s", kbps];
    VHLog(@"实时网速 === %d kbps", kbps);
}

#pragma mark - 设置样式
- (void)setWithUI
{
    self.livePublish.displayView.frame = self.view.bounds;

    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-SAFE_BOTTOM);
        make.size.mas_equalTo(CGSizeMake(200, 45));
    }];

    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - 初始化
- (void)initWithData
{
    [self.livePublish startVideoCapture];
}

#pragma mark - 开始直播
- (void)startBtnAction
{
    [self.startBtn setHidden:YES];

    [self.toolView setHidden:NO];

    [self.livePublish startLive:@{ @"id": self.webinar_id }];
}

#pragma mark - VHallLivePublishDelegate
// 发起直播时的状态
- (void)publishStatus:(VHLiveStatus)liveStatus withInfo:(NSDictionary *)info
{
    if (liveStatus == VHLiveStatusPushConnectSucceed) {
        [VHProgressHud showToast:@"开始推流"];
    } else if (liveStatus == VHLiveStatusUploadSpeed) {
        VHLog(@"直播速率 === %@", [info mj_JSONString]);
    } else if (liveStatus == VHLiveStatusPushConnectError ||  liveStatus == VHLiveStatusParamError || liveStatus == VHLiveStatusSendError || liveStatus == VHLiveStatusAudioRecoderError || liveStatus == VHLiveStatusVideoError || liveStatus == VHLiveStatusGetUrlError || liveStatus == VHLiveStatusDirectorError ) {
        [VHProgressHud showToast:info[@"content"]];
        [self.startBtn setHidden:NO];
    } else {
        VHLog(@"liveStatus === %ld 其他 === %@", liveStatus, [info mj_JSONString]);
    }
}

// 采集到第一帧的回调
- (void)firstCaptureImage:(UIImage *)image
{
}

// 活动相关信息回调（注意：此接口为v6.0新增，仅限新版控制台(v3及以上)创建的活动使用，否则不会回调）
- (void)publish:(VHallLivePublish *)publishObject webinarInfo:(VHWebinarInfo *)webinarInfo
{
    
}

#pragma mark - 屏幕旋转
- (void)screenChangeWithIsFull:(BOOL)isFull
{
    // 状态一致不需要在执行
    if (self.isFull == isFull) {
        return;
    }

    // 记录状态
    self.isFull = isFull;

    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // 全屏操作
    appdelegate.launchScreen = isFull;

    if (@available(iOS 16.0, *)) {
        [self setNeedsUpdateOfSupportedInterfaceOrientations];
        NSArray *array = [[[UIApplication sharedApplication] connectedScenes] allObjects];
        UIWindowScene *scene = [array firstObject];
        UIInterfaceOrientationMask orientation = isFull ? UIInterfaceOrientationMaskLandscapeRight : UIInterfaceOrientationMaskPortrait;
        UIWindowSceneGeometryPreferencesIOS *geometryPreferencesIOS = [[UIWindowSceneGeometryPreferencesIOS alloc] initWithInterfaceOrientations:orientation];
        [scene requestGeometryUpdateWithPreferences:geometryPreferencesIOS
                                       errorHandler:^(NSError *_Nonnull error) {
            VHLog(@"强制%@错误:%@", isFull ? @"横屏" : @"竖屏", error);
        }];
    } else {
        UIInterfaceOrientation interfaceOrientation =  isFull ? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait;
        NSNumber *orientationTarget = [NSNumber numberWithInteger:interfaceOrientation];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }

//    [self.navigationController.navigationBar setBackgroundImage:isFull ? nil : [UIImage imageWithColor:VHMainColor] forBarMetrics:UIBarMetricsDefault];resume 13:55:24  error 13:56:50
//    [self.navigationController.navigationBar setShadowImage: isFull ? nil : [UIImage imageWithColor:VHMainColor]]; resume 14:01:17.514727  error 14:01:39
//    [self.navigationController setNavigationBarHidden:isFull animated:NO];

    if (isFull) {
        self.livePublish.displayView.frame = CGRectMake(0, 0, Screen_Width > Screen_Height ? Screen_Width : Screen_Height, Screen_Width < Screen_Height ? Screen_Width : Screen_Height);
    } else {
        self.livePublish.displayView.frame = CGRectMake(0, 0, Screen_Width < Screen_Height ? Screen_Width : Screen_Height, Screen_Width > Screen_Height ? Screen_Width : Screen_Height);
    }
}

#pragma mark - 前台
- (void)appWillEnterForeground {
    // 重连
    [self.livePublish reconnect];

    [super appWillEnterForeground];
}

#pragma mark - 后台
- (void)appDidEnterBackground {
    if (self.livePublish.isPublishing) {
        // 断开
        [self.livePublish disconnect];
    }

    [super appDidEnterBackground];
}

#pragma mark - 点击返回
- (void)clickLeftBarItem
{
    // 退出横屏
    if (self.isFull) {
        [self screenChangeWithIsFull:NO];
    }

    // 销毁网速检测
    if (_speedMonitor) {
        [_speedMonitor stopNotifier];
        _speedMonitor = nil;
    }

    if (_livePublish) {
        [_livePublish stopLive];
        [_livePublish destoryObject];
        _livePublish = nil;
    }

    // 返回上级
    [super clickLeftBarItem];
}

#pragma mark - 懒加载
- (VHallLivePublish *)livePublish
{
    if (!_livePublish) {
        VHPublishConfig *config = [VHPublishConfig configWithType:VHPublishConfigTypeDefault];
        config.pushType = self.webinar_type == VHWebinarLiveType_Audio ? VHStreamTypeOnlyAudio : VHStreamTypeVideoAndAudio;
        config.beautifyFilterEnable = NO;
        config.videoCaptureFPS = 25;
        config.videoBitRate = 1500;
        config.publishConnectTimeout = 10;
        config.publishConnectTimes = 1;
        config.isOpenNoiseSuppresion = YES;
        config.volumeAmplificateSize = 0.5;
        config.orientation = self.screenLandscape ? AVCaptureVideoOrientationLandscapeRight : AVCaptureVideoOrientationPortrait;
        config.captureDevicePosition = AVCaptureDevicePositionFront;
        config.customVideoWidth = self.screenLandscape ? 1280 : 720;
        config.customVideoHeight = self.screenLandscape ? 720 : 1280;
        _livePublish = [[VHallLivePublish alloc] initWithConfig:config];
        _livePublish.delegate = self;
        [self.view addSubview:_livePublish.displayView];
    }

    return _livePublish;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setHidden:NO];
        [_startBtn.layer setMasksToBounds:YES];
        [_startBtn.layer setCornerRadius:45 / 2];
        [_startBtn setBackgroundColor:VHMainColor];
        [_startBtn setTitle:@"开始直播" forState:UIControlStateNormal];
        [_startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_startBtn addTarget:self action:@selector(startBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_startBtn];
    }

    return _startBtn;
}

- (VHPublishToolView *)toolView
{
    if (!_toolView) {
        _toolView = [[VHPublishToolView alloc] init];
        [_toolView setHidden:YES];
        __weak __typeof(self) weakSelf = self;
        _toolView.clickPlay = ^(BOOL isSelect) {
            isSelect ? [weakSelf.livePublish reconnect] : [weakSelf.livePublish disconnect];
        };
        _toolView.clickCamera = ^(BOOL isSelect) {
            [weakSelf.livePublish swapCameras:weakSelf.livePublish.captureDevicePosition == AVCaptureDevicePositionBack ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack];
        };
        _toolView.clickMic = ^(BOOL isSelect) {
            weakSelf.livePublish.isMute = isSelect;
        };
        _toolView.clickMirror = ^(BOOL mirror) {
            [weakSelf.livePublish camVidMirror:mirror];
        };
        [self.view addSubview:_toolView];
    }

    return _toolView;
}

- (VHSpeedMonitor *)speedMonitor
{
    if (!_speedMonitor) {
        _speedMonitor = [[VHSpeedMonitor alloc] init];
    }

    return _speedMonitor;
}

/*
 #pragma mark - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   }
 */

@end
