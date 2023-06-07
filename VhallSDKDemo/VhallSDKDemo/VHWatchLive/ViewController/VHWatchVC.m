//
//  VHWatchVC.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/13.
//

#import "AppDelegate.h"
#import "VHAnnouncementList.h"
#import "VHAnnouncementView.h"
#import "VHChatView.h"
#import "VHDocViewController.h"
#import "VHFashionStyleGiftListView.h"
#import "VHFoldButton.h"
#import "VHInavApplyAlertView.h"
#import "VHInavView.h"
#import "VHIntroView.h"
#import "VHLottery.h"
#import "VHQAView.h"
#import "VHRecordChapter.h"
#import "VHSignInAlertView.h"
#import "VHSurveyListView.h"
#import "VHVideoPointView.h"
#import "VHRecordListVC.h"
#import "VHWatchLiveBottomView.h"
#import "VHWatchVC.h"
#import "VHWatchVideoView.h"

@interface VHWatchVC ()<VHWatchVideoViewDelegate, VHInavViewDelegate, VHWatchLiveBottomViewDelegate, VHChatViewDelegate, JXCategoryViewDelegate, JXCategoryListContainerViewDelegate, VHallGiftObjectDelegate, VHQAViewDelegate, VHSignInAlertViewDelegate, VHSurveyListViewDelegate, VHDocViewDelegate, VHRecordChapterDelegate, VHVideoPointViewDelegate, VHLotteryDelegate, VHExamObjectDelegate, VHRecordListDelegate>

// 控件
/// 分页控件
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
/// 分页详情
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
/// 分页数据
@property (nonatomic, strong) NSMutableArray *listContainerArray;
/// 菜单
@property (nonatomic, strong) VHFoldButton *foldBtn;
/// 直播播放器
@property (nonatomic, strong) VHWatchVideoView *watchVideoView;
/// 互动播放器
@property (nonatomic, strong) VHInavView *inavView;
/// 聊天View
@property (nonatomic, strong) VHChatView *chatView;
/// 文档
@property (nonatomic, strong) VHDocViewController *docViewController;
/// 问答
@property (nonatomic, strong) VHQAView *vhQAView;
/// 简介
@property (nonatomic, strong) VHIntroView *introView;
/// 章节打点
@property (nonatomic, strong) VHRecordChapter *recordChapterView;
/// 精彩时刻
@property (nonatomic, strong) VHVideoPointView *videoPointView;
/// 精彩片段
@property (nonatomic, strong) VHRecordListVC * recordListVC;
@property (nonatomic, strong) NSArray<VHRecordListModel *> *recordList;
/// 底部工具
@property (nonatomic, strong) VHWatchLiveBottomView *bottomView;
/// 礼物类
@property (nonatomic, strong) VHallGiftObject *giftObject;
/// 礼物弹窗
@property (nonatomic, strong) VHFashionStyleGiftListView *giftListView;
/// 问卷列表
@property (nonatomic, strong) VHSurveyListView *surveyListView;
/// 公告
@property (nonatomic, strong) VHAnnouncementView *announcementView;
/// 公告列表
@property (nonatomic, strong) VHAnnouncementList *announcementList;
/// 申请互动连麦弹窗
@property (nonatomic, strong) VHInavApplyAlertView *inavApplyAlertView;
/// 签到
@property (nonatomic, strong) VHSignInAlertView *signInAlertView;
/// 抽奖
@property (nonatomic, strong) VHLottery *vhLottery;
/// 快问快答
@property (nonatomic, strong) VHExamObject *vhExam;

// 赋值
/// 问答名称
@property (nonatomic, copy) NSString *questionName;

// 标识
/// 标识当前直播还是互动
@property (nonatomic, assign) BOOL isLive;
@property (nonatomic, assign) BOOL isOpenDoc;
@property (nonatomic, assign) BOOL isOpenQA;
@property (nonatomic, assign) BOOL isOpenRecordChapter;
@property (nonatomic, assign) BOOL isOpenVideoPoint;
@property (nonatomic, assign) BOOL isFull;
@property (nonatomic, assign) BOOL isDocFull;
@property (nonatomic, assign) BOOL isVideoFull;
@end

@implementation VHWatchVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 强制竖屏
    [self clickFullIsSelect:NO];
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

    self.isLive = YES;

    // 设置样式
    [self setWithUI];

    // 返回角色数据
    [self getRoleName];
}

#pragma mark - 设置样式
- (void)setWithUI
{
    [self.watchVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo((Screen_Width < Screen_Height ? Screen_Width : Screen_Height) * 9 / 16);
    }];

    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.watchVideoView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(47 + SAFE_BOTTOM);
    }];

    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.categoryView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];

    [self.foldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-47 - SAFE_BOTTOM - 15);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark - 底部工具兰的显隐
