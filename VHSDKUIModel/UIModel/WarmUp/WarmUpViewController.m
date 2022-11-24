//
//  WarmUpViewController.m
//  UIModel
//
//  Created by 郭超 on 2022/10/25.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "WarmUpViewController.h"
#import "OMTimer.h"

#import <VHLiveSDK/VHallApi.h>
#import <WebKit/WebKit.h>

@interface WarmUpViewController ()<VHWarmInfoObjectDelegate,WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) VHWarmInfoObject  *   warmInfo;           ///<暖场视频类

@property (nonatomic, strong) UIView            *   topView;
@property (nonatomic, strong) UIButton          *   backBtn;            ///<返回按钮
@property (nonatomic, strong) UILabel           *   titleLab;           ///<标题

@property (nonatomic, strong) UIImageView       *   headImg;            ///<头像
@property (nonatomic, strong) UILabel           *   nicknameLab;        ///<昵称
@property (nonatomic, strong) UIView            *   warmVod;            ///<暖场视频
@property (nonatomic, strong) UIImageView       *   warmImg;            ///<暖场图片
@property (nonatomic, strong) UIButton          *   playBtn;            ///<开播按钮
@property (nonatomic, strong) UILabel           *   timeLab;            ///<开播计时器
@property (nonatomic, strong) UIView            *   lineView1;
@property (nonatomic, strong) UILabel           *   infoLab;            ///<简介标题
@property (nonatomic, strong) UILabel           *   subscribeLab;       ///<预约标题
@property (nonatomic, strong) UIView            *   lineView2;
@property (nonatomic, strong) UIView            *   lineView3;
@property (nonatomic, strong) UILabel           *   webinarTitleLab;    ///<活动标题
@property (nonatomic, strong) UILabel           *   startTimeLab;       ///<开播时间
@property (nonatomic, strong) WKWebView         *   webView;            ///<详情

@property (nonatomic, strong) OMTimer           *   startTimer;         ///<开播定时器

@property (nonatomic, strong) VHWarmInfoModel   *   warmInfoModel;      ///<暖场视频详情
@property (nonatomic, assign) NSInteger             record_list_index;  ///<记录播放第几个
@end

@implementation WarmUpViewController

#pragma mark - 顶部状态栏高度（包括安全区）
- (CGFloat)vg_statusBarHeight {
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIStatusBarManager *statusBarManager = windowScene.statusBarManager;
        return statusBarManager.statusBarFrame.size.height;
    } else {
        return [UIApplication sharedApplication].statusBarFrame.size.height;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    // ui布局
    [self masonryToUI];

    // 初始化
    self.warmInfo = [[VHWarmInfoObject alloc] initWithWebinar_id:self.webinar_id delegate:self];
    
}

#pragma mark - UI
- (void)masonryToUI
{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.mas_equalTo(20);
        }
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.left.mas_equalTo(22);
        make.centerY.mas_equalTo(self.topView.mas_centerY);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
        make.width.mas_lessThanOrEqualTo(150);
    }];

    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(self.backBtn.mas_bottom).offset(18);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [self.nicknameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImg.mas_right).offset(8);
        make.centerY.mas_equalTo(self.headImg.mas_centerY);
    }];
    
    [self.warmVod mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImg.mas_bottom).offset(4);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.view.width * 9 / 16);
    }];
    
    [self.warmImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.warmVod);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.warmImg);
        make.size.mas_equalTo(CGSizeMake(54, 54));
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.warmVod.mas_bottom).offset(20);
    }];

    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLab.mas_bottom).offset(35);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(8);
    }];

    [self.subscribeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(self.lineView1.mas_bottom).offset(13);
    }];

    [self.infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(self.lineView1.mas_bottom).offset(13);
    }];
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.infoLab.mas_bottom).offset(6);
        make.centerX.mas_equalTo(self.infoLab.mas_centerX);
        make.width.mas_equalTo(self.infoLab.mas_width);
        make.height.mas_equalTo(2.5);
    }];

    [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView2.mas_bottom).offset(4.5);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(.5);
    }];

    [self.webinarTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(self.lineView3.mas_bottom).offset(16);
    }];
    
    [self.startTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(self.webinarTitleLab.mas_bottom).offset(8);
    }];

    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.startTimeLab.mas_bottom).offset(16);
        make.bottom.mas_equalTo(0);
    }];
    
}

#pragma mark - 增加播放器
- (void)addMoviePlayerView
{
    [self.warmVod addSubview:self.warmInfo.moviePlayerView];
    [self.warmVod sendSubviewToBack:self.warmInfo.moviePlayerView];
    [self.warmInfo.moviePlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.warmVod);
    }];
}

