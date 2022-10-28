//
//  VHPortraitWatchLiveVC_Nodelay.m
//  UIModel
//
//  Created by xiongchao on 2021/11/2.
//  Copyright © 2021 www.vhall.com. All rights reserved.
//

#import "VHPortraitWatchLiveVC_Nodelay.h"
#import <VHLiveSDK/VHallApi.h>
#import "UIAlertController+ITTAdditionsUIModel.h"
#import "VHPortraitWatchLiveDecorateView.h"
#import "VHinteractiveViewController.h"
#import "VHInvitationAlert.h"
#import "VHWatchNodelayVideoView.h"
#import <VHInteractive/VHRoom.h>
#import "Reachability.h"

@interface VHPortraitWatchLiveVC_Nodelay () <VHPortraitWatchLiveDecorateViewDelegate,VHallChatDelegate,VHinteractiveViewControllerDelegate,VHInvitationAlertDelegate,VHRoomDelegate> {
    BOOL _haveLoadHistoryChat; //是否已加载历史聊天记录
}
/** 视频view上层子控件的父视图 */
@property (nonatomic, strong) VHPortraitWatchLiveDecorateView *decorateView;
/** 互动控制器 */
@property (nonatomic, strong) VHinteractiveViewController *interactiveVC;
/** 返回按钮 */
@property (nonatomic, strong) UIButton *backBtn;
/** 聊天对象 */
@property (nonatomic, strong) VHallChat *vhallChat;
/** 互动控制器 */
@property (nonatomic, strong) NSMutableDictionary *playParam;
/** 主持人邀请上麦弹窗 */
@property (nonatomic, strong) VHInvitationAlert *invitationAlertView;

@property (nonatomic, strong) VHWatchNodelayVideoView *videoView;  //视频容器

/// 互动SDK (用于无延迟直播)
@property (nonatomic, strong) VHRoom *inavRoom;
/// 视频轮巡RenderView
@property (nonatomic, strong) VHLocalRenderView * videoRoundRenderView;
/// 是否参加旁路
@property (nonatomic, strong) UIButton * isInavBypass;

@property (nonatomic, strong) MASConstraint *videoViewHeight;     ///<视频容器高
/// 网络监听
@property(nonatomic, strong) Reachability * reachAbility;

@end

@implementation VHPortraitWatchLiveVC_Nodelay
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s释放",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String]);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //程序进入前后台监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    //监听网络变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChange:) name:kReachabilityChangedNotification object:nil];
    _reachAbility = [Reachability reachabilityForInternetConnection];
    [_reachAbility startNotifier];

    [self configUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //关闭设备自动锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self enterInvRoom];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //开启设备自动锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self inavLeaveRoom];
}


- (void)configUI {
    [self.view addSubview:self.videoView];
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.equalTo(self.view);
        self.videoViewHeight = make.height.equalTo(self.videoView.mas_width).multipliedBy(9/16.0);
    }];
    
    [self.view addSubview:self.decorateView];
    [self.decorateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(CGSizeMake(30, 30)));
        make.left.equalTo(@(15));
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(@(20));
        }
    }];
    
//    [self.isInavBypass mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(0);
//        make.top.mas_equalTo(50);
//        make.size.mas_equalTo(CGSizeMake(200, 40));
//    }];
}

#pragma mark - 进入互动房间
- (void)enterInvRoom {
    [self.inavRoom enterRoomWithParams:[self playParam]];
}

//加载历史聊天记录
- (void)loadHistoryChatData {
    if(_haveLoadHistoryChat == NO) {
        [_vhallChat getHistoryWithPage_num:1 page_size:10 start_time:nil success:^(NSArray<VHallChatModel *> *msgs) {
            [self.decorateView receiveMessage:msgs];
        } failed:^(NSDictionary *failedData) {
            NSString* errorInfo = [NSString stringWithFormat:@"%@---%@", failedData[@"content"], failedData[@"code"]];
            NSLog(@"获取历史聊天记录失败：%@",errorInfo);
        }];
        _haveLoadHistoryChat = YES;
    }
}


#pragma mark - UI事件
- (void)backBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
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