- (void)bottomWithHidden:(BOOL)hidden
{
    self.bottomView.hidden = hidden;

    if (hidden) {
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    } else {
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(47 + SAFE_BOTTOM);
        }];
    }
}

#pragma mark - 获取房间主要信息
- (void)getRoleName
{
    [VHWebinarBaseInfo getRoleNameWebinar_id:self.webinar_id
                                dataCallBack:^(VHRoleNameData *roleData) {
        VH_MB_HOST = roleData.host_name;
        VH_MB_GUEST = roleData.guest_name;
        VH_MB_ASSIST = roleData.assist_name;
    }];
}

#pragma mark - JXCategoryViewDelegate
#pragma mark 选中
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index
{
    NSString *title = self.listContainerArray[index];

    // 问卷操作
    [self.bottomView participateInIsChat:![title isEqualToString:self.questionName]];
    // 聊天 问卷操作
    [self bottomWithHidden:([title isEqualToString:@"聊天"] || [title isEqualToString:self.questionName]) ? NO : YES];
    // 更多工具显示状态
    [self foldBtnIsHidden];
}

#pragma mark - JXCategoryListContainerViewDelegate
#pragma mark 返回列表的数量
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.listContainerArray.count;
}

#pragma mark 根据下标 index 返回对应遵守并实现 `JXCategoryListContentViewDelegate` 协议的列表实例
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    NSString *title = self.listContainerArray[index];

    if ([title isEqualToString:@"聊天"]) {
        return self.chatView;
    } else if ([title isEqualToString:@"文档"]) {
        return self.docViewController;
    } else if ([title isEqualToString:@"简介"]) {
        return self.introView;
    } else if ([title isEqualToString:self.questionName]) {
        return self.vhQAView;
    } else if ([title isEqualToString:@"章节"]) {
        return self.recordChapterView;
    } else if ([title isEqualToString:@"精彩时刻"]) {
        return self.videoPointView;
    } else if ([title isEqualToString:@"精彩片段"]) {
        return self.recordListVC;
    }

    return nil;
}

#pragma mark 刷新标签页显示 文档/问答/章节
- (void)roomWithIsOpenDoc:(BOOL)isOpenDoc isOpenQA:(BOOL)isOpenQA isOpenRecordChapter:(BOOL)isOpenRecordChapter isOpenVideoPoint:(BOOL)isOpenVideoPoint
{
    self.isOpenDoc = isOpenDoc;
    self.isOpenQA = isOpenQA;
    self.isOpenRecordChapter = isOpenRecordChapter;
    self.isOpenVideoPoint = isOpenVideoPoint;

    // 获取当前显示的标签页名称
    NSString *selectTitle = self.listContainerArray[self.categoryView.selectedIndex];

    // 清空所有
    [self.listContainerArray removeAllObjects];

    // 添加剩余的
    [self.listContainerArray addObject:@"聊天"];

    if (isOpenDoc) {
        [self.listContainerArray addObject:@"文档"];
    }

    [self.listContainerArray addObject:@"简介"];

    if (isOpenQA) {
        [self.listContainerArray addObject:self.questionName];
    }

    if (isOpenRecordChapter) {
        [self.listContainerArray addObject:@"章节"];
    }

    if (isOpenVideoPoint) {
        [self.listContainerArray addObject:@"精彩时刻"];
    }
    
    if ((self.type == VHMovieActiveStateReplay || self.type == VHMovieActiveStatePlayBack) && self.recordList.count > 1) {
        [self.listContainerArray addObject:@"精彩片段"];
    }

    // 添加
    self.categoryView.titles = self.listContainerArray;

    // 刷新
    [self.categoryView reloadData];

    // 切换选中的标签页
    BOOL isHave = [self.categoryView.titles containsObject:selectTitle];

    if (isHave) {
        [self.categoryView selectItemAtIndex:(int)[self.categoryView.titles indexOfObject:selectTitle]];
    } else {
        [self.categoryView selectItemAtIndex:0];
    }

    // 更多工具显示状态
    [self foldBtnIsHidden];
}

#pragma mark - VHWatchVideoViewDelegate
#pragma mark 播放连接成功
- (void)connectSucceed:(VHallMoviePlayer *)moviePlayer info:(NSDictionary *)info
{
    // 设置标题
    self.title = [VUITool substringToIndex:8 text:moviePlayer.webinarInfo.webinarInfoData.webinar.subject isReplenish:YES];

    // 连接消息,并加载数据
    [self.chatView requestDataWithVHObject:moviePlayer webinarInfoData:moviePlayer.webinarInfo.webinarInfoData];

    // 初始化互动工具
    [self initWithInteractiveTool];
}

