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
#import "WatchLiveOnlineTableViewCell.h"
#import <VHLiveSDK/VHallApi.h>
#import "VHKeyboardToolView.h"
#import "MJRefresh.h"
#import "AnnouncementView.h"
#import "DLNAView.h"
#import "VHPlayerView.h"
#import "UIAlertController+ITTAdditionsUIModel.h"
#import "VHDocFullScreenViewController.h"
#import "VHActionSheet.h"

#define RATEARR @[@1.0,@1.25,@1.5,@2.0,@0.5,@0.67,@0.8]//倍速播放循环顺序

static AnnouncementView* announcementView = nil;
@interface WatchPlayBackViewController ()<VHallMoviePlayerDelegate,UITableViewDelegate,UITableViewDataSource,VHPlayerViewDelegate,DLNAViewDelegate,VHKeyboardToolViewDelegate,VHallChatDelegate>
{
    NSArray*_videoLevePicArray;
    NSArray* _definitionList;
    BOOL _loadedChatHistoryList; //是否请求过历史聊天记录
}
@property (nonatomic) VHDocFullScreenViewController *docFullScreen;
@property (nonatomic,strong) VHallMoviePlayer  *moviePlayer;//播放器
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *docConentView;//文档容器
@property (weak, nonatomic) IBOutlet UIView *docAreaView;
@property (weak, nonatomic) IBOutlet UIButton *docFullScreenButton; // 文档全屏按钮
@property (nonatomic,assign) VHMovieVideoPlayMode playModelTemp;
@property (nonatomic,strong) VHPlayerView *playMaskView;
@property (nonatomic,assign) CGRect originFrame;
@property (nonatomic,strong) UIView *originView;
@property (weak, nonatomic) IBOutlet UILabel *liveTypeLabel;
@property (weak, nonatomic) IBOutlet UIView *tableViewContentView;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIButton *docBtn;
@property (weak, nonatomic) IBOutlet UIButton *detalBtn;
@property (weak, nonatomic) IBOutlet UIView *showView;
@property(nonatomic,strong)   DLNAView           *dlnaView;
@property (weak, nonatomic) IBOutlet UIButton *dlnaBtn;
@property (weak, nonatomic) IBOutlet UILabel *noDocTipLab;

@property (weak, nonatomic) IBOutlet UIButton *definitionBtn;
@property (weak, nonatomic) IBOutlet UIButton *rateBtn;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic, strong) VHallChat *chat;     //聊天
@property (nonatomic, assign) BOOL watch_record_no_chatting;///<是否开启回放禁言
@property (nonatomic, assign) BOOL watch_record_chapter;///<是否开启回放章节打点
@property (nonatomic,assign) int  pageNum; //聊天记录页码
@property (nonatomic,strong) NSMutableArray *chatArray;//聊天数据源
@property (nonatomic , assign) BOOL isCast_screen; //投屏权限
@property (nonatomic,strong) VHKeyboardToolView * messageToolView;  //输入view
@property (nonatomic,assign) BOOL  isPreLoad;//预加载状态
@property (nonatomic, strong) UIButton * chaptersBtn;///<章节按钮
@property (nonatomic, copy) NSArray <VHChaptersItem *> * chaptersList;///<章节打点列表
@end

@implementation WatchPlayBackViewController

- (void)dealloc
{
    //阻止iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    VHLog(@"%@ dealloc",[[self class]description]);
}

- (id)init
{
    self = LoadVCNibName;
    if (self) {
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self updataFrame];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    //预加载视频
//    [self.moviePlayer preLoadRoomWithParam:[self playParam]];
    self.moviePlayer.initialPlaybackTime = 0;
    self.isPreLoad = YES;
    [self.moviePlayer startPlayback:[self playParam]];
    [self.docFullScreenButton setImage:BundleUIImage(@"live_bottomTool_clear") forState:UIControlStateNormal];
}

- (void)updataFrame {
    _tableView.frame = _tableViewContentView.bounds;
    _backView.frame = _backView.frame;
    _moviePlayer.moviePlayerView.frame = _backView.bounds;
    _playMaskView.frame = _moviePlayer.moviePlayerView.bounds;
}