#pragma mark - 点击播放
- (void)clickPlayBtnAction
{
    // 初始化播放第一个
    self.record_list_index = 0;

    // 播放暖场视频
    [self startWithPlayer];
}

#pragma mark - 播放视频
- (void)startWithPlayer
{
    if (self.warmInfoModel.record_list.count > 0){
        // 取值
        VHWarmInfoRecordListItem * item = self.warmInfoModel.record_list[self.record_list_index];
        // 播放
        [self.warmInfo startPlay:item];
    }else{
        VH_ShowToast(@"无暖场视频");
    }
}

#pragma mark - VHWarmInfoObjectDelegate
// 初始化完成
- (void)initializationCompletion:(VHWebinarInfoData *)webinarInfo warmInfoModel:(VHWarmInfoModel *)warmInfoModel error:(NSError *)error
{
    if (webinarInfo && warmInfoModel) {
        
        // 赋值
        self.warmInfoModel = warmInfoModel;
        
        // 1-直播中，2-预约，3-结束，4-点播，5-回放
        NSInteger  roomState = webinarInfo.webinar.type;
        NSString * roomStateStr = @"";
        switch (roomState) {
            case 1:
                roomStateStr = @"直播中";
                break;
            case 2:
                roomStateStr = @"预告";
                break;
            case 3:
                roomStateStr = @"结束";
                break;
            case 4:
                roomStateStr = @"点播";
                break;
            case 5:
                roomStateStr = @"回放";
                break;

            default:
                break;
        }
        VH_ShowToast(roomStateStr);
        
        // 倒计时
        if (roomState == 2) {
            self.timeLab.hidden = NO;
        }else{
            self.timeLab.hidden = YES;
        }
         
        // 状态文字
        self.subscribeLab.text = roomStateStr;

        // 添加暖场视频播放器
        [self addMoviePlayerView];
        
        // 获取暖场视频封面
        [self.warmImg sd_setImageWithURL:[NSURL URLWithString:warmInfoModel.img_url.length > 0 ? warmInfoModel.img_url : webinarInfo.webinar.img_url]];
        
        // 播放按钮 (如果没视频隐藏播放按钮)
        if (warmInfoModel.record_list.count > 0) {
            self.playBtn.hidden = NO;
        }else{
            self.playBtn.hidden = YES;
        }

        // 获取用户信息
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:webinarInfo.join_info.avatar]];
        
        self.nicknameLab.text = webinarInfo.join_info.nickname;
                
        // 获取开播时间
        [self startToTime:webinarInfo.webinar.start_time];
        
        // 获取活动信息
        self.infoLab.text = @"简介";
        
        self.titleLab.text = webinarInfo.webinar.subject;
        
        self.webinarTitleLab.text = webinarInfo.webinar.subject;
        
        self.startTimeLab.text = webinarInfo.webinar.start_time;
        
        [self loadUrl:webinarInfo.webinar.introduction];
    }
    
    if (error) {
        VH_ShowToast(error.localizedDescription);
    }
}

// 播放器状态
- (void)statusDidChange:(VHPlayerState)state
{

    switch (state) {
        case VHPlayerStateStoped:
        {
            self.warmImg.hidden = NO;
        }
            break;
            
        case VHPlayerStateStarting:
        {
            self.warmImg.hidden = YES;

            [ProgressHud showLoading:@"正在加载" inView:self.warmVod];
        }
            break;
            
        case VHPlayerStatePlaying:
        {
            self.warmImg.hidden = YES;

            [ProgressHud hideLoadingInView:self.warmVod];
        }
            break;
            
        case VHPlayerStateStreamStoped:
        {
            self.warmImg.hidden = YES;
        }
            break;
            
        case VHPlayerStatePause:
        {
            self.warmImg.hidden = NO;
        }
            break;
            
        case VHPlayerStateComplete:
        {
            // 继续播放下一个 index + 1
            self.record_list_index = self.record_list_index + 1;

            // 判断是否播放完毕
            if (self.warmInfoModel.record_list.count == self.record_list_index){
                if (self.warmInfoModel.player_type == 1){
                    // 单次循环播放完毕后不在继续播放
                    self.warmImg.hidden = NO;
                    return;
                }else{
                    // 循环播放,播放完毕后,继续从零开始
                    self.record_list_index = 0;
                }
            }
            // 开始播放
            [self startWithPlayer];
        }
            break;

        default:
            break;
    }
}