#pragma mark 初始化互动工具
- (void)initWithInteractiveTool
{
    // 初始化简介
    self.introView.webinarInfoData = self.watchVideoView.moviePlayer.webinarInfo.webinarInfoData;
    
    // 精彩片段
    if (self.type == VHMovieActiveStateReplay || self.type == VHMovieActiveStatePlayBack) {
        self.recordListVC.record_id = self.watchVideoView.moviePlayer.webinarInfo.webinarInfoData.record.record_id;
        __weak __typeof(self)weakSelf = self;
        [VHRecordListModel getRecordListWithWebinarId:self.webinar_id pageNum:1 pageSize:10 complete:^(NSArray<VHRecordListModel *> *recordList, NSError *error) {
            weakSelf.recordList = recordList;
            [weakSelf roomWithIsOpenDoc:weakSelf.isOpenDoc isOpenQA:weakSelf.isOpenQA isOpenRecordChapter:weakSelf.isOpenRecordChapter isOpenVideoPoint:weakSelf.isOpenVideoPoint];
        }];
    }

    // 初始化底部信息
    [self.bottomView requestObject:self.watchVideoView.moviePlayer webinarInfoData:self.watchVideoView.moviePlayer.webinarInfo.webinarInfoData];

    // 初始化问答
    self.vhQAView = [[VHQAView alloc] initQAWithFrame:self.view.frame obj:self.watchVideoView.moviePlayer webinarInfoData:self.watchVideoView.moviePlayer.webinarInfo.webinarInfoData];
    self.vhQAView.delegate = self;

    // 初始化章节
    if (self.watchVideoView.moviePlayer.webinarInfo.webinarInfoData.webinar.type == 4 || self.watchVideoView.moviePlayer.webinarInfo.webinarInfoData.webinar.type == 5) {
        self.recordChapterView = [[VHRecordChapter alloc] initRCWithFrame:self.view.frame webinarInfoData:self.watchVideoView.moviePlayer.webinarInfo.webinarInfoData];
        self.recordChapterView.delegate = self;
    }

    // 初始化问卷
    self.surveyListView = [[VHSurveyListView alloc] initSurveyWithObject:self.watchVideoView.moviePlayer webinarInfoData:self.watchVideoView.moviePlayer.webinarInfo.webinarInfoData];
    self.surveyListView.delegate = self;

    // 初始化礼物
    self.giftObject = [[VHallGiftObject alloc] initWithObject:self.watchVideoView.moviePlayer];
    self.giftObject.delegate = self;

    // 初始化签到
    self.signInAlertView = [[VHSignInAlertView alloc] initSignWithFrame:self.view.frame obj:self.watchVideoView.moviePlayer webinarInfoData:self.watchVideoView.moviePlayer.webinarInfo.webinarInfoData];
    self.signInAlertView.delegate = self;

    // 初始化抽奖
    self.vhLottery = [[VHLottery alloc] initLotteryWithObj:self.watchVideoView.moviePlayer webinarInfoData:self.watchVideoView.moviePlayer.webinarInfo.webinarInfoData];
    self.vhLottery.delegate = self;

    self.vhExam = [[VHExamObject alloc] initWithObject:self.watchVideoView.moviePlayer];
    self.vhExam.delegate = self;
}

#pragma mark 主持人显示/隐藏文档
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer isHaveDocument:(BOOL)isHave isShowDocument:(BOOL)isShow
{
    BOOL isOpen = isHave && isShow ? YES : NO;

    // 判断是否显示
    [self roomWithIsOpenDoc:isOpen isOpenQA:self.isOpenQA isOpenRecordChapter:self.isOpenRecordChapter isOpenVideoPoint:self.isOpenVideoPoint];
    // 文档显示隐藏
    moviePlayer.documentView.hidden = !isOpen;
    // 赋值文档
    [self.docViewController addToDocumentView:moviePlayer.documentView];

    // 全屏的话,需要切换为竖屏
    if (self.isFull && !isOpen) {
        [self docWithIsFull:NO];
    }
}

#pragma mark 直播文档同步，直播文档有延迟，指定需要延迟的秒数 （默认为直播缓冲时间，即：realityBufferTime/1000.0）
- (NSTimeInterval)documentDelayTime:(VHallMoviePlayer *)moviePlayer
{
    return self.isLive ? moviePlayer.realityBufferTime / 1000.0 : 0;
}

#pragma mark 是否文档全屏
- (void)fullWithSelect:(BOOL)isSelect
{
    [self docWithIsFull:isSelect];
}

#pragma mark 发布公告的回调
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer announcementContentDidChange:(NSString *)content pushTime:(NSString *)pushTime duration:(NSInteger)duration
{
    // 刷新接口
    [self.announcementList loadDataRoomId:self.watchVideoView.moviePlayer.webinarInfo.webinarInfoData.interact.room_id isShow:NO];

    // 显示公告
    [self.announcementView startAnimationWithContent:content pushTime:pushTime duration:duration view:self.listContainerView isFull:self.isFull];
}