#pragma mark - Private Method
- (void)initViews
{
    //阻止iOS设备锁屏
    self.view.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self registerLiveNotification];
    
    _chat = [[VHallChat alloc] initWithMoviePlayer:self.moviePlayer];
    _chat.delegate = self;
    
    _videoLevePicArray = @[@"原画",@"超清",@"高清",@"标清",@"语音开启",@""];
    
    //tableView相关设置
    [self configTableView];
    
    _chatArray = [NSMutableArray array];
    _docConentView.hidden = YES;
    
    //遮盖
    [self.moviePlayer.moviePlayerView addSubview:self.playMaskView];
    
    [self.backView addSubview:self.moviePlayer.moviePlayerView];
    [self.backView sendSubviewToBack:self.moviePlayer.moviePlayerView];
    
    if (self.playModelTemp == VHMovieVideoPlayModeTextAndVoice ) {
        self.liveTypeLabel.text = @"语音回放中";
    }else{
        self.liveTypeLabel.text = @"";
    }

    // 章节按钮
    [self addChaptersView];
}


- (void)destoryMoivePlayer
{
    [_moviePlayer destroyMoivePlayer];
}

//注册通知
- (void)registerLiveNotification
{
    //已经进入活跃状态的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive)name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //监听耳机的插拔
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(outputDeviceChanged:)name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
}

- (NSDictionary *)playParam {
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    param[@"id"] =  _roomId;
    if (_kValue&&_kValue.length>0) {
        param[@"pass"] = _kValue;
    }
    if (_k_id &&_k_id.length>0) {
        param[@"k_id"] = _k_id;
    }
//    param[@"name"] = [UIDevice currentDevice].name;
//    param[@"email"] = [NSString stringWithFormat:@"%@@qq.com",[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    return param;
}


- (void)startPlayback
{
    [ProgressHud showLoading];
    [_moviePlayer startPlayback:[self playParam]];
}

