//
//  WatchRTMPViewController.m
//  VHallSDKDemo
//
//  Created by developer_k on 16/4/13.
//  Copyright © 2016年 vhall. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "VHHalfWatchLiveVC_Nodelay.h"
#import "WatchLiveOnlineTableViewCell.h"
#import "WatchLiveChatTableViewCell.h"
#import "WatchLiveQATableViewCell.h"
#import "WatchLiveSurveyTableViewCell.h"
#import "WatchLiveLotteryViewController.h"
#import "VHKeyboardToolView.h"
#import <VHLiveSDK/VHallApi.h>
#import "SignView.h"
#import "BarrageRenderer.h"
#import "SZQuestionItem.h"
#import "VHQuestionCheckBox.h"
#import "MicCountDownView.h"
#import "VHinteractiveViewController.h"
#import "VHInvitationAlert.h"
#import "VHSurveyViewController.h"
#import "PubLishLiveVC_Normal.h"
#import "UIAlertController+ITTAdditionsUIModel.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import <VHInteractive/VHRoom.h>
#import "VHWatchNodelayVideoView.h"
#import "VHWatchNodelayDocumentView.h"
#import "AnnouncementView.h"
#import "VHQuestionnaireController.h"
#import "VHLotteryViewController.h"
#import "UIView+RedRot.h"

#import "VHDocFullScreenViewController.h"
#import "VHWatchLiveTimerView.h"

static AnnouncementView* announcementView = nil;

@interface VHHalfWatchLiveVC_Nodelay ()<VHRoomDelegate, VHallChatDelegate, VHallQAndADelegate, VHallLotteryDelegate,VHallSignDelegate,VHallSurveyDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,MicCountDownViewDelegate,VHInvitationAlertDelegate,VHSurveyViewControllerDelegate,VHKeyboardToolViewDelegate,VHDocumentDelegate,VHLotteryOpenDelegate, VHWatchNodelayDocumentViewDelegate,VHallTimerObjectDelegate>
{
    VHallChat         *_chat;       //聊天
    VHallQAndA        *_QA;         //问答
    VHallLottery      *_lottery;    //抽奖
    VHallSign         *_sign;       //签到
    VHallSurvey       *_survey;      //问卷
    WatchLiveLotteryViewController *_lotteryVC; //抽奖VC
    BOOL _isMute;          //是否静音
    BOOL _loadedChatHistoryList;  //是否请求过历史聊天记录
    int  _bufferCount;  //卡顿次数
    BOOL _isVr;     //是否支持vr
    BOOL _isRender; //
    BOOL _isQuestion_status; //问答开启状态
    BOOL _docShow;  //文档是否显示
    NSMutableDictionary *announcementContentDic;//公告内容
    NSMutableArray    *_QADataArray;  //问答数据源
    NSArray* _definitionList; //支持的分辨率
}
@property (nonatomic) VHDocFullScreenViewController *docFullScreen;
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UIButton *lotteryBtn; //抽奖按钮
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *docConentView;//文档view容器
@property (weak, nonatomic) IBOutlet VHWatchNodelayDocumentView *docAreaView; //文档显示区域
@property (weak, nonatomic) IBOutlet UILabel *liveTypeLabel;
@property(nonatomic,assign) BOOL connectedNetWork;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIButton *docBtn;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIButton *QABtn;
@property (nonatomic, strong) UIButton *currentSelectedButton;
@property (weak, nonatomic) IBOutlet UILabel *onlineLab; //在线人数
@property (weak, nonatomic) IBOutlet UILabel *pvLab; //活动热度

@property (weak, nonatomic) IBOutlet UITableView *chatView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic,assign) VHMovieVideoPlayMode playModelTemp;
@property (nonatomic,strong) VHKeyboardToolView * messageToolView;  //输入框
@property (weak, nonatomic) IBOutlet UIButton *sendCustomMsgBtn; //发送自定义消息按钮
@property (nonatomic, strong) NSArray *surveyResultArray;//问卷结果
@property (nonatomic, strong) NSMutableArray    *chatDataArray;
@property (weak, nonatomic) IBOutlet UIButton *chatTextFieldBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoViewHeight; //视频容器高

@property (nonatomic, strong) MicCountDownView *countDowwnView;
@property (nonatomic, strong) VHInvitationAlert *invitationAlertView;

//v4.0.0 新版问卷功能类
@property (nonatomic, strong) VHSurveyViewController *surveyController;

@property (nonatomic, assign) NSInteger chatListPage; //聊天记录页码，默认1

/** 互动SDK (用于无延迟直播) */
@property (nonatomic, strong) VHRoom *inavRoom;
@property (nonatomic, strong) VHWatchNodelayVideoView *videoView;  //视频容器
@property (weak, nonatomic) IBOutlet UIButton *questionName;
@property (nonatomic,copy) NSString *questionDesc;//问答名称
@property (nonatomic,copy) NSString *questionnaireDesc;//问卷名称
@property (nonatomic, strong) UIButton * qetBtn;
@property (nonatomic) BOOL  questionStatus;
@property (nonatomic) NSInteger  selectIndex;
/// 抽奖
@property (nonatomic) UIButton * lotteryIconBtn;

/// 计时器类
@property (nonatomic, strong) VHallTimerObject * timerObject;
/// 计时器按钮
@property (nonatomic, strong) UIButton * timerIconBtn;
/// 计时器
@property (nonatomic, strong) VHWatchLiveTimerView * timerView;

@end

@implementation VHHalfWatchLiveVC_Nodelay