#pragma mark 返回视频打点数据（若存在打点信息）
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer videoPointArr:(NSArray <VHVidoePointModel *> *)pointArr
{
    self.videoPointView = [[VHVideoPointView alloc] initVPWithFrame:self.view.frame videoPointArr:pointArr];
    self.videoPointView.delegate = self;
    // 判断是否显示
    [self roomWithIsOpenDoc:self.isOpenDoc isOpenQA:self.isOpenQA isOpenRecordChapter:self.isOpenRecordChapter isOpenVideoPoint:pointArr.count > 0 ? YES : NO];
}

#pragma mark - 互动
#pragma mark 当前活动是否允许举手申请上麦回调
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer isInteractiveActivity:(BOOL)isInteractive interactivePermission:(VHInteractiveState)state
{
    // 收起弹窗
    [self.inavApplyAlertView stopOrDismiss];
    // 是否允许举手
    [self.bottomView isInteractiveActivity:isInteractive interactivePermission:state];
}

#pragma mark 主持人是否同意上麦申请回调
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer microInvitationWithAttributes:(NSDictionary *)attributes error:(NSError *)error
{
    if (!error) {
        // 收起控件
        [self.inavApplyAlertView stopOrDismiss];
        // 主持人同意上麦申请,使用互动
        [self changePlayerIsLive:NO];
    } else {
        [VHProgressHud showToast:error.localizedDescription];
    }
}

#pragma mark 被主持人邀请上麦
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer microInvitation:(NSDictionary *)attributes
{
    int afterTime = (self.isDocFull || self.isVideoFull) ? 0.5 : 0;

    // 判断如果当前文档是横屏则需要旋转
    if (self.isDocFull) {
        [self.docViewController quitFull];
    }

    // 判断如果当前播放器是横屏则需要旋转
    if (self.isVideoFull) {
        [self.watchVideoView quitFull];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(afterTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{     // 去观看弹窗
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"邀请您上麦，是否同意？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *refuseAction = [UIAlertAction actionWithTitle:@"拒绝"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *_Nonnull action) {
            // 拒绝上麦
            [self replyInvitationWithType:NO];
        }];
        UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:@"同意"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *_Nonnull action) {
            // 判断权限
            __weak __typeof(self) weakSelf = self;
            [VUITool getMediaAccess:^(BOOL videoAccess, BOOL audioAcess) {
                if (videoAccess && audioAcess) {
                    // 同意上麦,使用互动
                    [weakSelf replyInvitationWithType:YES];
                    [weakSelf changePlayerIsLive:NO];
                } else {
                    [VHProgressHud showToast:@"请开启麦克风和摄像头权限"];
                    // 拒绝上麦
                    [weakSelf replyInvitationWithType:NO];
                }
            }];
        }];
        agreeAction.accessibilityLabel = VHTests_Inav_AgreeInav;
        [agreeAction setValue:VHMainColor forKey:@"titleTextColor"];
        [alertController addAction:refuseAction];
        [alertController addAction:agreeAction];
        [self presentViewController:alertController
                           animated:YES
                         completion:^{
            // 自动化测试,邀请上麦
            [VUITool sendTestsNotificationCenterWithKey:VHTests_NC_MicroInvitation
                                              otherInfo:nil];
        }];
    });
}

#pragma mark 收到邀请后是否同意上麦
- (void)replyInvitationWithType:(BOOL)isAgree
{
    if (isAgree) {
        // 显示连麦按钮
        [self.bottomView isInteractiveActivity:YES interactivePermission:VHInteractiveStateHave];
    }

    [self.watchVideoView.moviePlayer replyInvitationWithType:isAgree ? 1 : 2 finish:^(NSError *error) { if (error) { [VHProgressHud showToast:error.localizedDescription]; } }];
}

#pragma mark 屏幕旋转
- (void)clickFullIsSelect:(BOOL)isSelect
{
    // 只有直播可以切换横竖屏
    if (self.isLive) {
        // 切换全屏 横竖屏刷新布局
        [self screenChangeWithIsFull:isSelect];
    }
}

#pragma mark 直播已结束回调
- (void)liveDidStoped:(VHallMoviePlayer *)moviePlayer
{
    if (self.type == VHMovieActiveStateLive) {
        [self clickLeftBarItem];
    }
}

#pragma mark 被踢出
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer isKickout:(BOOL)isKickout
{
    [self clickLeftBarItem];
}

#pragma mark - VHInavViewDelegate
#pragma mark 下麦
- (void)unApplyAction
{
    // 播放直播或回放
    [self changePlayerIsLive:YES];
}

#pragma mark 退出互动
- (void)errorLeaveInav
{
    // 播放直播或回放
    [self changePlayerIsLive:YES];
}

#pragma mark 被踢出
- (void)isKickout:(BOOL)isKickout
{
    [self clickLeftBarItem];
}

#pragma mark 退出房间
- (void)leaveRoom
{
    [self clickLeftBarItem];
}