// 播放错误
- (void)stoppedWithError:(NSError *)error
{
    VH_ShowToast(error.localizedDescription);
}

// 开始直播消息
- (void)warmInfoLiveStart
{
    VH_ShowToast(@"开始直播");
    
    // 状态文字
    self.subscribeLab.text = @"直播中";
}

// 结束直播消息
- (void)warmInfoLiveOver
{
    VH_ShowToast(@"结束直播");
    
    // 状态文字
    self.subscribeLab.text = @"结束";
}

// 房间消息
- (void)warmInfoReceiveRoomMessageData:(NSDictionary *)messageData
{
    VUI_Log(@"%@",messageData);
}

#pragma mark - 加载富文本
- (void)loadUrl:(NSString *)introduction
{
    [self.webView loadHTMLString:introduction baseURL:nil];
}
#pragma mark - 计算开播时间
- (void)startToTime:(NSString *)start_time
{
    // 要查询的字符串中的某个字符
    NSInteger count = [[start_time mutableCopy] replaceOccurrencesOfString:@":"
                                                            withString:@":"
                                                               options:NSLiteralSearch
                                                                 range:NSMakeRange(0, [start_time length])];
    if (count < 2) {
        start_time = [NSString stringWithFormat:@"%@:00",start_time];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * statrDate = [formatter dateFromString:start_time];
    NSDate * curDate = [NSDate date];
    NSTimeInterval aTimer = [statrDate timeIntervalSinceDate:curDate];
    
    if (aTimer <= 0) {
        [self updateToDay:0 hour:0 minute:0 second:0];
        [self destoryStratTimer];
        return;
    }
    
    // 赋值计时器的计时时间
    self.startTimer.timerInterval = aTimer;

    // 开始
    [self.startTimer resume];
}

#pragma mark - 刷新倒计时
- (void)updateToDay:(int)day hour:(int)hour minute:(int)minute second:(int)second
{
    dispatch_async(dispatch_get_main_queue(), ^{

        // 嘉宾开播准备的计时器
        NSString * dayStr = [NSString stringWithFormat:@"%02d",day];
        NSString * hourStr = [NSString stringWithFormat:@"%02d",hour];
        NSString * minuteStr = [NSString stringWithFormat:@"%02d",minute];
        NSString * secondStr = [NSString stringWithFormat:@"%02d",second];
        NSString * content = [NSString stringWithFormat:@"距离开播 %@天 %@时 %@分 %@秒",dayStr,hourStr,minuteStr,secondStr];

        NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:content];
        attText.yy_color = [UIColor colorWithHex:@"#262626"];
        attText.yy_font = FONT_Medium(28);
        [self upDateTextUI:@"距离开播" content:content attText:attText];
        [self upDateTextUI:@"天" content:content attText:attText];
        [self upDateTextUI:@"时" content:content attText:attText];
        [self upDateTextUI:@"分" content:content attText:attText];
        [self upDateTextUI:@"秒" content:content attText:attText];
        self.timeLab.attributedText = attText;
    });
}
- (void)upDateTextUI:(NSString *)str content:(NSString *)content attText:(NSMutableAttributedString *)attText
{
    [attText yy_setFont:FONT_FZZZ(10) range:[content rangeOfString:str]];
    [attText yy_setColor:[UIColor colorWithHex:@"#595959"] range:[content rangeOfString:str]];
}
#pragma mark - 销毁开播计时器
- (void)destoryStratTimer
{
    [_startTimer stop];
}

#pragma mark - 退出房间
- (void)backBtnClick {[self dismissViewControllerAnimated:YES completion:nil];}

#pragma mark - 懒加载

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor colorWithHex:@"#EDEDED"];
        [self.view addSubview:_topView];
    }
    return _topView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:BundleUIImage(@"关闭") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:_backBtn];
    }
    return _backBtn;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor colorWithHex:@"#222222"];
        _titleLab.font = FONT_Medium(16);
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self.topView addSubview:_titleLab];
    }
    return _titleLab;
}

- (UIImageView *)headImg {
    if (!_headImg) {
        _headImg = [[UIImageView alloc] init];
        _headImg.layer.masksToBounds = YES;
        _headImg.layer.cornerRadius = 24/2;
        [self.view addSubview:_headImg];
    }
    return _headImg;
}

- (UILabel *)nicknameLab {
    if (!_nicknameLab) {
        _nicknameLab = [[UILabel alloc] init];
        _nicknameLab.textColor = [UIColor colorWithHex:@"#595959"];
        _nicknameLab.font = FONT_FZZZ(14);
        [self.view addSubview:_nicknameLab];
    }
    return _nicknameLab;
}