#pragma mark - Lifecycle Method
- (id)init
{
    self = LoadVCNibName;
    if (self) {
        [self initDatas];
    }
    return self;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化views
    [self initViews];
    // 添加问卷
    [self addquestionnaireView];
    // 添加抽奖
    [self addLotteryView];
    // 添加计时器按钮
    [self addTimerBtn];
    // 抽奖成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lotterySuccess) name:@"take_award_succeed" object:nil];
}
- (void)lotterySuccess{
    [self lotteryLogic:NO];
}
- (void)addLotteryView{
    self.lotteryIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.lotteryIconBtn setImage:BundleUIImage(@"icon_lottery") forState:UIControlStateNormal];
    self.lotteryIconBtn.contentMode = UIViewContentModeScaleAspectFit;
    [self.lotteryIconBtn addTarget:self action:@selector(lotteryAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.lotteryIconBtn];
    [self.lotteryIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(90);
        make.width.height.mas_equalTo(36);
    }];
}
- (void)lotteryAction{
    [self lotteryLogic:YES];
}
- (void)addTimerBtn
{
    [self.timerIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(_lotteryIconBtn.mas_bottom).offset(5);
        make.width.height.mas_equalTo(36);
    }];
}
#pragma mark -- 获取抽奖历史
- (void)lotteryLogic:(BOOL)isAction{
    //抽奖历史记录
    [VHWebinarBaseInfo fetchLotteryListShowAll:2 webinarId:self.roomId success:^(VHLotteryListModel * _Nonnull listModel) {
        if (listModel.listModel.count == 0) {
            if (isAction) {
                VH_ShowToast(@"当前没有中奖");
            }
        }else{
            self.lotteryIconBtn.hidden = NO;
            [self isHaveLotteryRedRot:listModel.listModel action:isAction];
        }
        
    } fail:^(NSError * _Nonnull error) {
        VH_ShowToast(error.localizedDescription);
    }];
}
// 渲染UI 判断我自己是否中奖并且是否领奖
- (void)isHaveLotteryRedRot:(NSArray <VHLotteryModel *>*)listArr action:(BOOL)action{
    BOOL isHaveRedDot = NO;//是否显示红点
    for (int i = 0; i < listArr.count; i++) {
        VHLotteryModel *model = listArr[i];
        //需要领奖
        if (model.take_award == NO && model.win == YES) {
            isHaveRedDot = YES;
        }
    }
    // 显示小红点
    if (isHaveRedDot) {
        [self.lotteryIconBtn showBadge];
    }else{
        [self.lotteryIconBtn hidenBadge];
    }
    
    // 判断展示填写信息界面,还是展示中奖列表
    if (action) {
        if (listArr.count == 1) {
            VHLotteryModel *model = listArr[0];
            if (model.win == NO) {
                VH_ShowToast(@"当前奖品不需要领奖");
                return;
            }
            if (model.take_award == YES) {
                VH_ShowToast(@"当前奖品已经领过奖");
                return;
            }
            [self lotteryBtnClick:self.lotteryBtn];
            [self openOneLotteryModel:model];
        }else{
            ///显示抽奖历史
            [self lotteryBtnClick:self.lotteryBtn];
            [self presentLottery:listArr];
        }
    }
}
- (void)openOneLotteryModel:(VHLotteryModel *)model{
    VHallEndLotteryModel *endModel = [[VHallEndLotteryModel alloc] init];
    endModel.is_new = YES;
    endModel.lottery_id = model.lottery_id;
    endModel.need_take_award = model.need_take_award;
    endModel.isWin = model.win;
    endModel.publish_winner = model.publish_winner;
    [self lotteryOpen:endModel];
}
- (void)presentLottery:(NSArray<VHLotteryModel *> *)lotteryArr{
    VHLotteryViewController *lottery = [[VHLotteryViewController alloc] init];
    lottery.lotteryList = lotteryArr;
    lottery.delegate = self;
    [self presentViewController:lottery animated:YES completion:nil];
}
- (void)lotteryOpen:(VHallEndLotteryModel *)endLotteryModel{
    if (_lotteryVC) {
        [_showView removeAllSubviews];
        _lotteryVC = nil;
    }
    _lotteryVC = [[WatchLiveLotteryViewController alloc] init];
    _lotteryVC.lottery = _lottery;
    _lotteryVC.view.frame = _showView.bounds;
    [_showView addSubview:_lotteryVC.view];
    [_lotteryVC new_lottery_UI:endLotteryModel];
    [self lotteryBtnClick:self.lotteryBtn];
}
#pragma mark - 添加问卷
- (UIButton *)qetBtn
{
    if (!_qetBtn) {
        _qetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qetBtn setHidden:YES];
        [_qetBtn setContentMode:UIViewContentModeScaleAspectFit];
        [_qetBtn setImage:BundleUIImage(@"wenjuan_top") forState:UIControlStateNormal];
        [_qetBtn addTarget:self action:@selector(questionnaireAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_qetBtn];
    }return _qetBtn;
}
- (void)addquestionnaireView{
    [self.qetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.offset(0);
        make.width.height.mas_equalTo(36);
    }];
}
- (void)questionnaireAction{
    [self questionnaireLogic:YES];
}
#pragma mark --- 问卷的逻辑 isAction = YES 走action NO 走核验
- (void)questionnaireLogic:(BOOL)isAction{
    ///获取问卷列表
    [VHWebinarBaseInfo fetchSurveyListWebinarId:self.roomId roomId:self.inavRoom.roomInfo.webinarInfoData.interact.room_id switchId:self.inavRoom.roomInfo.webinarInfoData.data_switch.switch_id success:^(VHSurveyListModel * listModel) {
        if (listModel.listModel.count == 0) {
            self.qetBtn.hidden = YES;
        }else{
            self.qetBtn.hidden = NO;
            [self isHaveRedRot:listModel.listModel action:isAction];
        }
    } fail:^(NSError * _Nonnull error) {
        VH_ShowToast(error.localizedDescription);
    }];
}

- (void)isHaveRedRot:(NSArray <VHSurveyModel *>*)listArr action:(BOOL)action{
    BOOL isHaveRedDot = NO;//是否显示红点
    NSInteger tag = 0;
    NSInteger index = UINT_MAX;
    for (int i = 0; i < listArr.count; i++) {
        VHSurveyModel *model = listArr[i];
        if (model.is_answered == NO) {
            isHaveRedDot = YES;
            tag++;
            if (tag == 1) {
                index = i;//标记第一个未填写的
            }
        }
    }
    if (!action) {
        //NO 走核验 YES 走action操作
        return;
    }
    if (isHaveRedDot == NO) {
        //吐丝提示
        VH_ShowToast(@"已提交成功感谢参与");
        return;
    }
    if (index != UINT_MAX && tag == 1) {
        //有且仅有一个未填写
        [self openOne:index array:listArr];
    }else if (index != UINT_MAX && tag > 1){
        //两个未填写，打开新写的页面
        [self openSurveyNewController:listArr];
    }
}
- (void)openOne:(NSInteger)index array:(NSArray <VHSurveyModel *>*)modelArr{
    if (!_surveyController) {
        _surveyController = [[VHSurveyViewController alloc] init];
        _surveyController.delegate = self;
    }
    _surveyController.view.frame = self.view.bounds;
    _surveyController.url = [modelArr[index] openLink];
    [self.view addSubview:_surveyController.view];
}
- (void)openSurveyNewController:(NSArray <VHSurveyModel *>*)modelArr{
    VHQuestionnaireController *questionare = [[VHQuestionnaireController alloc] init];
    questionare.surveyList = modelArr;
    [self presentViewController:questionare animated:YES completion:nil];
}
- (void)receivedSucceed:(NSString *)surveyid surveyAccountId:(NSString *)accountid{
    if ([accountid isEqualToString:self.inavRoom.roomInfo.data[@"join_info"][@"third_party_user_id"]]) {
        [self questionnaireLogic:NO];//不跳转，只核验
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self enterInvRoom];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.inavRoom leaveRoom];
    [_videoView removeAllRenderView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(announcementView && !announcementView.hidden) {
        announcementView.content = announcementView.content;
    }
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [SignView layoutView:self.view.bounds];
}