#pragma mark - VHChatViewDelegate
#pragma mark 收到上下线消息
- (void)reciveOnlineMsg:(NSArray <VHallOnlineStateModel *> *)msgs
{
    [self.watchVideoView reciveOnlineMsg:msgs];
}

#pragma mark 收到自己被禁言/取消禁言
- (void)forbidChat:(BOOL)forbidChat
{
    [self.bottomView forbidChat:forbidChat];
}

#pragma mark 收到全体禁言/取消全体禁言
- (void)allForbidChat:(BOOL)allForbidChat
{
    [self.bottomView allForbidChat:allForbidChat];
}

#pragma mark 问答状态
- (void)isQaStatus:(BOOL)isQaStatus
{
    [self.bottomView isQaStatus:isQaStatus];
}

#pragma mark 收到虚拟人数消息
- (void)vhBaseNumUpdateToUpdate_online_num:(NSInteger)update_online_num
                                 update_pv:(NSInteger)update_pv
{
    [self.watchVideoView vhBaseNumUpdateToUpdate_online_num:update_online_num update_pv:update_pv];
}

#pragma mark 点击查看中奖名单
- (void)clickCheckWinListWithEndLotteryModel:(VHallEndLotteryModel *)endLotteryModel
{
    [self.vhLottery clickCheckWinListWithEndLotteryModel:endLotteryModel];
}

#pragma mark - VHWatchLiveBottomViewDelegate
#pragma mark 发送消息
- (void)sendText:(NSString *)text
{
    NSString *title = self.listContainerArray[self.categoryView.selectedIndex];

    if ([title isEqualToString:self.questionName]) {
        [self.vhQAView sendQAMsg:text];
    } else {
        [self.chatView sendText:text];
    }
}

#pragma mark 点击礼物回调
- (void)clickGift
{
    [self.view addSubview:self.giftListView];
    [self.giftListView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.giftListView showGiftToWebinarInfoData:self.watchVideoView.moviePlayer.webinarInfo.webinarInfoData];
}

#pragma mark 点击参与互动连麦
- (void)clickInav
{
    if (self.isLive) {
        [self.inavApplyAlertView show];
    } else {
        [self.inavView clickInavRenderAlertViewIsShow:YES];
    }
}

#pragma mark 是否开启了回放章节
- (void)watchRecordChapterIsOpen:(BOOL)isOpen
{
    // 判断是否显示
    [self roomWithIsOpenDoc:self.isOpenDoc isOpenQA:self.isOpenQA isOpenRecordChapter:isOpen isOpenVideoPoint:self.isOpenVideoPoint];
}

#pragma mark - VHQAViewDelegate
#pragma mark 问答是否打开
- (void)vhQAIsOpen:(BOOL)isOpen
{
    self.questionName = [VUITool isBlankString:self.vhQAView.vhQA.question_name] ? @"问答" : self.vhQAView.vhQA.question_name;

    [self roomWithIsOpenDoc:self.isOpenDoc isOpenQA:isOpen isOpenRecordChapter:self.isOpenRecordChapter isOpenVideoPoint:self.isOpenVideoPoint];

    // 自定义消息
    [self.chatView chatCustomWithNickName:[VUITool isBlankString:self.watchVideoView.moviePlayer.webinarInfo.author_nickname] ? @"主持人" : self.watchVideoView.moviePlayer.webinarInfo.author_nickname roleName:1 content:[NSString stringWithFormat:@"%@了问答", isOpen ? @"开启" : @"关闭"] info:nil];
}

#pragma mark 当前是否开启问答功能
- (void)moviePlayer:(VHallMoviePlayer *)moviePlayer isQuestion_status:(BOOL)isQuestion_status question_name:(NSString *)questionName
{
    self.questionName = [VUITool isBlankString:questionName] ? @"问答" : questionName;

    [self roomWithIsOpenDoc:self.isOpenDoc isOpenQA:isQuestion_status isOpenRecordChapter:self.isOpenRecordChapter isOpenVideoPoint:self.isOpenVideoPoint];
}

#pragma mark - VHRecordChapterDelegate
#pragma mark 点击章节
- (void)clickChapterItemCreateAt:(CGFloat)createAt
{
    self.watchVideoView.moviePlayer.currentPlaybackTime = createAt;
}

#pragma mark - VHVideoPointViewDelegate
#pragma mark 点击视频打点
- (void)clickVideoPointTime:(NSInteger)time
{
    self.watchVideoView.moviePlayer.currentPlaybackTime = time;
}

#pragma mark - VHRecordListDelegate
#pragma mark 选择指定回放视频
- (void)selectPlaybackVideoWithRecordId:(NSString *)recordId {
    // 判断是否显示
    [self roomWithIsOpenDoc:self.isOpenDoc isOpenQA:self.isOpenQA isOpenRecordChapter:self.isOpenRecordChapter isOpenVideoPoint:NO];
    [self.videoPointView removeFromSuperview];
    self.videoPointView = nil;
    // 播放新的
    [self.watchVideoView startPlayBackWithRecordId:recordId];
}

