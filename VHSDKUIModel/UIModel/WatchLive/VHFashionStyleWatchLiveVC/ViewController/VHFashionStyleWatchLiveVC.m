//
//  VHFashionStyleWatchLiveVC.m
//  UIModel
//
//  Created by 郭超 on 2022/7/21.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHFashionStyleWatchLiveVC.h"
#import "VHFashionStyleWatchLiveView.h"
#import "VHFashionStyleInteractView.h"
#import "VHFashionStyleTopView.h"
#import "VHFashionStyleBottomView.h"
#import "VHFashionStyleChatView.h"
#import "VHFashionStyleGiftListView.h"
#import "VHFashionStyleGiftPushView.h"

@interface VHFashionStyleWatchLiveVC ()<VHFashionStyleWatchLiveViewDelegate,VHFashionStyleInteractViewDelegate,VHallChatDelegate,VHallGiftObjectDelegate>

/// 播放器
@property (nonatomic, strong) VHallMoviePlayer  * moviePlayer;
/// 互动房间
@property (nonatomic, strong) VHRoom *                      inavRoom;

/// 聊天
@property (nonatomic, strong) VHallChat         *           chat;
/// 直播view
@property (nonatomic, strong) VHFashionStyleWatchLiveView * watchLive;
/// 互动view
@property (nonatomic, strong) VHFashionStyleInteractView *  interact;
/// 顶部工具栏
@property (nonatomic, strong) VHFashionStyleTopView *       topView;
/// 底部工具栏
@property (nonatomic, strong) VHFashionStyleBottomView *    bottomView;
/// 聊天view
@property (nonatomic, strong) VHFashionStyleChatView *      chatView;

/// 礼物类
@property (nonatomic, strong) VHallGiftObject * giftObject;
/// 礼物弹窗
@property (nonatomic, strong) VHFashionStyleGiftListView *  giftListView;
/// 礼物动画
@property (nonatomic, strong) VHFashionStyleGiftPushView *  giftPushView;

@end

@implementation VHFashionStyleWatchLiveVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                 forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.translucent = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    // 阻止设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];

    // 导航栏设置
    [self changeNavViews];
    
    // 添加控件
    [self addViews];
    
    // 返回角色数据
    [self getRoleName];
        
    // 获取播放器并播放
    [self getMoviePlayerToStartPlay];

    
}
#pragma mark - 导航栏设置
- (void)changeNavViews
{
    // title字体
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:FONT_Medium(16)}];
    
    // 返回按钮
    UIBarButtonItem * closeBtn = [[UIBarButtonItem alloc]initWithImage:BundleUIImage(@"vh_fs_close_btn") style:UIBarButtonItemStylePlain target:self action:@selector(clickCloseToBtn)];
    self.navigationItem.leftBarButtonItem = closeBtn;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

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
    [self.watchLive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(-100);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(VHScreenWidth * .56);
    }];
    
    [self.interact mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(-100);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(VHScreenWidth * .56);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8+VH_KNavBarHeight);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(34);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-VH_KBottomSafeMargin-15);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    
    [self.chatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(180);
        make.width.mas_equalTo(277);
        make.bottom.mas_equalTo(_bottomView.mas_top).offset(-15);
    }];
}
#pragma mark - 获取房间主要信息
- (void)getRoleName
{
    [VHWebinarBaseInfo getRoleNameWebinar_id:self.roomId dataCallBack:^(VHRoleNameData * roleData) {
        VH_MB_HOST = roleData.host_name;
        VH_MB_GUEST = roleData.guest_name;
        VH_MB_ASSIST = roleData.assist_name;
    }];
}
#pragma mark - 获取播放器并播放
- (void)getMoviePlayerToStartPlay
{
    // 获取播放器
    self.moviePlayer = self.watchLive.moviePlayer;

    // 非预加载方式，直接播放，在收到"播放连接成功回调"后，才能使用聊天、签到等功能
    [self.moviePlayer startPlay:[self playParam]];
    
    // 预加载视频，收到"预加载成功回调"后，即可使用聊天等功能，择机调用 startPlay 正式开播，用于开播之前使用聊天、签到等功能
    // [self.moviePlayer preLoadRoomWithParam:[self playParam]];
}
#pragma mark - 设置代理
- (void)setDelegateToObject
{
    // 设置聊天代理
    self.chat.delegate = self;

    // 设置礼物代理
    self.giftObject.delegate = self;
}
#pragma mark - 直播互动切换
- (void)watchLiveChangeInteract:(BOOL)isChange
{
    self.watchLive.hidden = isChange;
    self.interact.hidden = !isChange;
    // 告诉上麦按钮是否在推流(用于更换图片)
    self.bottomView.upMicBtnView.isPublish = isChange;

    if (isChange) {
        [self.moviePlayer pausePlay];
        [self.interact enterRoomPublish];
    }else{
        [self.moviePlayer reconnectPlay];
        [self.interact leave];
    }
    // 给topView传递当前直播互动状态
    [self.topView watchLiveChangeInteract:isChange localRenderView:self.interact.localRenderView];
}
#pragma mark - VHFashionStyleWatchLiveViewDelegate
#pragma mark - -----------------VHallMoviePlayer 播放器状态相关--------------------
// 播放连接成功
- (void)connectSucceed:(VHallMoviePlayer *)moviePlayer info:(NSDictionary *)info
{
    VHLog(@"播放连接成功：%@",info);
    
    // 房间标题
    self.title = moviePlayer.webinarInfo.subject;

    // 设置delegate
    [self setDelegateToObject];

    // 顶部信息赋值
    _topView.webinarInfo = moviePlayer.webinarInfo;

    // 底部信息赋值
    _bottomView.moviePlayer = moviePlayer;
    _bottomView.chat = _chat;
    // 获取房间配置项权限
    [_bottomView permissionsCheckWithWebinarId];
    // 获取点赞数
    [_bottomView requestGetRoomLikeWithRoomId];
    // 获取自己的头像
    [_bottomView.headImg sd_setImageWithURL:[NSURL URLWithString:moviePlayer.webinarInfo.webinarInfoData.join_info.avatar]];
    
    // 获取历史聊天记录
    [_chatView loadHistoryWithChat:_chat page:_chatView.chatListPage];
}
#pragma mark - -----------------房间相关--------------------
//直播开始回调
- (void)liveStart{
    VHLog(@"直播开始");
    __weak typeof(self) wf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wf.moviePlayer startPlay:[wf playParam]];
    });
}
//直播已结束回调
- (void)liveStoped
{
    VHLog(@"直播已结束");
    [self clickCloseToBtn];
}
#pragma mark - -----------------VHallMoviePlayer 上下麦相关--------------------
// 主持人是否允许举手
- (void)moviePlayer:(VHallMoviePlayer *)player isInteractiveActivity:(BOOL)isInteractive interactivePermission:(VHInteractiveState)state
{
    [_bottomView isInteractiveActivity:isInteractive interactivePermission:state];
}
// 主持人同意上麦回调
- (void)moviePlayer:(VHallMoviePlayer *)player microInvitationWithAttributes:(NSDictionary *)attributes error:(NSError *)error {
    
    if (!error) {
        [self watchLiveChangeInteract:YES];
    }else{
        VH_ShowToast(error.localizedDescription);
    }
    [_bottomView microInvitationWithAttributes:attributes error:error];
}
// 主持人邀请你上麦
- (void)moviePlayer:(VHallMoviePlayer *)player microInvitation:(NSDictionary *)attributes
{
    [_bottomView microInvitation:attributes];
}
/// 被踢出
- (void)moviePlayer:(VHallMoviePlayer*)player isKickout:(BOOL)isKickout
{
    VHLog(@"您已被踢出");
    [self clickCloseToBtn];
}

#pragma mark - ----------------------VHFashionStyleInteractViewDelegate--------------------------
/// 自己的麦克风开关状态改变回调
- (void)room:(VHRoom *)room microphoneClosed:(BOOL)isClose
{
    [_topView room:room microphoneClosed:isClose];
}
/// 自己的摄像头开关状态改变回调
- (void)room:(VHRoom *)room screenClosed:(BOOL)isClose
{
    [_topView room:room screenClosed:isClose];
}

#pragma mark - ----------------------VHallChatDelegate----------------------
// 收到上下线消息
- (void)reciveOnlineMsg:(NSArray <VHallOnlineStateModel *> *)msgs
{
    [_topView reciveOnlineMsg:msgs];

    for (VHallOnlineStateModel * m in msgs) {
        NSString * content = [NSString stringWithFormat:@"在线:%@ 参会:%@ 用户id:%@",m.concurrent_user, m.attend_count,m.account_id];
        VHLog(@"%@",content);
    }
    
}
// 收到聊天消息
- (void)reciveChatMsg:(NSArray <VHallChatModel *> *)msgs
{
    //过滤私聊 传递target_id,当前用户join_id
    NSString *currentUserId = self.moviePlayer.webinarInfo.webinarInfoData.join_info.third_party_user_id;
    NSArray *msgArr = [VHHelpTool filterPrivateMsgCurrentUserId:currentUserId origin:msgs isFilter:YES half:YES];
    [self.chatView reloadDataWithMsgs:msgArr];
}
// 收到自定义消息
- (void)reciveCustomMsg:(NSArray <VHallCustomMsgModel *> *)msgs
{
    
}
// 更新点赞总数
- (void)vhPraiseTotalToNum:(NSInteger)num
{
    VHLog(@"当前点赞总数 === %ld",num);
    [self.bottomView vhPraiseTotalToNum:num];
}
// 收到礼物
- (void)vhGifttoModel:(VHallGiftModel *)model
{
    // 礼物动画
    [self.view addSubview:self.giftPushView];
    [_giftPushView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(_chatView.mas_top).offset(-10);
        make.height.mas_equalTo(20);
    }];
    [_giftPushView showGiftPushForNickName:model.gift_user_nickname giftName:model.gift_name giftImg:model.gift_image_url];
    
    // 给聊天模块增加数据
    [_chatView vhGifttoModel:model];
}
// 收到虚拟人数消息
- (void)vhBaseNumUpdateToUpdate_online_num:(NSInteger)update_online_num
                                 update_pv:(NSInteger)update_pv
{
    // 增加的虚拟人数和虚拟热度
    NSString * content = [NSString stringWithFormat:@"在线人数增加了%ld, 在线热度增加了%ld",update_online_num,update_pv];
    VHLog(@"%@",content);
    
    [self.topView vhBaseNumUpdateToUpdate_online_num:update_online_num update_pv:update_pv];
}