#pragma mark - 切换前后台
//前台
- (void)didBecomeActive
{
    if (announcementContentDic != nil)
    {
        NSString *content = [announcementContentDic objectForKey:@"announceContent"];
        NSString *time = [announcementContentDic objectForKey:@"announceTime"];
        if(announcementView != nil) {
            [announcementView setContent:[content stringByAppendingString:time]];
        }
    }
    
    // 获取计时器
    [self requestInteractsTimerInfo];
}
//后台
- (void)appEnterBackground {
    // 计时器
    [_timerView dismiss];
}

- (void)dealloc
{
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
        _lotteryVC = nil;
    }
    
    if (_sign) {
        _sign.delegate = nil;
    }
    if (_survey) {
        _survey.delegate = nil;
    }
    //允许自动锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    VHLog(@"%@ dealloc",[[self class] description]);
}


#pragma mark - Private Method

-(void)initDatas {
    _chatDataArray = [NSMutableArray array];
    _QADataArray = [NSMutableArray array];
    
    _chat = [[VHallChat alloc] initWithObject:self.inavRoom];
    _chat.delegate = self;
    _QA = [[VHallQAndA alloc] initWithObject:self.inavRoom];
    _QA.delegate = self;
    _lottery = [[VHallLottery alloc] initWithObject:self.inavRoom];
    _lottery.delegate = self;
    _sign = [[VHallSign alloc] initWithObject:self.inavRoom];
    _sign.delegate = self;
    _survey = [[VHallSurvey alloc] initWithObject:self.inavRoom];
    _survey.delegate = self;
}

- (void)initViews
{
    self.videoViewHeight.constant = VHScreenWidth * 9 /16.0;
    
    [self configChatViewRefreshWithBtn:self.chatBtn];
    
    _chatView.tableFooterView = [[UIView alloc] init];
    _chatView.estimatedRowHeight = 80;
    _chatView.estimatedSectionFooterHeight = 0;
    _chatView.estimatedSectionHeaderHeight = 0;

    //阻止设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self registerLiveNotification];

    self.view.backgroundColor = [UIColor blackColor];

    
    _docConentView.hidden = YES;
    
    //申请上麦视图
    _countDowwnView = [[MicCountDownView alloc] initWithFrame:CGRectMake(VHScreenWidth-48, VHScreenHeight-200, 40, 40)];
    [_countDowwnView.button addTarget:self action:@selector(micUpClick:) forControlEvents:UIControlEventTouchUpInside];
    _countDowwnView.delegate = self;
    [_countDowwnView hiddenCountView]; //默认隐藏上麦按钮
    [self.view addSubview:_countDowwnView];
    
    self.currentSelectedButton = self.chatBtn;
    
    [self.backView insertSubview:self.videoView atIndex:0];
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backView);
    }];
}

//进入互动房间
- (void)enterInvRoom {
    [self.inavRoom enterRoomWithParams:[self playParam]];
}


//更新在线人数
- (void)updateShowOnlineNum {
    if(self.inavRoom.roomInfo.online_show) {
        self.onlineLab.text = [NSString stringWithFormat:@"在线人数（真实人数：%zd，虚拟人数：%zd）",self.inavRoom.roomInfo.online_real,self.inavRoom.roomInfo.online_virtual];
    }else {
        self.onlineLab.text = @"";
    }
    
    if(self.inavRoom.roomInfo.pv_show) {
        self.pvLab.text = [NSString stringWithFormat:@"活动热度（真实热度：%zd，虚拟热度：%zd）",self.inavRoom.roomInfo.pv_real,self.inavRoom.roomInfo.pv_virtual];
    }else {
        self.pvLab.text = @"";
    }
}


//tableView刷新设置
- (void)configChatViewRefreshWithBtn:(UIButton *)button {
    
    if(button == self.chatBtn) { //聊天
        __weak typeof(self) weakSelf = self;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadHistoryChatWithPage:weakSelf.chatListPage + 1];
        }];
        [header setTitle:@"下拉加载更多" forState:MJRefreshStateIdle];
        [header setTitle:@"松开立即加载更多" forState:MJRefreshStatePulling];
        [header setTitle:@"暂无更多" forState:MJRefreshStateNoMoreData];
        [header setTitle:@"正在加载更多的数据中..." forState:MJRefreshStateRefreshing];
        header.lastUpdatedTimeLabel.hidden = YES;
        self.chatView.mj_header = header;

        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadHistoryChatWithPage:1];
        }];
        [footer setTitle:@"上拉刷新" forState:MJRefreshStateIdle];
        [footer setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
        [footer setTitle:@"正在刷新数据中..." forState:MJRefreshStateRefreshing];
        self.chatView.mj_footer = footer;
    }else if(button == self.QABtn) { //问答
        __weak typeof(self) weakSelf = self;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadQAListNewData];
        }];
        self.chatView.mj_header = header;
        self.chatView.mj_footer = nil;
    }
}


//被踢出
- (void)kickOutAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您已被踢出房间" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        UIViewController *vc = self;
        Class homeVcClass = NSClassFromString(@"VHHomeViewController");
        while (![vc isKindOfClass:homeVcClass]) {
            vc = vc.presentingViewController;
        }
        [vc dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:NO completion:nil];
}


#pragma mark - 手势
//音量调节
- (void)handlePan:(UIPanGestureRecognizer*)pan
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


#pragma mark - 注册通知
- (void)registerLiveNotification
{
    //已经进入活跃状态的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive)name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    //监听耳机的插拔
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(outputDeviceChanged:)name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
}

#pragma mark - 上麦/取消上麦
- (void)micUpClick:(UIButton *)sender {
    
    if(_chat.isAllSpeakBlocked)
    {
        VH_ShowToast(@"已开启全体禁言");
        return;
    }

    if(_chat.isSpeakBlocked)
    {
        VH_ShowToast(@"您已被禁言");
        return;
    }

    sender.selected = !sender.selected;
    
    __weak typeof(self) weakSelf = self;
    if (sender.selected) {
        [VHHelpTool getMediaAccess:^(BOOL videoAccess, BOOL audioAcess) {
            [self.inavRoom applySuccess:^{
                VH_ShowToast(@"申请上麦成功");
                //开启上麦倒计时
                [weakSelf.countDowwnView countdDown:30];
            } fail:^(NSError *error) {
                NSString *msg = [NSString stringWithFormat:@"申请上麦失败：%@",error.description];
                VH_ShowToast(msg);
            }];
        }];
    } else {
        [self.inavRoom cancelApplySuccess:^{
            VH_ShowToast(@"已取消申请");
            //停止倒计时
            [weakSelf.countDowwnView stopCountDown];
        } fail:^(NSError *error) {
            NSString *msg = [NSString stringWithFormat:@"取消上麦失败：%@",error.description];
            VH_ShowToast(msg);
        }];
    }
}