#pragma mark - VHallGiftObjectDelegate
#pragma mark 收到礼物
- (void)vhGifttoModel:(VHallGiftModel *)model
{
    // 给聊天模块增加数据
    [self.chatView vhGifttoModel:model];
}

#pragma mark - VHSignInAlertViewDelegate
#pragma mark 收到主持人发起签到消息
- (void)startSign
{
    // 自定义消息
    [self.chatView chatCustomWithNickName:[VUITool isBlankString:self.watchVideoView.moviePlayer.webinarInfo.author_nickname] ? @"主持人" : self.watchVideoView.moviePlayer.webinarInfo.author_nickname roleName:1 content:@"发起了签到" info:nil];
}

#pragma mark - VHSurveyObjectDelegate
#pragma mark 收到问卷
- (void)receivedSurveyWithURL:(NSURL *)surveyURL surveyId:(NSString *)surveyId
{
    // 刷新列表
    [self.surveyListView showSurveyIsShow:NO];
    // 自定义消息
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:@{ @"surveyURL": surveyURL, @"surveyId": surveyId }];
    [self.chatView chatCustomWithNickName:[VUITool isBlankString:self.watchVideoView.moviePlayer.webinarInfo.author_nickname] ? @"主持人" : self.watchVideoView.moviePlayer.webinarInfo.author_nickname roleName:1 content:@"发起了问卷" info:info];
}

#pragma mark 点击问卷
- (void)clickSurveyToId:(NSString *)surveyId surveyURL:(NSURL *)surveyURL
{
    [self.surveyListView clickSurveyToId:surveyId surveyURL:surveyURL];
}

#pragma mark - VHLotteryDelegate
#pragma mark 抽奖开始
- (void)startLottery:(VHallStartLotteryModel *)msg
{
    [self.chatView chatLotteryWithStartModel:msg endModel:nil];
}

#pragma mark 抽奖结束
- (void)endLottery:(VHallEndLotteryModel *)msg
{
    [self.chatView chatLotteryWithStartModel:nil endModel:msg];
}

#pragma mark - VHExamObjectDelegate
#pragma mark 收到快问快答消息
- (void)paperSendMessage:(VHMessage *)message examWebUrl:(NSURL *)examWebUrl
{
    if ([[UIApplication sharedApplication] canOpenURL:examWebUrl]) {
        NSDictionary *options = @{
                UIApplicationOpenURLOptionUniversalLinksOnly: @NO
        };
        [[UIApplication sharedApplication] openURL:examWebUrl options:options completionHandler:nil];
    }
}

#pragma mark - 直播和互动播放器切换
- (void)changePlayerIsLive:(BOOL)isLive
{
    // 如果状态重复不需要二次执行了
    if (self.isLive == isLive) {
        return;
    }

    // 刷新状态
    self.isLive = isLive;
    // 显隐
    _bottomView.isLive = isLive;

    if (isLive) {
        // 销毁互动
        if (_inavView) {
            [_inavView destroyMP];
            _inavView = nil;
        }

        // 布局
        [self.view addSubview:self.watchVideoView];
        [self.view insertSubview:_watchVideoView atIndex:0];
        [_watchVideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo((Screen_Width < Screen_Height ? Screen_Width : Screen_Height) * 9 / 16);
        }];

        [self.categoryView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.watchVideoView.mas_bottom);
        }];
        // 观看直播
        [_watchVideoView reconnectPlay];
    } else {
        // 销毁直播
        [_watchVideoView stopPlay];
        // 布局
        [self.view addSubview:self.inavView];
        [self.view insertSubview:_inavView atIndex:0];
        [_inavView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo((Screen_Width < Screen_Height ? Screen_Width : Screen_Height) * 9 / 16);
        }];

        [self.categoryView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.inavView.mas_bottom);
        }];
        // 参与互动
        [_inavView enterRoomWithWebinarId:self.webinar_id];
    }

    _watchVideoView.hidden = !isLive;
    _inavView.hidden = isLive;

    // 强制竖屏
    [self clickFullIsSelect:NO];
}

#pragma mark - 屏幕旋转
- (void)screenChangeWithIsFull:(BOOL)isFull
{
    // 状态一致不需要在执行
    if (self.isVideoFull == isFull) {
        return;
    }

    // 记录状态
    self.isVideoFull = isFull;

    // 旋转
    [self vcWithIsFull:isFull];

    // 更多工具显示状态
    [self foldBtnIsHidden];

    // 调整播放器
    if (isFull) {
        [_watchVideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
        }];
    } else {
        [_watchVideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo((Screen_Width < Screen_Height ? Screen_Width : Screen_Height) * 9 / 16);
        }];
    }
}