//弹出互动页面
- (void)presentInteractiveVC:(BOOL)isVideoRound {
    [self.decorateView.upMicBtnView stopCountDown];
    //进入互动
    self.interactiveVC.isVideoRound = isVideoRound;
    self.interactiveVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:self.interactiveVC animated:YES completion:nil];
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


#pragma mark - VHallChatDelegate
/**
 * 收到上下线消息
 */
- (void)reciveOnlineMsg:(NSArray <VHallOnlineStateModel *> *)msgs {
    [self.decorateView receiveMessage:msgs];
}
/**
 * 收到聊天消息
 */
- (void)reciveChatMsg:(NSArray <VHallChatModel *> *)msgs {
    //过滤私聊
    NSString *currentUserId = self.inavRoom.roomInfo.webinarInfoData.join_info.third_party_user_id;
    NSArray *msgArr = [VHHelpTool filterPrivateMsgCurrentUserId:currentUserId origin:msgs isFilter:YES half:NO];
    [self.decorateView receiveMessage:msgArr];
}
/**
 * 收到自定义消息
 */
- (void)reciveCustomMsg:(NSArray <VHallCustomMsgModel *> *)msgs {
    
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
    [self.decorateView receiveMessage:msgs];
}

/**
 * 收到被禁言/取消禁言
 */
- (void)forbidChat:(BOOL)forbidChat {
    VH_ShowToast(forbidChat?@"您已被禁言":@"您已被取消禁言");
}

/**
 * 收到全体禁言/取消全体禁言
 */
- (void)allForbidChat:(BOOL)allForbidChat {
    VH_ShowToast(allForbidChat?@"全体已被禁言":@"全体已被取消禁言");
}

#pragma mark - 视频轮巡
// 轮巡开始
- (void)videoRoundStart
{
    VH_ShowToast(@"主办方开启了视频轮巡功能，在主持人端将会看到您的视频画面，请保持视频设备一切正常");
}
// 轮巡结束
- (void)videoRoundEnd
{
    [_inavRoom unpublish];
    
    if (_videoRoundRenderView) {
        _videoRoundRenderView = nil;
    }
}
// 轮巡列表
- (void)videoRoundUsers:(NSArray *)uids
{
    BOOL isHave = NO;
    for (NSString * userId in uids) {
        if ([userId isEqualToString:[VHallApi currentUserID]]) {
            isHave = YES;
            break;
        }
    }
    if (isHave) {
        // 判断互动房间断了 则连接互动房间
        if (self.inavRoom.status != VHRoomStatusConnected) {
            [self enterInvRoom];
            return;
        }
        // 如果在推流 则不需要推流了
        if (self.inavRoom.isPublishing) {
            return;
        }
        [self.inavRoom publishWithCameraView:self.videoRoundRenderView];
    }else{
        [self.inavRoom unpublish];
    }
}
// 视频轮询的list请求
- (void)getRoundUsers
{
    __weak __typeof(self)weakSelf = self;
    [self.inavRoom getRoundUsersWithIs_next:@"0" success:^(NSDictionary *response) {
        NSDictionary * data = response[@"data"];
        NSMutableArray * users = [NSMutableArray array];
        for (NSDictionary * dic in data[@"list"]) {
            [users addObject:dic[@"account_id"]];
        }
        [weakSelf videoRoundUsers:users];
    } fail:^(NSError *error) {
        
    }];
}
#pragma mark - 是否参与旁路
- (void)clickIsInavBypass:(UIButton *)sender
{
    [self.inavRoom setRoomJoinBroadCastMixOption:sender.selected cameraView:self.videoRoundRenderView finish:^(int code, NSString * _Nonnull message) {
        
    }];
    sender.selected = !sender.selected;
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
            [self inavLeaveRoom];
        }
            break;
        case ReachableViaWiFi:
        {
            //wifi
            //请求最新数据
            [self enterInvRoom];
        }
            break;
        case ReachableViaWWAN:
        {
            //数据网络
            //请求最新数据
            [self enterInvRoom];
        }
            break;
        default:
            break;
    }
}