#pragma mark - 返回按钮点击
- (IBAction)closeBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 详情
- (IBAction)detailsButtonClick:(UIButton *)sender {
    self.selectIndex = 4;
    [self.view endEditing:YES];
    self.docConentView.hidden = YES;
    self.chatView.hidden = YES;
    self.bottomView.hidden = YES;
    _lotteryVC.view.hidden = YES;
    self.detailBtn.selected = YES;
    self.docBtn.selected = self.chatBtn.selected = self.QABtn.selected = self.lotteryBtn.selected = NO;
    self.currentSelectedButton = sender;
}

#pragma mark - 文档
- (IBAction)textButtonClick:(UIButton *)sender {
    self.selectIndex = 1;
    [self.view endEditing:YES];
    self.docConentView.hidden = NO;
    _lotteryVC.view.hidden = YES;
    self.chatView.hidden = YES;
    self.bottomView.hidden = YES;
    
    self.detailBtn.selected = self.chatBtn.selected = self.QABtn.selected = self.lotteryBtn.selected = NO;
    self.docBtn.selected = YES;
    
    self.currentSelectedButton = sender;
}

/// 主持人切换了文档(文档全屏需要关注)
- (void)nodelayDidChangeDocument {
    if(self.docFullScreen && [self.docFullScreen presentingViewController] == self) {
        self.docFullScreen.docView = self.docAreaView;
    } else {
        [self.docAreaView setFrame:self.docConentView.bounds];
    }
    
}


#pragma mark - 聊天
- (IBAction)chatButtonClick:(UIButton *)sender {
    self.selectIndex = 0;
    [self.view endEditing:YES];
    [self configChatViewRefreshWithBtn:sender];
    
    self.docConentView.hidden = YES;
    _lotteryVC.view.hidden = YES;
    self.chatView.hidden = NO;
    self.sendCustomMsgBtn.hidden = NO;
    self.bottomView.hidden = NO;
    self.detailBtn.selected = self.docBtn.selected = self.QABtn.selected = self.lotteryBtn.selected = NO;
    self.chatBtn.selected = YES;
    self.currentSelectedButton = sender;
    [self.chatTextFieldBtn setTitle:@"  我来说两句" forState:UIControlStateNormal];
    
    [self reloadDataWithDataSource:_chatDataArray animated:NO];
    
    if (!_loadedChatHistoryList)
    {
        [self loadHistoryChatWithPage:1];
    }
}

//获取历史聊天记录
- (void)loadHistoryChatWithPage:(NSInteger)page {
    __weak typeof(self) weakSelf = self;
    NSString * msg_id = @"";
    if (page > 1 && self.chatDataArray.count > 0) {
        VHallChatModel * msgFirstModel = [self.chatDataArray firstObject];
        msg_id = msgFirstModel.msg_id;
    }else{
        msg_id = @"";
    }
    [_chat getInteractsChatGetListWithMsg_id:msg_id page_num:page page_size:10 start_time:nil is_role:0 anchor_path:nil success:^(NSArray<VHallChatModel *> *msgs) {
        if(page == 1) {
            weakSelf.chatDataArray = [NSMutableArray arrayWithArray:msgs];
            weakSelf.chatListPage = 1;
            
            [weakSelf reloadDataWithDataSource:weakSelf.chatDataArray animated:YES];
            
            _loadedChatHistoryList = YES;
        }else {
            if (msgs.count > 0) {
                weakSelf.chatListPage ++;
                
                //防止获取的聊天记录与实时消息重复，需要过滤
                NSMutableArray *mutaArr = [NSMutableArray arrayWithArray:msgs];
                for(VHallChatModel *message in weakSelf.chatDataArray) {
                    for(VHallChatModel *newMessage in mutaArr.reverseObjectEnumerator) {
                        if([newMessage.msg_id isEqualToString:message.msg_id]) {
                            [mutaArr removeObject:newMessage];
                        }
                    }
                }
                
                NSRange range = NSMakeRange(0,mutaArr.count);
                [weakSelf.chatDataArray insertObjects:mutaArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
            }
        }
        [weakSelf.chatView reloadData];
        [weakSelf.chatView.mj_header endRefreshing];
        [weakSelf.chatView.mj_footer endRefreshing];
    } failed:^(NSDictionary *failedData) {
        NSString* errorInfo = [NSString stringWithFormat:@"%@---%@", failedData[@"content"], failedData[@"code"]];
        NSLog(@"获取历史聊天记录失败：%@",errorInfo);
        [weakSelf.chatView.mj_footer endRefreshing];
        [weakSelf.chatView.mj_header endRefreshing];
    }];
}

#pragma mark - 我来说两句
- (IBAction)sendChatBtnClick:(id)sender
{
    if (self.selectIndex == 2) {
        [self questionAnswer];//问答新逻辑
        return;
    }
    if(_chat.isAllSpeakBlocked)
    {
        VH_ShowToast(@"已开启全体禁言");
        return;
    }

    if(_chat.isSpeakBlocked)
    {
        VH_ShowToast(@"您已被禁言");
        return;
    }
    
    [self.messageToolView becomeFirstResponder];
}
- (void)questionAnswer{
    if(_chat.isAllSpeakBlocked)
    {
        if (!self.questionStatus) {
//            NSString *tip = [NSString stringWithFormat:@"已开启全体禁言且关闭%@",self.questionDesc];
            VH_ShowToast(@"已开启全体禁言");
            return;
        }else{
//            NSString *tip = [NSString stringWithFormat:@"已开启全体禁言且打开%@",self.questionDesc];
//            VH_ShowToast(tip);
        }
    }

    if(_chat.isSpeakBlocked)
    {
        if (!self.questionStatus) {
            VH_ShowToast(@"您已被禁言");
            return;
        }
    }
    [self.messageToolView becomeFirstResponder];
}
- (VHKeyboardToolView *)messageToolView {
    if (!_messageToolView)
    {
        _messageToolView = [[VHKeyboardToolView alloc] init];
        _messageToolView.delegate = self;
        [self.view addSubview:_messageToolView];
    }
    return _messageToolView;
}

#pragma mark - VHKeyboardToolViewDelegate
/*! 发送按钮事件回调*/
- (void)keyboardToolView:(VHKeyboardToolView *)view sendText:(NSString *)text;
{
    if ([text isEqualToString:@""]) {
        VH_ShowToast(@"发送的消息不能为空");
        return;
    }
    __weak typeof(self) weakSelf = self;
    //发送聊天
    if (self.currentSelectedButton == _chatBtn) {
        [_chat sendMsg:text success:^{
            NSLog(@"发送聊天成功：%@",text);
        } failed:^(NSDictionary *failedData) {
            
            NSString *tipMsg = [NSString stringWithFormat:@"%@",failedData[@"content"]];
            VH_ShowToast(tipMsg);
        }];
        
        return;
    }
    //发送问答提问
    if (self.currentSelectedButton == _QABtn) {
        
        [_QA sendMsg:text success:^{
         
            
        } failed:^(NSDictionary *failedData) {
            
            NSString* tipMsg = [NSString stringWithFormat:@"%@",failedData[@"content"]];
            VH_ShowToast(tipMsg);
        }];
        
        return;
    }
}

- (IBAction)onClickFullScreen:(UIButton *)sender {
    self.docFullScreen = [VHDocFullScreenViewController new];
    self.docFullScreen.docView = self.docAreaView;
    __weak typeof(self) wself = self;
    self.docFullScreen.handleDismiss = ^(UIView * _Nonnull docView) {
        __strong typeof(wself) self = wself;
        if(docView!=nil){
            [docView setFrame:self.docConentView.bounds];
            [self.docConentView addSubview:docView];
            [self.docConentView sendSubviewToBack:docView];
        }
    };
    [self presentViewController:self.docFullScreen animated:NO completion:nil];
}
#pragma mark - 发送自定义消息
- (IBAction)customMsgBtnClick:(id)sender
{
    NSMutableDictionary * json = [NSMutableDictionary dictionary];
    json[@"key"] = @"value";
    json[@"num"] = @"0.12";
    json[@"name"] = @"小明";
    NSString * jsonStr = [UIModelTools jsonStringWithObject:json];
//    NSString *jsonStr = @"{\"key\":\"value\",\"name\":\"小明\",\"phone\":18300001111}";
    __weak typeof(self) wf = self;
    [_chat sendCustomMsg:jsonStr success:^{
        VH_ShowToast(@"发送成功");
    } failed:^(NSDictionary *failedData) {
        
        NSString* tipMsg = [NSString stringWithFormat:@"%@",failedData[@"content"]];
        VH_ShowToast(tipMsg);
    }];
    
}


#pragma mark - 问答
- (IBAction)QAButtonClick:(UIButton *)sender {
    self.selectIndex = 2;
    if (!_isQuestion_status) {
        VH_ShowToast(@"主播关闭了问答");
        return;
    }
    
    [self.view endEditing:YES];
    
    [self configChatViewRefreshWithBtn:sender];

    self.docConentView.hidden = YES;
    self.sendCustomMsgBtn.hidden = YES;
    _lotteryVC.view.hidden = YES;
    self.chatView.hidden = NO;
    self.bottomView.hidden = NO;
    self.lotteryBtn.selected = self.chatBtn.selected = self.docBtn.selected = self.detailBtn.selected = NO;
    self.QABtn.selected = YES;
    self.currentSelectedButton = sender;
    [self.chatTextFieldBtn setTitle:@"  发起提问" forState:UIControlStateNormal];
    
    [self reloadDataWithDataSource:_QADataArray animated:NO];

    if(_QADataArray.count == 0) {
        [self loadQAListNewData];
    }
}


//获取问答列表
- (void)loadQAListNewData {
    __weak typeof(self) weakself = self;
    [_QA getQAndAHistoryWithType:YES success:^(NSArray<VHallQAModel *> *msgs) {
        _QADataArray = [NSMutableArray array];
        for (VHallQAModel * qaModel in msgs) {
            [_QADataArray addObject:qaModel.questionModel];

            if (qaModel.answerModels.count > 0) {
                [_QADataArray addObjectsFromArray:qaModel.answerModels];
            }
        }
        if (_QABtn.selected) {
            [self reloadDataWithDataSource:_QADataArray animated:YES];
        }
        [weakself.chatView.mj_header endRefreshing];
    } failed:^(NSDictionary *failedData) {
        NSString* tipMsg = [NSString stringWithFormat:@"%@",failedData[@"content"]];
        VH_ShowToast(tipMsg);
        [weakself.chatView.mj_header endRefreshing];
    }];
}

- (void)reloadDataWithDataSource:(NSArray *)dataSource animated:(BOOL)animated{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_chatView reloadData];
        if(dataSource.count > 0 && _chatView.contentSize.height>0) {
            [_chatView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:dataSource.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:animated];
        }
    });
}