#pragma mark - 文档全屏
- (void)docWithIsFull:(BOOL)isFull
{
    // 状态一致不需要在执行
    if (self.isDocFull == isFull) {
        return;
    }

    // 记录文档状态
    self.isDocFull = isFull;

    // 旋转
    [self vcWithIsFull:isFull];

    // 隐藏公告
    self.announcementView.hidden = isFull;

    // 调整播放器
    if (isFull) {
        [_watchVideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.size.mas_equalTo(0);
        }];
        [_inavView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.size.mas_equalTo(0);
        }];
        [_categoryView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.size.mas_equalTo(0);
        }];
    } else {
        [_watchVideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo((Screen_Width < Screen_Height ? Screen_Width : Screen_Height) * 9 / 16);
        }];
        [_inavView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo((Screen_Width < Screen_Height ? Screen_Width : Screen_Height) * 9 / 16);
        }];
        [_categoryView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_watchVideoView.mas_bottom);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
    }
}

#pragma mark - 全屏
- (void)vcWithIsFull:(BOOL)isFull
{
    // 状态一致不需要在执行
    if (self.isFull == isFull) {
        return;
    }

    // 全屏状态
    self.isFull = isFull;

    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    if (isFull) {
        // 全屏操作
        appdelegate.launchScreen = YES;
    } else {
        // 退出全屏操作
        appdelegate.launchScreen = NO;
    }

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

    [self.navigationController.navigationBar setBackgroundImage:isFull ? nil : [UIImage imageWithColor:VHMainColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:isFull ? nil : [UIImage imageWithColor:VHMainColor]];
    [self.navigationController setNavigationBarHidden:isFull animated:NO];
}

#pragma mark - 前台
- (void)appWillEnterForeground
{
    [super appWillEnterForeground];

    // 如果是互动状态且当前停止推流了,则恢复旁路
    if (!self.isLive && !_inavView.inavRoom.isPublishing) {
        [self changePlayerIsLive:YES];
    }

    // 获取房间详情,如果是结束状态需要退出房间
    __weak __typeof(self) weakSelf = self;
    [VHWebinarInfoData requestWatchInitWebinarId:self.watchVideoView.moviePlayer.webinarInfo.webinarInfoData.webinar.data_id
                                            pass:nil
                                            k_id:nil
                                       nick_name:nil
                                           email:nil
                                       record_id:nil
                                      auth_model:1
                                        complete:^(VHWebinarInfoData *webinarInfoData, NSError *error) {
        // 有返回数据
        if (webinarInfoData) {
        // 如果状态不一致,则退出房间
            if (webinarInfoData.webinar.type != weakSelf.watchVideoView.moviePlayer.webinarInfo.webinarInfoData.webinar.type) {
                [weakSelf clickLeftBarItem];
            }
        }
    }];
}

#pragma mark - 后台
- (void)appDidEnterBackground
{
    [super appDidEnterBackground];
}

#pragma mark - 点击返回
- (void)clickLeftBarItem
{
    // 销毁互动
    if (_inavView) {
        [_inavView destroyMP];
        _inavView = nil;
    }

    // 销毁直播
    if (_watchVideoView) {
        [_watchVideoView destroyMP];
        _watchVideoView = nil;
    }

    // 返回上级
    [super clickLeftBarItem];
}

#pragma mark - 懒加载
- (JXCategoryTitleView *)categoryView
{
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.backgroundColor = [UIColor whiteColor];
        _categoryView.delegate = self;
        _categoryView.titleColor = [UIColor colorWithHex:@"#222222"];
        _categoryView.titleSelectedColor = [UIColor colorWithHex:@"#666666"];
        _categoryView.averageCellSpacingEnabled = NO;
        _categoryView.selectedAnimationEnabled = NO;
        _categoryView.contentScrollViewClickTransitionAnimationEnabled = NO;
        _categoryView.titles = self.listContainerArray;
        _categoryView.listContainer = self.listContainerView;
        _categoryView.collectionView.accessibilityLabel = VHTests_Intro_Click;
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorWidth = 20;
        lineView.indicatorHeight = 3;
        lineView.indicatorColor = VHMainColor;
        lineView.indicatorCornerRadius = 0;
        _categoryView.indicators = @[lineView];
        [self.view addSubview:_categoryView];
    }

    return _categoryView;
}

- (JXCategoryListContainerView *)listContainerView
{
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_CollectionView delegate:self];
        _listContainerView.scrollView.scrollEnabled = NO;
        [self.view addSubview:_listContainerView];
    }

    return _listContainerView;
}

- (NSMutableArray *)listContainerArray
{
    if (!_listContainerArray) {
        _listContainerArray = [NSMutableArray arrayWithObjects:@"聊天", @"简介", nil];
    }

    return _listContainerArray;
}