#pragma mark - VHInvitationAlertDelegate
- (void)alert:(VHInvitationAlert *)alert clickAtIndex:(NSInteger)index {
    [alert removeFromSuperview];
    alert = nil;
    if(index == 1){ //同意主持人的邀请
        ///先校验权限再上麦进入互动
        [VHHelpTool getMediaAccess:^(BOOL videoAccess, BOOL audioAcess) {
            [self.inavRoom agreeInviteSuccess:^{
                [self presentInteractiveVC:NO];
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


#pragma mark - VHPortraitWatchLiveDecorateViewDelegate
//发送消息
- (void)decorateView:(VHPortraitWatchLiveDecorateView *)decorateView sendMessage:(NSString *)messageText {
    if(_vhallChat.isAllSpeakBlocked) {
        VH_ShowToast(@"已开启全体禁言");
        return;
    }
    if(_vhallChat.isSpeakBlocked) {
        VH_ShowToast(@"您已被禁言");
        return;
    }
    
    if ([UIModelTools safeString:messageText].length == 0) {
        VH_ShowToast(@"发送的消息不能为空");
        return;
    }
    
    [_vhallChat sendMsg:messageText success:^{
        
    } failed:^(NSDictionary *failedData) {
        
        NSString* text = [NSString stringWithFormat:@"%@ %@", failedData[@"code"],failedData[@"content"]];
        VH_ShowToast(text);
    }];
}

//上麦按钮点击事件
- (void)decorateView:(VHPortraitWatchLiveDecorateView *)decorateView upMicBtnClick:(UIButton *)button {
    if(_vhallChat.isAllSpeakBlocked) {
        VH_ShowToast(@"已开启全体禁言");
        return;
    }
    if(_vhallChat.isSpeakBlocked) {
        VH_ShowToast(@"您已被禁言");
        return;
    }

    button.selected = !button.selected;
    __weak typeof(self) weakSelf = self;
    if (button.selected) {
        [VHHelpTool getMediaAccess:^(BOOL videoAccess, BOOL audioAcess) {
            [self.inavRoom applySuccess:^{
                VH_ShowToast(@"申请上麦成功");
                //开启上麦倒计时
                [weakSelf.decorateView.upMicBtnView countdDown:30];
            } fail:^(NSError *error) {
                NSString *msg = [NSString stringWithFormat:@"申请上麦失败：%@",error.description];
                VH_ShowToast(msg);
            }];
        }];
    } else {
        [self.inavRoom cancelApplySuccess:^{
            VH_ShowToast(@"已取消申请");
            //停止倒计时
            [weakSelf.decorateView.upMicBtnView stopCountDown];
        } fail:^(NSError *error) {
            NSString *msg = [NSString stringWithFormat:@"取消上麦失败：%@",error.description];
            VH_ShowToast(msg);
        }];
    }
}

#pragma mark - VHRoomDelegate
/// 进入房间回调
- (void)room:(VHRoom *)room enterRoomWithError:(NSError *)error {
    VUI_Log(@"加入房间回调");
    [self interactiveRoomError:error];
    
    if(error == nil) { //加入房间成功
        //加载历史聊天记录
        [self loadHistoryChatData];
        //是否显示上麦按钮
        if(self.inavRoom.roomInfo.handsUpOpenState) {
            self.decorateView.upMicBtnView.hidden = NO;
        }
        //设置视频画面主讲人id
        self.videoView.roomInfo = self.inavRoom.roomInfo;
        if(self.inavRoom.roomInfo.webinar_type != VHWebinarLiveType_Interactive) { //非互动直播，全屏布局
            [self.videoViewHeight uninstall];
            [self.videoView mas_updateConstraints:^(MASConstraintMaker *make) {
                self.videoViewHeight = make.height.equalTo(self.view);
            }];
        }
        
        // 查询视频轮询
        [self getRoundUsers];
    }
}

/// 房间连接成功回调
- (void)room:(VHRoom *)room didConnect:(NSDictionary *)roomMetadata {
    VUI_Log(@"房间连接成功");
}

/// 房间发生错误回调
- (void)room:(VHRoom *)room didError:(VHRoomErrorStatus)status reason:(NSString *)reason {
    [self inavLeaveRoom];
    [UIAlertController showAlertControllerTitle:@"提示" msg:[NSString stringWithFormat:@"%zd-%@",status,reason] btnTitle:@"确定" callBack:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    NSLog(@"reason===%@",reason);
}

/// 房间状态改变回调
- (void)room:(VHRoom *)room didChangeStatus:(VHRoomStatus)status {
    VUI_Log(@"房间状态变化：%zd",status);
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
            [self presentInteractiveVC:NO];
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
        self.decorateView.upMicBtnView.hidden = NO;
    }else if(message.messageType == VHRoomMessageType_vrtc_connect_close) { //关闭举手
        self.decorateView.upMicBtnView.hidden = YES;
    }else if (message.messageType == VHRoomMessageType_live_over) { //结束直播
        [ProgressHud hideLoading];
        [UIAlertController showAlertControllerTitle:@"提示" msg:@"直播已结束" btnTitle:@"确定" callBack:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }else if (message.messageType == VHRoomMessageType_vrtc_speaker_switch) { //某个用户被设置为主讲人
        [self.videoView updateMainSpeakerView];
    }
}

#pragma mark - 切换前后台
//前台
- (void)appWillEnterForeground {
    [self getRoundUsers];
}
//后台
- (void)appEnterBackground {
    //停止推流
    [self videoRoundEnd];
}

#pragma mark - 离开房间
- (void)inavLeaveRoom
{
    if (_inavRoom) {
        [_inavRoom leaveRoom];
        _inavRoom = nil;
    }
    if (_vhallChat) {
        _vhallChat = nil;
    }
    if (_videoView) {
        [_videoView removeAllRenderView];
    }
    if (_videoRoundRenderView) {
        _videoRoundRenderView = nil;
    }
}
#pragma mark - 懒加载
- (NSMutableDictionary *)playParam
{
    if (!_playParam)
    {
        _playParam = [[NSMutableDictionary alloc]init];
        _playParam[@"id"] =  _roomId;
        if (_kValue && _kValue.length>0) {
            _playParam[@"pass"] = _kValue;
        }
        if (_k_id &&_k_id.length>0) {
            _playParam[@"k_id"] = _k_id;
        }
    }
    return _playParam;
}

- (VHPortraitWatchLiveDecorateView *)decorateView
{
    if (!_decorateView)
    {
        _decorateView = [[VHPortraitWatchLiveDecorateView alloc] initWithDelegate:self];
        _decorateView.backgroundColor = [UIColor clearColor];
    }
    return _decorateView;
}

- (UIButton *)backBtn
{
    if (!_backBtn)
    {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:BundleUIImage(@"返回.png") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (VHRoom *)inavRoom {
    if (!_inavRoom) {
        _inavRoom = [[VHRoom alloc] init];
        _inavRoom.delegate = self;
        
        //聊天对象初始化
        _vhallChat = [[VHallChat alloc] initWithObject:_inavRoom];
        _vhallChat.delegate = self;
    }
    return _inavRoom;
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
- (VHWatchNodelayVideoView *)videoView
{
    if (!_videoView)
    {
        _videoView = [[VHWatchNodelayVideoView alloc] init];
    }
    return _videoView;
}
- (VHinteractiveViewController *)interactiveVC
{
    if (!_interactiveVC) {
        //进入互动
        _interactiveVC = [[VHinteractiveViewController alloc] init];
        _interactiveVC.joinRoomPrams = [self playParam];
        _interactiveVC.inav_num = self.inavRoom.roomInfo.inav_num;
        _interactiveVC.inavBeautifyFilterEnable = self.interactBeautifyEnable;
    }return _interactiveVC;
}
- (UIButton *)isInavBypass
{
    if (!_isInavBypass) {
        _isInavBypass = [UIButton buttonWithType:UIButtonTypeCustom];
        [_isInavBypass setTitle:@"参与旁路" forState:UIControlStateNormal];
        [_isInavBypass setTitle:@"退出旁路" forState:UIControlStateSelected];
        [_isInavBypass addTarget:self action:@selector(clickIsInavBypass:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_isInavBypass];
    }return _isInavBypass;
}
@end