#pragma mark - 抽奖
//抽奖按钮点击
- (IBAction)lotteryBtnClick:(UIButton *)sender {
    self.selectIndex = 3;
    self.docConentView.hidden = YES;
    self.chatView.hidden = YES;
    self.bottomView.hidden = YES;
    _lotteryVC.view.hidden = NO;
    
    self.detailBtn.selected = self.docBtn.selected = self.QABtn.selected = self.chatBtn.selected = NO;
    self.lotteryBtn.selected = YES;
    self.currentSelectedButton = sender;
}


#pragma mark - tableView 代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
  __weak  typeof(self) weakSelf =self;
    if (_chatBtn.selected)
    {
        id model = [_chatDataArray objectAtIndex:indexPath.row];
        if ([model isKindOfClass:[VHallOnlineStateModel class]]) //上下线消息
        {
            static NSString * indetify = @"WatchLiveOnlineCell";
            cell = [tableView dequeueReusableCellWithIdentifier:indetify];
            if (!cell) {
                cell = [[WatchLiveOnlineTableViewCell alloc]init];
            }
            ((WatchLiveOnlineTableViewCell *)cell).model = model;
        } else if([model isKindOfClass:[VHallSurveyModel class]]) //问卷消息
        {
            static NSString * indetify = @"WatchLiveSurveyTableViewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:indetify];
            if (!cell) {
                cell = [[WatchLiveSurveyTableViewCell alloc]init];
            }
            ((WatchLiveSurveyTableViewCell *)cell).model = model;
            ((WatchLiveSurveyTableViewCell *)cell).clickSurveyItem=^(VHallSurveyModel *model) {
                [weakSelf performSelector:@selector(clickSurvey:) withObject:model];
            };
        }
        else //聊天消息
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
    {//问答消息
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
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:qaIndetify];
        }
    }
    return cell;
}



- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    if (_chatBtn.selected) {
    
        return _chatDataArray.count;
    }
    
    if (_QABtn.selected) {
        return _QADataArray.count;
    }
    return 0;
}

#pragma mark - VHInvitationAlertDelegate
- (void)alert:(VHInvitationAlert *)alert clickAtIndex:(NSInteger)index
{
    [alert removeFromSuperview];
    alert = nil;
    if(index == 1){ //同意主持人的邀请
        ///先校验权限再上麦进入互动
        [VHHelpTool getMediaAccess:^(BOOL videoAccess, BOOL audioAcess) {
            [self.inavRoom agreeInviteSuccess:^{
                [self presentInteractiveVC];
            } fail:^(NSError *error) {
                VH_ShowToast(error.localizedDescription);
            }];
        }];
    } else if(index == 0) { //拒绝主持人的邀请
        [self.inavRoom rejectInviteSuccess:^{
            VH_ShowToast(@"已拒绝");
        } fail:^(NSError *error) {
            VH_ShowToast(error.localizedDescription);
        }];
    }
}

//弹出互动页面
- (void)presentInteractiveVC {
    [_countDowwnView stopCountDown];
    //进入互动
    VHinteractiveViewController *controller = [[VHinteractiveViewController alloc] init];
    controller.joinRoomPrams = [self playParam];
    controller.inav_num = self.inavRoom.roomInfo.inav_num;
    controller.inavBeautifyFilterEnable = self.interactBeautifyEnable;
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:controller animated:YES completion:nil];
}