#pragma mark - 关闭房间
- (void)clickCloseToBtn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 点击更多按钮
- (void)clickMoreToBtn
{
    VHLog(@"点击更多");
}

#pragma mark - 懒加载
- (VHallChat *)chat
{
    if (!_chat) {
        _chat = [[VHallChat alloc] initWithObject:self.moviePlayer];
    }return _chat;
}
- (VHFashionStyleWatchLiveView *)watchLive
{
    if (!_watchLive) {
        _watchLive = [[VHFashionStyleWatchLiveView alloc] init];
        _watchLive.hidden = NO;
        _watchLive.delegate = self;
        _watchLive.roomId = self.roomId;
        _watchLive.kValue = self.kValue;
        _watchLive.interactBeautifyEnable = self.interactBeautifyEnable;
        [self.view addSubview:_watchLive];
    }return _watchLive;
}
- (VHFashionStyleInteractView *)interact
{
    if (!_interact) {
        _interact = [[VHFashionStyleInteractView alloc] init];
        _interact.hidden = YES;
        _interact.delegate = self;
        _interact.roomId = self.roomId;
        _interact.kValue = self.kValue;
        _interact.interactBeautifyEnable = self.interactBeautifyEnable;
        @weakify(self);
        _interact.clickLeave = ^{
            @strongify(self);
            // 离开互动房间
            [self watchLiveChangeInteract:NO];
        };
        [self.view addSubview:_interact];
    }return _interact;
}
- (VHFashionStyleTopView *)topView
{
    if (!_topView) {
        _topView = [[VHFashionStyleTopView alloc] init];
        [self.view addSubview:_topView];
    }return _topView;
}
- (VHFashionStyleBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[VHFashionStyleBottomView alloc] init];
        @weakify(self);

        // 同意上麦邀请
        _bottomView.clickReplyInvitation = ^{
            @strongify(self);
            [self watchLiveChangeInteract:YES];
        };
        
        // 点击下麦
        _bottomView.clickUnpublish = ^{
            @strongify(self);
            [self watchLiveChangeInteract:NO];
        };
        
        // 点击礼物按钮
        _bottomView.clickGiftBtnBlock = ^{
            @strongify(self);
            [self showGiftListView];
        };
        
        [self.view addSubview:_bottomView];
    }return _bottomView;
}
- (VHFashionStyleChatView *)chatView
{
    if (!_chatView) {
        _chatView = [[VHFashionStyleChatView alloc] init];
        [self.view addSubview:_chatView];
    }return _chatView;
}
- (VHallGiftObject *)giftObject
{
    if (!_giftObject) {
        _giftObject = [[VHallGiftObject alloc] initWithObject:self.moviePlayer];
    }return _giftObject;
}
- (VHFashionStyleGiftListView *)giftListView
{
    if (!_giftListView) {
        _giftListView = [VHFashionStyleGiftListView new];
        [self.view addSubview:_giftListView];
    }return _giftListView;
}
- (void)showGiftListView
{
    if (!_giftListView) {
        [self.view addSubview:_giftListView];
        [self.giftListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    [self.view addSubview:_giftListView];
    [_giftListView showGiftToWebinarInfo:self.moviePlayer.webinarInfo];
}
- (VHFashionStyleGiftPushView *)giftPushView
{
    if (!_giftPushView) {
        _giftPushView = [[VHFashionStyleGiftPushView alloc] init];
    }return _giftPushView;
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

- (void)dealloc
{
    [_moviePlayer stopPlay];
    [_moviePlayer destroyMoivePlayer];

    if (_chat) {_chat = nil;}

    //隐藏loading
    [ProgressHud hideLoading];

    //允许自动锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    VHLog(@"%@ dealloc",[[self class] description]);
}

@end