- (UIView *)warmVod {
    if (!_warmVod) {
        _warmVod = [[UIView alloc] init];
        _warmVod.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_warmVod];
    }
    return _warmVod;
}

- (UIImageView *)warmImg {
    if (!_warmImg) {
        _warmImg = [[UIImageView alloc] init];
        _warmImg.userInteractionEnabled = YES;
        [_warmVod addSubview:_warmImg];
    }
    return _warmImg;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:BundleUIImage(@"vh_icon_play") forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(clickPlayBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_warmImg addSubview:_playBtn];
    }
    return _playBtn;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = [UIColor colorWithHex:@"#262626"];
        _timeLab.font = FONT_Medium(28);
        [self.view addSubview:_timeLab];
    }
    return _timeLab;
}

- (UIView *)lineView1
{
    if (!_lineView1) {
        _lineView1 = [UIView new];
        _lineView1.backgroundColor = [UIColor colorWithHex:@"#EDEDED"];
        [self.view addSubview:_lineView1];
    }return _lineView1;
}

- (UILabel *)infoLab {
    if (!_infoLab) {
        _infoLab = [[UILabel alloc] init];
        _infoLab.textColor = [UIColor colorWithHex:@"#262626"];
        _infoLab.font = FONT_FZZZ(12);
        [self.view addSubview:_infoLab];
    }
    return _infoLab;
}

- (UILabel *)subscribeLab {
    if (!_subscribeLab) {
        _subscribeLab = [[UILabel alloc] init];
        _subscribeLab.textColor = [UIColor colorWithHex:@"#FB3A32"];
        _subscribeLab.font = FONT_FZZZ(12);
        [self.view addSubview:_subscribeLab];
    }
    return _subscribeLab;
}

- (UIView *)lineView2
{
    if (!_lineView2) {
        _lineView2 = [UIView new];
        _lineView2.backgroundColor = [UIColor colorWithHex:@"#FB2626"];
        [self.view addSubview:_lineView2];
    }return _lineView2;
}

- (UIView *)lineView3
{
    if (!_lineView3) {
        _lineView3 = [UIView new];
        _lineView3.backgroundColor = [UIColor colorWithHex:@"#EDEDED"];
        [self.view addSubview:_lineView3];
    }return _lineView3;
}

- (UILabel *)webinarTitleLab {
    if (!_webinarTitleLab) {
        _webinarTitleLab = [[UILabel alloc] init];
        _webinarTitleLab.textColor = [UIColor colorWithHex:@"#262626"];
        _webinarTitleLab.font = FONT_Medium(16);
        _webinarTitleLab.preferredMaxLayoutWidth = self.view.width - 24;
        _webinarTitleLab.numberOfLines = 0;
        [self.view addSubview:_webinarTitleLab];
    }
    return _webinarTitleLab;
}

- (UILabel *)startTimeLab {
    if (!_startTimeLab) {
        _startTimeLab = [[UILabel alloc] init];
        _startTimeLab.textColor = [UIColor colorWithHex:@"#595959"];
        _startTimeLab.font = FONT_FZZZ(14);
        [self.view addSubview:_startTimeLab];
    }
    return _startTimeLab;
}


- (WKWebView*)webView {
    if (!_webView) {
        
        WKWebViewConfiguration *config          = [[WKWebViewConfiguration alloc]init];
        config.preferences                      = [WKPreferences new];
        config.preferences.minimumFontSize      = 10;
        config.preferences.javaScriptEnabled    = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
       
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0,self.view.width, 3000) configuration:config];
        if (@available(iOS 11.0, *))
        {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _webView.navigationDelegate = self;
        _webView.scrollView.delegate = self;
        _webView.UIDelegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (OMTimer *)startTimer
{
    if (!_startTimer) {
        _startTimer = [[OMTimer alloc] init];
        _startTimer.precision = 1000;
        _startTimer.isAscend = NO;
        _startTimer.isLocale = YES;
        @weakify(self);
        _startTimer.progressBlock = ^(OMTime *progress) {
            @strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateToDay:progress.residueDay hour:progress.residueHour minute:progress.residueMinute second:progress.residueSecond];
            });
        };
        _startTimer.completion = ^{
            @strongify(self);
            [self updateToDay:0 hour:0 minute:0 second:0];
            [self destoryStratTimer];
        };
    }return _startTimer;
}

@end