#pragma mark - 抽奖相关
//-----------VHallLotteryDelegate-------------
//开始抽奖
- (void)startLottery:(VHallStartLotteryModel *)msg
{
    if (_lotteryVC) {
        [_lotteryVC.view removeFromSuperview];
        [_lotteryVC removeFromParentViewController];
        _lotteryVC = nil;
    }
    
    _lotteryVC = [[WatchLiveLotteryViewController alloc] init];
    _lotteryVC.lottery = _lottery;
    _lotteryVC.startLotteryModel = msg;
    [_showView addSubview:_lotteryVC.view];
    [_lotteryVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_showView);
    }];
    
    [self lotteryBtnClick:self.lotteryBtn];
}

//结束抽奖
- (void)endLottery:(VHallEndLotteryModel *)msg
{
    if (!_lotteryVC) {
        _lotteryVC = [[WatchLiveLotteryViewController alloc] init];
        _lotteryVC.lottery = _lottery;
        [_showView addSubview:_lotteryVC.view];
        [_lotteryVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_showView);
        }];
    }
    _lotteryVC.endLotteryModel = msg;
    [self lotteryBtnClick:self.lotteryBtn];
    //刷新icon小红点
    [self lotteryLogic:NO];
}


#pragma mark - IM消息相关
- (void)reciveOnlineMsg:(NSArray <VHallOnlineStateModel *> *)msgs
{
    [self reloadDataWithMsg:msgs];
}

- (void)reciveChatMsg:(NSArray <VHallChatModel *> *)msgs
{
    //过滤私聊
    NSString *currentUserId = self.inavRoom.roomInfo.data[@"join_info"][@"third_party_user_id"];
    NSArray *msgArr = [VHHelpTool filterPrivateMsgCurrentUserId:currentUserId origin:msgs isFilter:YES half:YES];
    [self reloadDataWithMsg:msgArr];
}

- (void)reciveCustomMsg:(NSArray <VHallCustomMsgModel *> *)msgs
{
    VHallCustomMsgModel *msgModel = msgs[0];
    if (msgModel.eventType == ChatCustomType_EditRole) {
        switch ([msgModel.edit_role_type intValue]) {
            case 1:
                VH_MB_HOST = msgModel.edit_role_name;
                break;
            case 4:
                VH_MB_GUEST = msgModel.edit_role_name;
                break;
            case 3:
                VH_MB_ASSIST = msgModel.edit_role_name;
                break;
            default:
                break;
        }
        return;
    }
    [self reloadDataWithMsg:msgs];
}

- (void)forbidChat:(BOOL) forbidChat
{
    VH_ShowToast(forbidChat?@"您已被禁言":@"您已被取消禁言");
}

- (void)allForbidChat:(BOOL) allForbidChat
{
    VH_ShowToast(allForbidChat?@"已开启全体禁言":@"已取消全体禁言");
}
- (void)questionStatus:(BOOL)questionStatus{
    //可提问状态
    self.questionStatus = questionStatus;
}
//-----------聊天私有方法------------
- (void)reloadDataWithMsg:(NSArray *)msgs {
    if (msgs.count == 0) {
        return;
    }
    [_chatDataArray addObjectsFromArray:msgs];
    if (_chatBtn.selected) {
        [self reloadDataWithDataSource:_chatDataArray animated:YES];
    }
}

#pragma mark - 问答相关
//----------------VHallQAndADelegate------------------
//主播开启问答
- (void)vhallQAndADidOpened:(VHallQAndA *)QA
{
    self.questionDesc = QA.question_name;
    [self.questionName setTitle:self.questionDesc forState:UIControlStateNormal];
    NSString *close = [NSString stringWithFormat:@"主持人开启了%@",self.questionDesc];
    VH_ShowToast(close);
    _isQuestion_status = YES;
}

//主播关闭问答
- (void)vhallQAndADidClosed:(VHallQAndA *)QA
{
    NSString *close = [NSString stringWithFormat:@"主持人关闭了%@",self.questionDesc];
    VH_ShowToast(close);
    [self chatButtonClick:self.chatBtn];
    _isQuestion_status = NO;
}

//收到问答
- (void)reciveQAMsg:(NSArray <VHallQAModel *> *)msgs {
    for (VHallQAModel *qaModel in msgs) {
        //添加问题
        [_QADataArray addObject:qaModel.questionModel];
        if(qaModel.answerModels.count > 0) { //如果有回答
            BOOL showAnswer = NO; //是否有可显示的回答
            for(VHallAnswerModel *answer in qaModel.answerModels) {
                if(answer.is_open == YES || [qaModel.questionModel.join_id isEqualToString:self.inavRoom.roomInfo.join_id]) { // 公开的回答 || 私密回答自己的提问
                    [_QADataArray addObject:answer];
                    showAnswer = YES;
                }
            }
            if(showAnswer == NO) { //如果没有可显示的回答，则不添加问题
                [_QADataArray removeObject:qaModel.questionModel];
            }
        }
    }

    if (_QABtn.selected) {
        [self reloadDataWithDataSource:_QADataArray animated:YES];
    }
}

#pragma mark - 签到相关
//--------------VHallSignDelegate----------------
//签到开始的回调
- (void)startSign {
    __weak typeof(self) weakSelf = self;
    [SignView showSignWithTitle:_sign.title btnClickedBlock:^BOOL{
        [weakSelf SignBtnClicked];
        return NO;
    }];
}

//签到倒计时的回调
- (void)signRemainingTime:(NSTimeInterval)remainingTime
{
    NSLog(@"距结束%d秒",(int)remainingTime);
    [SignView remainingTime:remainingTime];
}

//签到结束的回调
- (void)stopSign
{
    [SignView close];
    VH_ShowToast(@"签到结束");
}

//----------------签到私有方法-----------------
//请求开始签到接口
- (void)SignBtnClicked {
    __weak typeof(self) weakSelf = self;
    [_sign signSuccessIsStop:YES success:^{
        [SignView close];
        VH_ShowToast(@"签到成功");
    } failed:^(NSDictionary *failedData) {
        NSString *string = [NSString stringWithFormat:@"%@,错误码%@",failedData[@"content"],failedData[@"code"]];
        VH_ShowToast(string);
        [_sign cancelSign];
        [SignView close];
    }];
}


#pragma mark - 公告
- (void)room:(VHRoom *)room announcement:(NSString *)content publishTime:(NSString*)time {
    [self showAnnouncement:content publishTime:time];
}

- (void)showAnnouncement:(NSString *)content publishTime:(NSString*)time {
    if(!content) {
        return;
    }
    if (!announcementContentDic) {
        announcementContentDic = [[NSMutableDictionary alloc] init];
    }
    [announcementContentDic setObject:content forKey:@"announceContent"];
    [announcementContentDic setObject:time forKey:@"announceTime"];
    
    if(!announcementView) {
        announcementView = [[AnnouncementView alloc]initWithFrame:CGRectMake(0, 0, _showView.width, 35) content:content time:nil];
    }
    announcementView.content = [content stringByAppendingString:time];
    [_showView addSubview:announcementView];
}