- (VHFoldButton *)foldBtn
{
    if (!_foldBtn) {
        NSArray *arr = @[@"问卷", @"公告"];
        NSMutableArray *datas = [NSMutableArray arrayWithCapacity:arr.count];

        for (NSString *title in arr) {
            VHFoldButtonItem *item = [[VHFoldButtonItem alloc]init];
            item.title = title;
            [datas addObject:item];
        }

        _foldBtn = [[VHFoldButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _foldBtn.hidden = YES;
        _foldBtn.foldButton.accessibilityLabel = VHTests_Fold_ClickBtn;
        [self.view addSubview:_foldBtn];

        [_foldBtn configDatas:datas];

        __weak __typeof(self) weakSelf = self;
        [_foldBtn didSelectedWithHandler:^(VHFoldButtonItem *obj, NSInteger index) {
            VHLog(@"%@", obj.title);

            if ([obj.title isEqualToString:@"问卷"]) {
                [weakSelf.view addSubview:weakSelf.surveyListView];
                [weakSelf.surveyListView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(weakSelf.view);
                }];
                [weakSelf.surveyListView showSurveyIsShow:YES];
            }

            if ([obj.title isEqualToString:@"公告"]) {
                [weakSelf.view addSubview:weakSelf.announcementList];
                [weakSelf.announcementList mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(weakSelf.view);
                }];
                [weakSelf.announcementList loadDataRoomId:weakSelf.watchVideoView.moviePlayer.webinarInfo.webinarInfoData.interact.room_id
                                                   isShow:YES];
            }
        }];
    }

    return _foldBtn;
}

#pragma mark - 更多工具显示状态
- (void)foldBtnIsHidden
{
    NSString *title = self.listContainerArray[self.categoryView.selectedIndex];

    if (self.watchVideoView.moviePlayer.webinarInfo.webinarInfoData.webinar.type == 1 && !self.isFull) {
        self.foldBtn.hidden = ![title isEqualToString:@"聊天"];
    } else {
        self.foldBtn.hidden = YES;
    }
}

- (VHWatchVideoView *)watchVideoView
{
    if (!_watchVideoView) {
        _watchVideoView = [[VHWatchVideoView alloc] initWithWebinarId:self.webinar_id type:self.type];
        _watchVideoView.delegate = self;
        [self.view addSubview:_watchVideoView];
    }

    return _watchVideoView;
}

- (VHInavView *)inavView
{
    if (!_inavView) {
        _inavView = [[VHInavView alloc] init];
        _inavView.delegate = self;
        _inavView.hidden = YES;
        [self.view addSubview:_inavView];
    }

    return _inavView;
}

- (VHChatView *)chatView
{
    if (!_chatView) {
        _chatView = [[VHChatView alloc] init];
        _chatView.delegate = self;
    }

    return _chatView;
}

- (VHDocViewController *)docViewController
{
    if (!_docViewController) {
        _docViewController = [[VHDocViewController alloc] init];
        _docViewController.delegate = self;
    }

    return _docViewController;
}

- (VHIntroView *)introView
{
    if (!_introView) {
        _introView = [[VHIntroView alloc] init];
    }

    return _introView;
}

- (VHRecordListVC *)recordListVC
{
    if (!_recordListVC) {
        _recordListVC = [[VHRecordListVC alloc] init];
        _recordListVC.delegate = self;
        _recordListVC.webinar_id = self.webinar_id;
    }
    
    return _recordListVC;
}

- (VHWatchLiveBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[VHWatchLiveBottomView alloc] init];
        _bottomView.delegate = self;
        _bottomView.isLive = self.isLive;
        [self.view addSubview:_bottomView];
    }

    return _bottomView;
}

- (VHFashionStyleGiftListView *)giftListView
{
    if (!_giftListView) {
        _giftListView = [VHFashionStyleGiftListView new];
        [self.view addSubview:_giftListView];
    }

    return _giftListView;
}

- (VHAnnouncementList *)announcementList
{
    if (!_announcementList) {
        _announcementList = [[VHAnnouncementList alloc] initWithFrame:self.view.frame];
    }

    return _announcementList;
}

- (VHAnnouncementView *)announcementView
{
    if (!_announcementView) {
        _announcementView = [[VHAnnouncementView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 40)];
        _announcementView.accessibilityLabel = VHTests_Announcement_Show;
    }

    return _announcementView;
}

- (VHInavApplyAlertView *)inavApplyAlertView
{
    if (!_inavApplyAlertView) {
        _inavApplyAlertView = [[VHInavApplyAlertView alloc] initWithFrame:self.view.frame];
        _inavApplyAlertView.moviePlayer = self.watchVideoView.moviePlayer;
        [self.view addSubview:_inavApplyAlertView];
        [_inavApplyAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
        }];
    }

    return _inavApplyAlertView;
}

#pragma mark - 释放
- (void)dealloc
{
    VHLog(@"%s释放", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String]);
}

@end