#pragma mark - 关闭
- (IBAction)closeBtnClick:(id)sender
{
    [_moviePlayer pausePlay];
    [_moviePlayer destroyMoivePlayer];
    _moviePlayer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 屏幕自适应
- (IBAction)allScreenBtnClick:(UIButton*)sender
{
    NSInteger mode = self.moviePlayer.movieScalingMode+1;
    if(mode >= 3) {
        mode = 0;
    }
    self.moviePlayer.movieScalingMode = mode;
    NSString *string = [NSString stringWithFormat:@"切换裁切模式%zd",mode];
    VH_ShowToast(string);
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
    
    VHMovieDefinition _leve = _moviePlayer.curDefinition;
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
    
    [ProgressHud hideLoading];
    [_moviePlayer setCurDefinition:_leve];
    [_definitionBtn setImage:BundleUIImage(_videoLevePicArray[_moviePlayer.curDefinition]) forState:UIControlStateNormal];
    _playModelTemp=_moviePlayer.playMode;
}

#pragma mark - 聊天
- (IBAction)chatButtonClick:(UIButton *)sender {
    sender.selected = YES;
    _docBtn.selected = NO;
    _detalBtn.selected = NO;
    _docConentView.hidden = YES;
    _tableViewContentView.hidden = NO;
    if (!_loadedChatHistoryList) {
        [self loadChatListData:1];
    }
}

//获取历史聊天记录
- (void)loadChatListData:(NSInteger)page
{
    __weak typeof(self) weakSelf = self;
    NSString * msg_id = @"";
    if (page > 1 && self.chatArray.count > 0) {
        VHallChatModel * msgFirstModel = [self.chatArray firstObject];
        msg_id = msgFirstModel.msg_id;
    }else{
        msg_id = @"";
    }
    [_chat getInteractsChatGetListWithMsg_id:msg_id page_num:page page_size:10 start_time:nil is_role:0 anchor_path:nil success:^(NSArray<VHallChatModel *> *msgs) {
        if(page == 1) {
            weakSelf.chatArray = [NSMutableArray arrayWithArray:msgs];
            weakSelf.pageNum = 1;
            [weakSelf.tableView reloadData];
            if(weakSelf.chatArray.count > 0) {
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.chatArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
            _loadedChatHistoryList = YES;
        }else {
            if (msgs.count > 0) {
                weakSelf.pageNum ++;
                //防止获取的聊天记录与实时消息重复，需要过滤
                NSMutableArray *mutaArr = [NSMutableArray arrayWithArray:msgs];
                for(VHallChatModel *message in weakSelf.chatArray) {
                    for(VHallChatModel *newMessage in mutaArr.reverseObjectEnumerator) {
                        if([newMessage.msg_id isEqualToString:message.msg_id]) {
                            [mutaArr removeObject:newMessage];
                        }
                    }
                }
                NSRange range = NSMakeRange(0,mutaArr.count);
                [weakSelf.chatArray insertObjects:mutaArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
            }
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    } failed:^(NSDictionary *failedData) {
        NSString* errorInfo = [NSString stringWithFormat:@"%@---%@", failedData[@"content"], failedData[@"code"]];
        NSLog(@"获取历史聊天记录失败：%@",errorInfo);
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 文档
- (IBAction)docButtonClick:(UIButton *)sender {
    sender.selected = YES;
    _chatBtn.selected = NO;
    _detalBtn.selected = NO;
    _tableViewContentView.hidden = YES;
    _docConentView.hidden = NO;
}
- (IBAction)onClickDocFullScreenButton:(UIButton *)sender {
    self.docFullScreen = [VHDocFullScreenViewController new];
    self.docFullScreen.docView = _moviePlayer.documentView;
    __weak typeof(self) wself = self;
    self.docFullScreen.handleDismiss = ^(UIView * _Nonnull docView) {
        __strong typeof(wself) self = wself;
        if(docView!=nil){
            [docView setFrame:self.docAreaView.bounds];
            [self.docAreaView addSubview:docView];
        }
    };
    [self presentViewController:self.docFullScreen animated:NO completion:nil];
}

#pragma mark - 详情
- (IBAction)detailBtnClick:(UIButton *)sender {
    sender.selected = YES;
    _docBtn.selected = NO;
    _chatBtn.selected = NO;
    _tableViewContentView.hidden = YES;
    _docConentView.hidden = YES;
}

#pragma mark - 获取房间配置项权限
- (void)getPermissionsCheck
{
    __weak __typeof(self)weakSelf = self;
    [VHWebinarBaseInfo permissionsCheckWithWebinarId:self.moviePlayer.webinarInfo.webinarId webinar_user_id:self.moviePlayer.webinarInfo.author_userId scene_id:@"1" success:^(VHPermissionConfigItem * _Nonnull item) {
        
        // 是否开启回放禁言
        weakSelf.watch_record_no_chatting = item.watch_record_no_chatting;
        // 是否开启回放章节打点
        weakSelf.watch_record_chapter = item.watch_record_chapter;
        
        // 获取章节打点
        if (weakSelf.watch_record_chapter) {
            [weakSelf requestRecordChaptersList:self.moviePlayer.webinarInfo.webinarInfoData.record.record_id];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 章节打点功能↓↓↓↓↓↓
//获取章节打点
- (void)requestRecordChaptersList:(NSString *)record_id
{
    __weak __typeof(self)weakSelf = self;
    [VHChaptersObject getRecordChaptersList:record_id complete:^(NSArray<VHChaptersItem *> *chaptersList, NSError *error) {
        weakSelf.chaptersBtn.hidden = YES;
        if (chaptersList.count > 0){
            weakSelf.chaptersBtn.hidden = NO;
            weakSelf.chaptersList = chaptersList;
        }
        if (error){
            VH_ShowToast(error.localizedDescription);
        }
    }];
}
//添加章节打点控件
- (void)addChaptersView{
    [self.chaptersBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.moviePlayer.moviePlayerView.mas_bottom).offset(50);
    }];
}
//点击章节打点按钮 展开章节打点列表
- (void)clickChaptersBtnAction
{
    VHActionSheet *actionSheet = [VHActionSheet sheetWithTitle:@"章节" cancelButtonTitle:@"取消" clicked:^(VHActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 0){return;}
        VHChaptersItem * item = self.chaptersList[buttonIndex-1];
        [self.moviePlayer setCurrentPlaybackTime:floor(item.created_at)];
    } otherButtonTitles:nil];
    
    actionSheet.scrolling = YES;
    actionSheet.visibleButtonCount = 5;
    
    for (int i = 0; i<self.chaptersList.count; i++) {
        VHChaptersItem * item = self.chaptersList[i];
        [actionSheet appendButtonWithTitle:[NSString stringWithFormat:@"标题%@          时间%@",item.title,[self timeFormat:item.created_at]] atIndex:i+1];
    }
    [actionSheet show];
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
- (void)Vh_fullScreenButtonAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if(sender.selected) { //横屏
        [self forceRotateUIInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
    } else { //退出横屏
        [self forceRotateUIInterfaceOrientation:UIInterfaceOrientationPortrait];
    }
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

#pragma mark - VHallChatDelegate
//收到上下线消息
- (void)reciveOnlineMsg:(NSArray <VHallOnlineStateModel *> *)msgs {
    [self reloadDataWithMsg:msgs];
}

//收到聊天消息
- (void)reciveChatMsg:(NSArray <VHallChatModel *> *)msgs {
    NSString *currentUserId = self.moviePlayer.webinarInfo.webinarInfoData.join_info.third_party_user_id;
    NSArray *msgArr = [VHHelpTool filterPrivateMsgCurrentUserId:currentUserId origin:msgs isFilter:YES half:NO];
    [self reloadDataWithMsg:msgArr];
}

//收到自定义消息
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
    [self reloadDataWithMsg:msgs];
}

- (void)reloadDataWithMsg:(NSArray *)msgs {
    if (msgs.count == 0) {
        return;
    }
    [_chatArray addObjectsFromArray:msgs];
    if (_chatBtn.selected) {
        [_tableView reloadData];
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_chatArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

/// 收到自己被禁言/取消禁言
/// @param forbidChat YES:禁言 NO:取消禁言
- (void)forbidChat:(BOOL)forbidChat
{
    
}

/// 收到全体禁言/取消全体禁言
/// @param allForbidChat YES:禁言 NO:取消禁言
- (void)allForbidChat:(BOOL)allForbidChat
{
    
}

#pragma mark - VHMoviePlayerDelegate

- (void)preLoadVideoFinish:(VHallMoviePlayer*)moviePlayer activeState:(VHMovieActiveState)activeState error:(NSError*)error
{
    if(error) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@（%zd）",error.localizedDescription,error.code];
        [UIAlertController showAlertControllerTitle:@"视频信息预加载失败" msg:errorMsg btnTitle:@"确定" callBack:nil];
    }else {
        if(activeState == VHMovieActiveStateReplay) {
            [self startPlayback];
        } else {
            [UIAlertController showAlertControllerTitle:@"提示" msg:@"当前活动非回放状态" btnTitle:@"确定" callBack:nil];
        }
        //获取历史聊天记录
        [self chatButtonClick:self.chatBtn];
    }
}

- (void)connectSucceed:(VHallMoviePlayer *)moviePlayer
                  info:(NSDictionary *)info
{
    // 获取房间配置项权限
    [self getPermissionsCheck];
}

- (void)playError:(VHSaasLivePlayErrorType)livePlayErrorType info:(NSDictionary *)info;
{
    [ProgressHud hideLoading];
    NSString * msg = @"";
    switch (livePlayErrorType) {
        case VHSaasLivePlayGetUrlError:
        {
            msg = info[@"content"];
            VH_ShowToast(msg);
            NSLog( @"播放失败 %@ %@",info[@"code"],info[@"content"]);
        }
            break;
        case VHSaasVodPlayError:
        {
            msg = @"播放超时,请检查网络后重试";
            VH_ShowToast(msg);
            NSLog( @"播放失败 %@ %@",info[@"code"],info[@"content"]);
        }
            break;
        case VHSaasPlaySSOKickout:{
            //开启单点登陆被踢出
            msg = @"当前已在其他设备观看";
            VH_ShowToast(msg);
            NSLog( @"播放失败 %@ %@",info[@"code"],info[@"content"]);
            NSString *errorStr = info[@"content"];
            NSInteger code = [info[@"code"] integerValue];
            [_moviePlayer stopPlay];
            [_moviePlayer destroyMoivePlayer];
            [UIAlertController showAlertControllerTitle:@"提示" msg:[NSString stringWithFormat:@"%zd-%@",code,errorStr] btnTitle:@"确定" callBack:^{
                if(code == 20023) { //同一账号多端观看

                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }
            break;
        default:
            break;
    }
    
    _playMaskView.playButton.selected  = NO;
}


- (void)moviePlayer:(VHallMoviePlayer *)player isHaveDocument:(BOOL)isHave isShowDocument:(BOOL)isShow
{
    VHLog(@"isShowDocument %d",(int)isShow);

    if(isHave)
    {
        _moviePlayer.documentView.frame = self.docAreaView.bounds;
        [self.docAreaView addSubview:_moviePlayer.documentView];
    }
    _moviePlayer.documentView.hidden = !isShow;
}

- (void)VideoPlayMode:(VHMovieVideoPlayMode)playMode isVrVideo:(BOOL)isVrVideo
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

- (void)ActiveState:(VHMovieActiveState)activeState
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


- (void)bufferStart:(VHallMoviePlayer *)moviePlayer info:(NSDictionary *)info
{
    NSLog(@"bufferStart");
    [ProgressHud showLoading];
}

- (void)bufferStop:(VHallMoviePlayer *)moviePlayer info:(NSDictionary *)info
{
    NSLog(@"bufferStop");
    [ProgressHud hideLoading];
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
            [ProgressHud hideLoading];
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
        case VHPlayerStateComplete:
            _playMaskView.playButton.selected  = NO;
        default:
            break;
    }
}

- (void)moviePlayer:(VHallMoviePlayer*)player currentTime:(NSTimeInterval)currentTime
{
//    if (self.isPreLoad) {
//        [player reconnectPlay];
//        self.isPreLoad = NO;
//    }
    [self monitorVideoPlayback];
}

- (void)moviePlayer:(VHallMoviePlayer *)player isCast_screen:(BOOL)isCast_screen
{
    self.isCast_screen = isCast_screen;
}

-(void)moviePlayeExitFullScreen:(NSNotification*)note
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


#pragma mark - 我来说两句
- (IBAction)sendMsgBtnClick:(id)sender
{
    if (self.watch_record_no_chatting)
    {
        VH_ShowToast(@"已开启回放禁言");
        return;
    }
    
    [self.messageToolView becomeFirstResponder];
}

#pragma mark - VHKeyboardToolViewDelegate
/* 发送按钮事件回调*/
- (void)keyboardToolView:(VHKeyboardToolView *)view sendText:(NSString *)text {
    if (self.watch_record_no_chatting)
    {
        VH_ShowToast(@"已开启回放禁言");
        return;
    }
    if ([text isEqualToString:@""]) {
        VH_ShowToast(@"发送的消息不能为空");
        return;
    }
    __weak typeof(self) weakSelf = self;
    [_chat sendMsg:text success:^{
        
    } failed:^(NSDictionary *failedData) {
        NSString* string = [NSString stringWithFormat:@"%@ %@", failedData[@"code"],failedData[@"content"]];
        VH_ShowToast(string);
    }];
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
    VH_ShowToast(message);
}

#pragma mark  - tableView Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if(_chatBtn.selected == YES) {
        id model = [self.chatArray objectAtIndex:indexPath.row];
        if ([model isKindOfClass:[VHallChatModel class]]) {
            static NSString * indetify = @"WatchLiveChatCell";
            cell = [tableView dequeueReusableCellWithIdentifier:indetify];
            if (!cell) {
                cell = [[WatchLiveChatTableViewCell alloc] init];
            }
            ((WatchLiveChatTableViewCell *)cell).model = model;
        }else if ([model isKindOfClass:[VHallOnlineStateModel class]]) {
            static NSString * indetify = @"WatchLiveOnlineCell";
            cell = [tableView dequeueReusableCellWithIdentifier:indetify];
            if (!cell) {
                cell = [[WatchLiveOnlineTableViewCell alloc] init];
            }
            ((WatchLiveOnlineTableViewCell *)cell).model = model;
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatArray.count;
}


#pragma mark - TableView
- (void)configTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _tableView.backgroundColor = MakeColorRGB(0xe2e8eb);
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.estimatedRowHeight = 50;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableViewContentView addSubview:_tableView];
    
    __weak typeof(self)weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadChatListData:weakSelf.pageNum + 1];
    }];
    [header setTitle:@"下拉加载更多" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即加载更多" forState:MJRefreshStatePulling];
    [header setTitle:@"暂无更多" forState:MJRefreshStateNoMoreData];
    [header setTitle:@"正在加载更多的数据中..." forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        [weakSelf loadChatListData:1];
    }];
    [footer setTitle:@"上拉刷新" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在刷新数据中..." forState:MJRefreshStateRefreshing];
    
    _tableView.mj_header = header;
    _tableView.mj_footer = footer;
}

#pragma mark - 投屏
- (IBAction)dlnaClick:(id)sender {

    if (!self.isCast_screen) {
        VH_ShowToast(@"无投屏权限，如需使用请咨询您的销售人员或拨打客服电话：400-888-9970");
        return;
    }
    if(![self.dlnaView showInView:self.view moviePlayer:_moviePlayer])
    {
        VH_ShowToast(@"投屏失败，投屏前请确保当前视频正在播放");
        return;
    }

    [_moviePlayer pausePlay];
    
    __weak typeof(self)wf = self;
    self.dlnaView.closeBlock = ^{
        [wf.moviePlayer reconnectPlay];
    };
}
#pragma mark - DLNAViewDelegate
- (void)dlnaControlState:(DLNAControlStateType)type errormsg:(NSString *)msg
{
    VH_ShowToast(msg);
}


#pragma mark - 通知处理

- (void)didBecomeActive
{
    if(announcementView && !announcementView.hidden)
    {
        announcementView.content = announcementView.content;
    }
}

#pragma mark - 懒加载
-(DLNAView *)dlnaView
{
    if (!_dlnaView) {
        _dlnaView = [[DLNAView alloc] initWithFrame:self.view.bounds];
        _dlnaView.type = 1;
        _dlnaView.delegate = self;
    }
    return _dlnaView;
}

- (VHallMoviePlayer *)moviePlayer
{
    if (!_moviePlayer)
    {
        _moviePlayer = [[VHallMoviePlayer alloc] initWithDelegate:self];
        _moviePlayer.timeout = (int)_timeOut;
        _moviePlayer.defaultDefinition = VHMovieDefinitionSD;
    }
    return _moviePlayer;
}


- (VHPlayerView *)playMaskView
{
    if (!_playMaskView) {
        _playMaskView  = [[VHPlayerView alloc]init];
        _playMaskView.delegate = self;
    }
    return _playMaskView;
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

- (UIButton *)chaptersBtn {
    if (!_chaptersBtn) {
        _chaptersBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _chaptersBtn.hidden = YES;
        _chaptersBtn.titleLabel.font = FONT_FZZZ(12);
        _chaptersBtn.backgroundColor = [UIColor blackColor];
        _chaptersBtn.layer.masksToBounds = YES;
        _chaptersBtn.layer.cornerRadius = 5;
        [_chaptersBtn setTitle:@"回放章节" forState:UIControlStateNormal];
        [_chaptersBtn addTarget:self action:@selector(clickChaptersBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.chaptersBtn];
    }
    return _chaptersBtn;
}

#pragma mark - 屏幕旋转

-(BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self updataFrame];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if(orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) { //横屏
        self.playMaskView.fullButton.selected = YES;
        NSLog(@"将要旋转为横屏");
    }else { //竖屏
        self.playMaskView.fullButton.selected = NO;
        NSLog(@"将要旋转为竖屏");
    }
}

@end