#pragma mark -  问卷相关
//----------VHallSurveyDelegate------------
//flsh活动，发布问卷以下两个方法都会回调。如果使用webView的方式加载问卷，在-receivedSurveyWithURL:处理，如果仍保留旧版加载问卷方式，在-receiveSurveryMsgs:方法处理，处理方式不变。H5活动发布问卷，只回调-receivedSurveyWithURL：。

- (void)receivedSurveyWithURL:(NSURL *)surveyURL
{
    VHallSurveyModel *model = [[VHallSurveyModel alloc] init];
    model.surveyURL = surveyURL;
    [_chatDataArray addObject:model];//添加问卷消息到聊天列表

    if (_chatBtn.selected) {
        [self reloadDataWithDataSource:_chatDataArray animated:YES];
    }
}
// 6.4.0 新增
- (void)receivedSurveyWithURL:(NSURL *)surveyURL surveyName:(NSString *)surveyName{
    //6.4 新增问卷名称
    [self questionnaireLogic:YES];
    self.questionnaireDesc = surveyName;
    VHallSurveyModel *model = [[VHallSurveyModel alloc] init];
    model.surveyName = surveyName;//问卷名称
    model.surveyURL = surveyURL;
    model.is_answered = NO;
    [_chatDataArray addObject:model];//添加问卷消息到聊天列表

    if (_chatBtn.selected) {
        [self reloadDataWithDataSource:_chatDataArray animated:YES];
    }
}
- (void)receiveSurveryMsgs:(NSArray*)msgs {
    
}

//----------------VHSurveyViewControllerDelegate--------------

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
    VH_ShowToast(@"提交成功");
}

//--------点击展示问卷-------
// 显示问卷详情
- (void)clickSurvey:(VHallSurveyModel *)model
{
    if (![VHallApi isLoggedIn]) {
        VH_ShowToast(@"请登录");
        return;
    }
    
    //v4.0.0 及以上 使用webview 加载h5问卷详情
    if (model.surveyURL) {
        if (!_surveyController) {
            _surveyController = [[VHSurveyViewController alloc] init];
            _surveyController.delegate = self;
        }
        _surveyController.view.frame = self.view.bounds;
        _surveyController.url = model.surveyURL;
        [self.view addSubview:_surveyController.view];
    }
}

//原生调查问卷页面
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
    // NSArray *resultArray =[[NSMutableArray alloc] init];
    SZQuestionItem *item = [[SZQuestionItem alloc] initWithTitleArray:titleArray andOptionArray:optionArray andResultArray:self.surveyResultArray andQuestonTypes:typeArry isMustSelectArray:isMustSelectArray];
    VHQuestionCheckBox *questionBox=[[VHQuestionCheckBox alloc] initWithItem:item];
    questionBox.survey = survey;
    [self presentViewController:questionBox animated:YES completion:^{
        
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

#pragma mark - 计时器
// 打开计时器
- (void)clickTimerIconBtn
{
    [_timerView isShowView];
}
// 获取当前计时器
- (void)requestInteractsTimerInfo
{
    @weakify(self);
    [VHallTimerObject requestInteractsTimerInfoSuccess:^(VHallTimerObjectModel *timerModel) {
        @strongify(self);
        
        VHLog(@"当前计时器 时长:%ld === 剩余时间:%ld === 是否全部显示:%@ === 是否超时:%@",timerModel.duration,timerModel.remain_time,timerModel.is_all_show ? @"是" : @"否",timerModel.is_timeout ? @"是" : @"否");

        if (timerModel.is_all_show) {
            if (!_timerView) {
                [self.timerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(self.view);
                }];
            }
            [_timerView timerResume:timerModel.remain_time is_timeout:timerModel.is_timeout];
            [_timerIconBtn setHidden:NO];
        }
    } fail:^(NSError *error) {
        VH_ShowToast(error.localizedDescription);
    }];
}

// 开始计时器
- (void)vhTimerStartToDuration:(NSInteger)duration is_all_show:(BOOL)is_all_show is_timeout:(BOOL)is_timeout
{
    VHLog(@"计时器时长:%ld === 是否全部显示:%@ === 是否超时:%@",duration,is_all_show ? @"是" : @"否",is_timeout ? @"是" : @"否");
    if (!_timerView) {
        [self.timerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    if (is_all_show) {
        [_timerView showTimerView:duration is_timeout:is_timeout];
        [_timerIconBtn setHidden:NO];
    }
}

// 结束计时器
- (void)vhTimerEnd
{
    VHLog(@"计时器结束");
    [_timerView dismiss];
    [_timerIconBtn setHidden:YES];
}

// 暂停计时器
- (void)vhTimerPause
{
    VHLog(@"计时器暂停");
    [_timerView timerPause];
}

// 恢复计时器
- (void)vhTimerResumeToDuration:(NSInteger)duration remain_time:(NSInteger)remain_time is_all_show:(BOOL)is_all_show is_timeout:(BOOL)is_timeout
{
    VHLog(@"计时器重置 时长:%ld === 剩余时间:%ld === 是否全部显示:%@ === 是否超时:%@",duration,remain_time,is_all_show ? @"是" : @"否",is_timeout ? @"是" : @"否");
    if (is_all_show) {
        [_timerView timerResume:remain_time is_timeout:is_timeout];
        [_timerIconBtn setHidden:NO];
    }
}

// 重置计时器
- (void)vhTimerResetToDuration:(NSInteger)duration is_all_show:(BOOL)is_all_show is_timeout:(BOOL)is_timeout
{
    VHLog(@"计时器重置 时长:%ld === 是否全部显示:%@ === 是否超时:%@",duration,is_all_show ? @"是" : @"否",is_timeout ? @"是" : @"否");
    [_timerView dismiss];
    [_timerIconBtn setHidden:YES];
}

#pragma mark - VHRoomDelegate
/// 进入房间回调
- (void)room:(VHRoom *)room enterRoomWithError:(NSError *)error {
    VUI_Log(@"加入房间回调");
    [self interactiveRoomError:error];
    if(error == nil) { //加入房间成功
        //更新在线人数
        [self updateShowOnlineNum];
        // 设置计时器代理
        self.timerObject.delegate = self;
        //问答状态
        _isQuestion_status = self.inavRoom.roomInfo.qaOpenState;
        //问答名称 self.inavRoom.roomInfo.questionName
        self.questionDesc = self.inavRoom.roomInfo.questionName;
        [self.questionName setTitle:self.inavRoom.roomInfo.questionName forState:UIControlStateNormal];
        //点击聊天
        [self chatButtonClick:self.chatBtn];
        //设置文档
        self.docAreaView.watermark = self.inavRoom.roomInfo.docWatermarkModel;
        [self.docAreaView setDocument:self.inavRoom.roomInfo.documentManager defaultShow:self.inavRoom.roomInfo.documentOpenState];
        self.docAreaView.delegate = self;
        //是否显示上麦按钮
        if(self.inavRoom.roomInfo.handsUpOpenState) {
            [_countDowwnView showCountView];
        }
        //设置视频画面主讲人id
        self.videoView.roomInfo = self.inavRoom.roomInfo;
        //公告
        [self showAnnouncement:self.inavRoom.roomInfo.announcement publishTime:self.inavRoom.roomInfo.announcementTime];
    }
}

/// 房间连接成功回调
- (void)room:(VHRoom *)room didConnect:(NSDictionary *)roomMetadata {
    VUI_Log(@"房间连接成功");
    
    // 获取问卷列表
    [self questionnaireLogic:NO];
    
    // 获取抽奖历史
    [self lotteryLogic:NO];
    
    // 获取计时器
    [self requestInteractsTimerInfo];
}

/// 房间发生错误回调
- (void)room:(VHRoom *)room didError:(VHRoomErrorStatus)status reason:(NSString *)reason {
    [self.inavRoom leaveRoom];
    [_videoView removeAllRenderView];
    [UIAlertController showAlertControllerTitle:@"提示" msg:[NSString stringWithFormat:@"%zd-%@",status,reason] btnTitle:@"确定" callBack:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    NSLog(@"reason===%@",reason);
}

/// 房间状态改变回调
- (void)room:(VHRoom *)room didChangeStatus:(VHRoomStatus)status {
    
}

//房间人数改变回调
- (void)onlineChangeRealNum:(NSUInteger)online_real virtualNum:(NSUInteger)online_virtual {
    [self updateShowOnlineNum];
}


/// 视频流加入回调（流类型包括音视频、共享屏幕、插播等）
- (void)room:(VHRoom *)room didAddAttendView:(VHRenderView *)attendView {
    if (attendView.streamType == VHInteractiveStreamTypeVideoPatrol) {
        return;//过滤视频轮巡流
    }
    VUI_Log(@"\n某人上麦:%@，流类型：%d，流视频宽高：%@，流id：%@，是否有音频：%d，是否有视频：%d",attendView.userId,attendView.streamType,NSStringFromCGSize(attendView.videoSize),attendView.streamId,attendView.hasAudio,attendView.hasVideo);
    [self.videoView addRenderView:attendView];
}

/// 视频流离开回调（流类型包括音视频、共享屏幕、插播等）
- (void)room:(VHRoom *)room didRemovedAttendView:(VHRenderView *)attendView {
    if (attendView.streamType == VHInteractiveStreamTypeVideoPatrol) {
        return;//过滤视频轮巡流
    }
    [self.videoView removeRenderView:attendView];
}


/// 互动相关消息回调
- (void)room:(VHRoom *)room receiveRoomMessage:(VHRoomMessage *)message {
    if(message.targetForMe) { //针对自己的消息
        if (message.messageType == VHRoomMessageType_vrtc_connect_agree) { //主持人同意自己上麦
            [self presentInteractiveVC];
        }else if (message.messageType == VHRoomMessageType_vrtc_connect_refused) { //主持人拒绝自己上麦
            VH_ShowToast(@"主持人拒绝了您的上麦申请");
        }else if (message.messageType == VHRoomMessageType_vrtc_connect_invite) { //主持人邀请自己上麦
            _invitationAlertView = [[VHInvitationAlert alloc]initWithDelegate:self tag:1000 title:@"上麦邀请" content:[NSString stringWithFormat:@"%@邀请您上麦，是否接受？",VH_MB_HOST]];
            [self.view addSubview:_invitationAlertView];
            
        }else if (message.messageType == VHRoomMessageType_room_kickout) { //被踢出
            [self kickOutAction];
        }
    }
    
    if(message.messageType == VHRoomMessageType_vrtc_connect_open) { //开启举手
        [_countDowwnView showCountView];
    }else if(message.messageType == VHRoomMessageType_vrtc_connect_close) { //关闭举手
        [_countDowwnView hiddenCountView];
    }else if (message.messageType == VHRoomMessageType_live_over) { //结束直播
        [ProgressHud hideLoading];
        [UIAlertController showAlertControllerTitle:@"提示" msg:@"直播已结束" btnTitle:@"确定" callBack:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }else if (message.messageType == VHRoomMessageType_vrtc_speaker_switch) { //某个用户被设置为主讲人
        [self.videoView updateMainSpeakerView];
    }
}
//互动出错
- (void)interactiveRoomError:(NSError *)error {
    if (!error) {
        return;
    }
    [ProgressHud hideLoading];
    VUI_Log(@"互动房间出错：%@",error);
    if(error.code == 284003){ //socket.io fail（一般是网络错误）
        VH_ShowToast(@"当前网络异常");
    }else {
        VH_ShowToast(error.domain);
    }
}

#pragma mark - 插拔耳机
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

#pragma mark - 旋转屏幕
-(BOOL)shouldAutorotate {
    if(self.presentedViewController) {
        return [self.presentedViewController shouldAutorotate];
    }
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if(self.presentedViewController) {
        return [self.presentedViewController supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if(self.presentedViewController) {
        return [self.presentedViewController preferredInterfaceOrientationForPresentation];
    }
    return UIInterfaceOrientationPortrait;
}

#pragma mark - 懒加载
- (VHRoom *)inavRoom {
    if (!_inavRoom) {
        _inavRoom = [[VHRoom alloc] init];
        _inavRoom.delegate = self;
    }
    return _inavRoom;
}

- (NSDictionary *)playParam {
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    param[@"id"] =  _roomId;
    if (_kValue &&_kValue.length>0) {
        param[@"pass"] = _kValue;
    }
    if (_k_id &&_k_id.length>0) {
        param[@"k_id"] = _k_id;
    }
    return param;
}

- (VHWatchNodelayVideoView *)videoView
{
    if (!_videoView)
    {
        _videoView = [[VHWatchNodelayVideoView alloc] init];
    }
    return _videoView;
}
- (VHallTimerObject *)timerObject
{
    if (!_timerObject) {
        _timerObject = [[VHallTimerObject alloc] initWithObject:self.inavRoom];
    }return _timerObject;
}
- (VHWatchLiveTimerView *)timerView
{
    if (!_timerView) {
        _timerView = [[VHWatchLiveTimerView alloc] init];
        [self.view addSubview:_timerView];
    }return _timerView;
}
- (UIButton *)timerIconBtn
{
    if (!_timerIconBtn) {
        _timerIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _timerIconBtn.hidden = YES;
        _timerIconBtn.contentMode = UIViewContentModeScaleAspectFit;
        [_timerIconBtn setImage:BundleUIImage(@"vh_timer_btn") forState:UIControlStateNormal];
        [_timerIconBtn addTarget:self action:@selector(clickTimerIconBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_timerIconBtn];
    }return _timerIconBtn;
}
@end
