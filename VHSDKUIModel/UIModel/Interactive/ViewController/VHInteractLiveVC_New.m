//
//  VHInteractLiveVC_New.m
//  UIModel
//
//  Created by leiheng on 2021/4/15.
//  Copyright © 2021 www.vhall.com. All rights reserved.
//

#import "VHInteractLiveVC_New.h"
#import "VHInteractContentView.h"
#import <VHInteractive/VHRoom.h>
#import "VHLiveMemberAndLimitView.h"
#import "VHLiveBroadcastInfoDetailView.h"
#import "VHLiveBroadcastInfoDetailTopView.h"
#import "VHLiveBroadcastInfoDetailBootomView.h"
#import "VHLiveStateView.h"
#import "VHLiveMemberModel.h"
#import "VHAlertView.h"
#import "OMTimer.h"
#import "MJExtension.h"
#import "VHDocListVC.h"
#import "VHLiveDocContentView.h"
#import "VHBeautyAdjustController.h"
@interface VHInteractLiveVC_New ()<VHRoomDelegate,VHallChatDelegate,VHDocumentDelegate,VHallRehearsalObjectDelegate>
{
    BOOL _noShowDownMicTip; //是否不显示下麦提示
}
/** 互动SDK */
@property (nonatomic, strong) VHRoom *inavRoom;

/** 互动View */
@property (nonatomic, strong) VHInteractContentView *interactView;

/** 本地视频view */
@property (nonatomic, strong) VHLocalRenderView *localRenderView;
/** 文档互动流*/
@property (nonatomic, strong) VHRenderView * docRenderView;

/** 主讲人视频小窗口 */
@property (nonatomic, strong) VHLocalRenderView *smallVideo;

/** 角色 用户类型:1主持人 2观众 3助理 4嘉宾 */
@property (nonatomic, assign) VHLiveRole role;
/** 标记是否为自己主动下麦 */
@property (nonatomic, assign) BOOL downMicrophoneBySelf;
/** 标记是否为自己手动关闭直播 */
@property (nonatomic, assign) BOOL closeLiveBySelf;

@property (nonatomic,strong) VHBeautifyKit *beautKit;///美颜
///美颜是否可用
@property (nonatomic,assign) BOOL  isEnableBeauty;

@property (nonatomic,strong) VHBeautyAdjustController *adjust;

/// 当前互动人数
@property (nonatomic, assign) NSInteger  current_inav_num;

/** 彩排 */
@property (nonatomic, strong) VHallRehearsalObject * rehearsalObject;

@end

@implementation VHInteractLiveVC_New

- (instancetype)initWithParams:(NSDictionary *)params isHost:(BOOL)isHost screenLandscape:(BOOL)screenLandscape {
    self = [super initWithParams:params];
    if (self) {
        self.role = isHost ? VHLiveRole_Host : VHLiveRole_Guest;
        self.screenLandscape = screenLandscape;
        if(self.role == VHLiveRole_Guest) { //嘉宾加入互动直播
            self.isSpeaker = NO;
            self.isGuest = YES;
        }else { //主持人开始互动直播
            self.isSpeaker = YES;
            self.isGuest = NO;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 判断显示彩排标识
    self.infoDetailView.rehearsalLogoView.hidden = !self.isRehearsal;
    //self.beautKit = [VHReflect initBeautyEffectKit];
    self.beautKit = [VHBeautifyKit beautifyManagerWithModuleClass:[VHBFURender class]];
    [self updateGuestMainSpeaker:NO];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self readCacheStatus];
}
- (void)readCacheStatus{
    if ([VHSaveBeautyTool readSaveCacheStatus]) {
        //有缓存去缓存状态
        [VHSaveBeautyTool closeBeauty:[VHSaveBeautyTool beautyViewModelArray][0] beautifyKit:self.beautKit closeBeautyEffect:![VHSaveBeautyTool readBeautyEnableStatus]];
    }else{
        [VHSaveBeautyTool closeBeauty:[VHSaveBeautyTool beautyViewModelArray][0] beautifyKit:self.beautKit closeBeautyEffect:NO];
    }
}
- (void)configUI {
    self.infoDetailView.topToolView.liveType = VHLiveType_Interact;
    if(self.role == VHLiveRole_Host) { //主持人
        //添加开始按钮
        [self.liveStateView upDateLiveState:VHLiveState_Prepare btnTitle:@""];
        //显示开播前本地视频预览
        [self showHostLocalVideo];
        //没上麦时，隐藏视频/语音按钮
        [self.infoDetailView.topToolView hiddenCameraOpenBtn:YES microphoneBtn:YES beautyBtn:NO cameraSwitch:NO];
    }else if(self.role == VHLiveRole_Guest){ //嘉宾
        [self.infoDetailView hiddenMessageView:NO];  //显示消息view
        [self.infoDetailView hiddenHostInfoView:NO]; //显示头像view
        self.infoDetailView.bottomToolView.hidden = NO; //显示底部工具view
        //没上麦时，隐藏视频/语音/美颜等按钮
        [self.infoDetailView.topToolView hiddenCameraOpenBtn:YES microphoneBtn:YES beautyBtn:YES cameraSwitch:YES];
    }
    //添加互动视频容器
    [self.infoDetailView insertSubview:self.interactView atIndex:0];
    [self.interactView mas_makeConstraints:^(MASConstraintMaker *make) {
        if(self.screenLandscape) {
            make.top.bottom.equalTo(self.infoDetailView);
            make.width.height.equalTo(self.infoDetailView.mas_height);
        }else {
            make.top.equalTo(self.infoDetailView.rehearsalLogoView.mas_bottom).offset(4);
            make.width.height.equalTo(self.infoDetailView.mas_width);
        }
        make.centerX.equalTo(self.infoDetailView);
    }];
    
    if(self.role == VHLiveRole_Guest) { //嘉宾没有开播按钮，直接加入，成功后加入互动房间
        [self guestJoin];
    }
}

#pragma mark -开始彩排
- (void)didToStartRehearsal
{
    // 判断显示彩排标识
    self.infoDetailView.rehearsalLogoView.hidden = NO;
}

#pragma mark -结束彩排
- (void)didToStopRehearsal
{
    // 判断显示彩排标识
    self.infoDetailView.rehearsalLogoView.hidden = YES;
}

#pragma mark - 标识彩排直播还是视频直播
- (void)setIsRehearsal:(BOOL)isRehearsal
{
    [super setIsRehearsal:isRehearsal];
    
    // 设置为彩排
    self.inavRoom.isRehearsal = isRehearsal;
}

//嘉宾加入
- (void)guestJoin {
    @weakify(self);
    [self.inavRoom guestEnterRoomWithParams:self.params success:^(VHRoomInfo *roomInfo) {
        @strongify(self);
        self.roomInfo = roomInfo;
        // 判断显示彩排标识
        self.infoDetailView.rehearsalLogoView.hidden = roomInfo.live_type == 0 ? YES : NO;;
        self.roomInfo.documentManager.delegate = self;
        //嘉宾端，没有直播计时，显示直播名称
        self.infoDetailView.topToolView.liveTitleStr = self.roomInfo.webinar_title;
        self.infoDetailView.topToolView.headIconStr = self.roomInfo.webinar_user_icon;
        [self startIMServer];
    } fail:^(NSError *error) {
        VH_ShowToast(error.localizedDescription);
    }];
}


// 初始化IM服务
- (void)startIMServer {
    self.chatService =[[VHallChat alloc] initWithObject:self.inavRoom];
    self.chatService.delegate = self;
}

//显示开播前本地视频预览
- (void)showHostLocalVideo {
    [self.infoDetailView insertSubview:self.localRenderView atIndex:0];
    [self.localRenderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.infoDetailView);
    }];
}

//互动出错
- (void)interactiveRoomError:(NSError *)error {
    if (!error) {
        return;
    }
    VUI_Log(@"互动房间出错：%@",error);
    if(error.code == 284003){ //socket.io fail（网络错误）
        VH_ShowToast(@"当前网络异常");
    }else {
        VH_ShowToast(error.domain);
    }
    [self leaveInteracRoom]; //离开房间，并停止推流
    [self popViewController];
}


- (void)popViewController {
    //防止横屏转竖屏，返回会有视频画面延迟消失现象
    self.interactView.hidden = YES;
    self.smallVideo.hidden = YES;
    //关闭弹窗，防止出现alert弹窗没有关闭的情况
    if(self.presentedViewController) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//离开房间
- (void)leaveInteracRoom {
    // 如果横屏
    if(self.screenLandscape) {
        // 强制转竖屏
        [self forceRotateUIInterfaceOrientation:UIInterfaceOrientationPortrait];
        // 标识竖屏
        self.screenLandscape = NO;
    }

    // 合并模式才融屏文档
    if (self.roomInfo.speakerAndShowLayout == 1) {
        // 取消融屏
        [self.inavRoom settingRoomBroadCastDocMixEnable:NO finish:^(int code, NSString * _Nonnull message) {}];
    }

    // 停止推流
    [self.inavRoom unpublish];
    // 退出互动房间
    [self.inavRoom leaveRoom];
    // 移除消息监听
    self.chatService = nil;
}

//更新主讲人视频小窗口显示
- (void)updateSmallVideo {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(!self.infoDetailView.openDocView) { //文档未显示时，不处理
            return;
        }
        //放在主线程，等待collectionView刷新以后，再添加小窗口视频，否则小窗口视频无法添加到文档详情页中，因为collectionView刷新不是立即刷新，如果先取到模型中的视频view添加，collectionView刷新时又添加同一个视频view，会导致又被添加回去
            self.smallVideo = [self.interactView docPermissionVideoView];
            
            if(self.smallVideo) {
                NSLog(@"添加小窗口：%@",self.smallVideo);
                [self.infoDetailView addSubview:self.smallVideo];
                self.smallVideo.backgroundColor = [UIColor whiteColor];
                [self.smallVideo mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.equalTo(@(CGSizeMake(120, 120)));
                    if(self.screenLandscape) {
                        make.right.equalTo(self.infoDetailView).offset(-15);
                        make.top.equalTo(self.infoDetailView).offset(15);
                    }else {
                        make.right.equalTo(self.infoDetailView).offset(0);
                        make.top.equalTo(self.infoDetailView).offset(VH_KStatusBarHeight);
                    }
                }];
            }
    });
}


//开播倒计时结束
- (void)startLiveCountDownOver {
    [super startLiveCountDownOver];
    //加入互动房间，成功回调中判断如果是主播，则开启推流
    @weakify(self)
    [self.inavRoom hostEnterRoomStartWithParams:self.params success:^(VHRoomInfo *roomInfo) {
        @strongify(self)
        self.roomInfo = roomInfo;
        self.roomInfo.documentManager.delegate = self;
        self.infoDetailView.topToolView.headIconStr = self.roomInfo.webinar_user_icon;
        [self startIMServer];
    } fail:^(NSError *error) {
        VH_ShowToast(error.localizedDescription);
    }];
}

//前台
- (void)appWillEnterForeground {
    [super appWillEnterForeground];
    if(!self.isGuest && self.liveStateView.liveState == VHLiveState_Success && self.inavRoom.isPublishing == NO) {//主播端 && 已开播 && 未推流
        //开始推流
        [self.inavRoom publishWithCameraView:self.localRenderView];
    }
}

//后台
- (void)appDidEnterBackground {
    //下麦并停止推流
    [self.inavRoom unpublish];
}

//强杀
- (void)appWillTerminate {
    if (!self.isGuest && self.liveStateView.liveState == VHLiveState_Success) {
        [self.inavRoom leaveRoom];
    }
}

#pragma mark - VHLiveBroadcastInfoDetailViewDelegate
///上麦/下麦
- (void)liveDetailView:(VHLiveBroadcastInfoDetailView *)detailView upMicrophoneActionBtn:(UIButton *)button {
    button.userInteractionEnabled = NO;
    if(!button.selected) {
        //如果被禁言，不让上麦
        if(self.inavRoom.roomInfo.selfBanChat) {
            VH_ShowToast(@"您已被禁言");
            button.userInteractionEnabled = YES;
            return;
        }
        //上麦请求
        [VHHelpTool getMediaAccess:^(BOOL videoAccess, BOOL audioAcess) {
            [self.inavRoom applySuccess:^{
                button.userInteractionEnabled = YES;
                VH_ShowToast(@"已发送上麦申请");
                //开启倒计时
                [detailView.bottomToolView startUpMicCountDownTime];
            } fail:^(NSError *error) {
                button.userInteractionEnabled = YES;
                VH_ShowToast(error.localizedDescription);
            }];
        }];
       
    }else {
        //标记自己下麦
        self.downMicrophoneBySelf = YES;
        button.userInteractionEnabled = YES;
        //下麦停止推流
        [self.inavRoom unpublish];
    }
}

///取消上麦
- (void)liveDetailView:(VHLiveBroadcastInfoDetailView *)detailView cancaelUpMicrophoneActionBtn:(UIButton *)button {
    button.userInteractionEnabled = NO;
    [self.inavRoom cancelApplySuccess:^{
        button.userInteractionEnabled = YES;
        //重置上麦按钮状态
        [self.infoDetailView.bottomToolView endTimeByUpMicSuccess:NO];
        VH_ShowToast(@"已取消上麦申请");
    } fail:^(NSError *error) {
        button.userInteractionEnabled = YES;
        VH_ShowToast(error.localizedDescription);
    }];
}

///退出直播
- (void)liveDetaiViewClickCloseBtn:(VHLiveBroadcastInfoDetailView *)detailView {
    
    NSString * stateTitle = self.isRehearsal ? @"确定结束当前彩排？" : @"确定结束当前直播？";
    NSString * stateCancelText = self.isRehearsal ? @"继续彩排" : @"继续直播";
    NSString * stateConfirmText = self.isRehearsal ?  @"结束彩排" : @"结束直播";
    
    NSString * title = self.role == VHLiveRole_Host ? stateTitle : @"确定退出直播？";
    NSString * cancelText = self.role == VHLiveRole_Host ? stateCancelText : @"取消";
    NSString * confirmText = self.role == VHLiveRole_Host ? stateConfirmText : @"确定";

    [VHAlertView showAlertWithTitle:title content:nil cancelText:cancelText cancelBlock:nil confirmText:confirmText confirmBlock:^{
        if (self.role == VHLiveRole_Host) {
            self.closeLiveBySelf = YES;
            if([self.inavRoom isPublishing]) { //如果当前已经在推流
                [self leaveInteracRoom]; //停止推流，退出互动房间
                [self showLiveEndView]; //显示直播结束页
            }else {
                [self leaveInteracRoom]; //停止推流，退出互动房间
                [self popViewController];
            }
        } else {
            [self leaveInteracRoom];
            [self popViewController];
        }
    }];
}

///前后设置头切换
- (void)liveDetaiViewClickCameraSwitchBtn:(VHLiveBroadcastInfoDetailView *)detailView {
    [self.localRenderView switchCamera];
}
- (VHBeautyAdjustController *)adjust{
    if (!_adjust) {
        _adjust = [[VHBeautyAdjustController alloc] init];
    }
    return _adjust;
}
///美颜开关
- (void)liveDetaiViewClickBeautyBtn:(VHLiveBroadcastInfoDetailView *)detailView openBeauty:(BOOL)open{
    if (self.beautKit) {
        if (self.isEnableBeauty) {
            [self.adjust refreshEffect:self.beautKit];
            [self presentViewController:self.adjust animated:YES completion:nil];
        }else{
            //不可用状态
            [VHAlertView showAlertWithTitle:kServerNotAvaliable content:nil cancelText:nil cancelBlock:nil confirmText:@"确定" confirmBlock:^{
            
        }];
        }
    }else{
        self.localRenderView.beautifyEnable = open;
        if(open) {
            VH_ShowToast(@"已开启美颜");
            
        }else {
            VH_ShowToast(@"已关闭美颜");
        }
    }
}

///麦克风开关
- (void)liveDetaiViewClickMicrophoneBtn:(VHLiveBroadcastInfoDetailView *)detailView voiceBtn:(UIButton *)voiceBtn {
    voiceBtn.userInteractionEnabled = NO;
    BOOL open = voiceBtn.isSelected ? YES : NO;
    if (open) {
        [self.localRenderView unmuteAudio];
        VH_ShowToast(@"已打开麦克风");
        voiceBtn.userInteractionEnabled = YES;
    } else {
        [self.localRenderView muteAudio];
        VH_ShowToast(@"已关闭麦克风");
        voiceBtn.userInteractionEnabled = YES;
    }
}

///摄像头开关
- (void)liveDetaiViewClickCameraOpenBtn:(VHLiveBroadcastInfoDetailView *)detailView videoBtn:(UIButton *)videoBtn {
    videoBtn.userInteractionEnabled = NO;
    BOOL open = videoBtn.isSelected ? YES : NO;
    if (open) {
        [self.localRenderView unmuteVideo];
        VH_ShowToast(@"已打开摄像头");
        videoBtn.userInteractionEnabled = YES;
    } else {
        [self.localRenderView muteVideo];
        VH_ShowToast(@"已关闭摄像头");
        videoBtn.userInteractionEnabled = YES;
    }
}

///打开成员列表
- (void)liveDetailViewOpenMemberListView:(VHLiveBroadcastInfoDetailView *)detailView {
    BOOL isGuest = self.role == VHLiveRole_Guest; //是否为嘉宾
    BOOL members_manage = self.roomInfo.membersManageAuthority; //是否有成员管理权限
    VHLiveMemberAndLimitView *listView = [[VHLiveMemberAndLimitView alloc] initWithRoom:self.inavRoom liveType:VHLiveType_Interact isCuest:isGuest haveMembersManage:members_manage];
    [listView showInView:self.view];
    self.userListView = listView;
}

//打开文档列表
- (void)liveDetailViewDocumentListBtnClick:(VHLiveBroadcastInfoDetailView *)detailView {
    VHDocListVC *docListVC = [[VHDocListVC alloc] init];
    docListVC.room = self.inavRoom;
    docListVC.docSelectBlcok = ^(NSString * _Nonnull docId) {
        //演示新文档时，确保先关闭之前打开的画笔弹窗
        [self.infoDetailView.bottomToolView cancelSelectBrush];
        [self liveDetaiViewShowDocId:docId];
    };
    [self.navigationController pushViewController:docListVC animated:YES];
}

///打开文档展示容器
- (void)liveDetailViewOpenDocumentView:(VHLiveBroadcastInfoDetailView *)detailView {
    //显示文档演示下的UI
    [self.infoDetailView showDocUI:YES];
    //将文档容器添加到互动视频容器上方
    NSInteger index = [self.infoDetailView.subviews indexOfObject:self.interactView] + 1;
    [self.infoDetailView insertSubview:self.docContentView atIndex:index];
    [UIView animateWithDuration:0.3 animations:^{
        self.docContentView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        //更新小窗口视频
        [self updateSmallVideo];
    }];
}

///关闭文档容器
- (void)docContentViewDisMissComplete:(VHLiveDocContentView *)docContentView {
    [super docContentViewDisMissComplete:docContentView];
    [self.smallVideo removeFromSuperview];
    //视频小窗view移除后，需重新刷新互动视频显示
    [self.interactView reloadAllData];
}

#pragma mark - 是否显示文档
- (void)isShowDoc:(BOOL)isShowDoc isHaveDoc:(BOOL)isHaveDoc
{
    [super isShowDoc:isShowDoc isHaveDoc:isHaveDoc];
    
    // 合并模式才融屏文档
//    NSString * hint = [NSString stringWithFormat:@"当前是%@模式,文档%@,文档%@",self.roomInfo.speakerAndShowLayout == 1 ? @"合并" : @"分离",isShowDoc ? @"显示" : @"不显示",isHaveDoc ? @"有" : @"没有"];
//    VH_ShowToast(hint);
//    VHLog(hint);
    if (self.roomInfo.speakerAndShowLayout == 1) {
        //配置融屏
        [self.inavRoom settingRoomBroadCastDocMixEnable: isShowDoc && isHaveDoc  finish:^(int code, NSString * _Nonnull message) {

        }];
    }
    
    // 设置主画面
    [self maxScreenVideoView:self.docRenderView isAdd:NO];
}

#pragma mark - 显示/隐藏文档无关内容
- (void)liveDetailView:(VHLiveBroadcastInfoDetailView *)detailView hiddenDocUnRelationView:(BOOL)hidden {
    [super liveDetailView:detailView hiddenDocUnRelationView:hidden];
    self.smallVideo.hidden = hidden;
}

#pragma mark - VHRoomDelegate
- (void)room:(VHRoom *)room enterRoomWithError:(NSError *)error {
    NSLog(@"加入房间回调");
    [self interactiveRoomError:error];
}

// 房间连接成功回调
- (void)room:(VHRoom *)room didConnect:(NSDictionary *)roomMetadata {
    
    // 注册彩排代理
    self.rehearsalObject.delegate = self;
    
    if (self.role == VHLiveRole_Host) {
        //开始推流
        [self.inavRoom publishWithCameraView:self.localRenderView];
        //设置允许观众举手上麦
        [self.inavRoom setHandsUpStatus:1 success:nil fail:nil];
    }
    //判断当前是否为主讲人，如果不是主讲人，底部操作按钮需要变更
    if(![self.roomInfo.mainSpeakerId isEqualToString:self.roomInfo.selfUserId]) {
        [self setDocEditEnable:NO];
    }
}

//推流成功
- (void)room:(VHRoom *)room didPublish:(VHRenderView *)cameraView {
    // 标识彩排还是视频直播
    [self.liveStateView upDateLiveState:self.isRehearsal ? VHLiveState_RehearsalSuccess  : VHLiveState_Success btnTitle:@""];
    // 更新互动人数
    self.current_inav_num = self.current_inav_num + 1;
    //移除本地预览视频
    [self.localRenderView removeFromSuperview];
    //显示视频、语音、美颜等按钮
    [self.infoDetailView.topToolView hiddenCameraOpenBtn:NO microphoneBtn:NO beautyBtn:NO cameraSwitch:NO];
    //添加自己的视频view
    VHLiveMemberModel *model = [VHLiveMemberModel modelWithVHRenderView:(VHLocalRenderView *)cameraView];
    if(model.videoView.isLocal) { //如果是本地视频，设置当前视频/音频开启情况
        model.closeCamera = self.infoDetailView.topToolView.videoBtn.selected;
        model.closeMicrophone = self.infoDetailView.topToolView.voiceBtn.selected;
    }
    model.haveDocPermission = [self.inavRoom.roomInfo.mainSpeakerId isEqualToString:model.account_id];
    [self.interactView addAttendWithUser:model];
    //更新视频小窗口显示
    [self updateSmallVideo];
    // 设置主画面
    [self maxScreenVideoView:cameraView isAdd:YES];
}

// 停止推流成功
- (void)room:(VHRoom *)room didUnpublish:(VHRenderView *)cameraView {
    VUI_Log(@"停止推流成功");
    // 更新互动人数
    if (self.current_inav_num > 0) {
        self.current_inav_num = self.current_inav_num - 1;
    }

}
//错误回调
- (void)room:(VHRoom *)room didError:(VHRoomErrorStatus)status reason:(NSString *)reason {
    VUI_Log(@"房间错误：%@---status：%zd",reason,status);
    if(status == 284003) { //socket.io fail 错误
        VH_ShowToast(@"网络错误");
        //退出
        [self leaveInteracRoom];
        [self popViewController];
    }else { //其他错误，如：上麦人数达到上限（status：513025）
        VH_ShowToast(reason);
    }
}

//房间状态变化
- (void)room:(VHRoom *)room didChangeStatus:(VHRoomStatus)status {
    VUI_Log(@"房间状态变化：%zd",status);
}

// 视频流添加回调（收到此回调后需要添加视频view，可能是连麦用户，也可能是共享屏幕/插播）
- (void)room:(VHRoom *)room didAddAttendView:(VHRenderView *)attendView {
    if (attendView.streamType == VHInteractiveStreamTypeVideoPatrol) {
        return;//过滤视频轮巡流
    }
    
    // 添加视频流
    [self addToRenderView:attendView];
}

// 视频流移除回调（收到此回调后需要移除视频view，可能是连麦用户，也可能是共享屏幕/插播）
- (void)room:(VHRoom *)room didRemovedAttendView:(VHRenderView *)attendView {
    
    if (attendView.streamType == VHInteractiveStreamTypeVideoPatrol) {
        return;//过滤视频轮巡流
    }
    
    // 移除视频流
    [self rmToRenderView:attendView];
}

// 文档融屏流上线(订阅)
- (void)room:(VHRoom *)room didAddDocmentAttendView:(VHRenderView *)attendView
{
    // 添加文档流
    self.docRenderView = attendView;

    // 设置主画面
    [self maxScreenVideoView:attendView isAdd:NO];
}

// 文档融屏流下线(订阅)
- (void)room:(VHRoom *)room didRemovedDocmentAttendView:(VHRenderView *)attendView
{
    // 移除文档流
    self.docRenderView = nil;
    
    // 设置主画面
    [self maxScreenVideoView:attendView isAdd:NO];
}

// 添加视频流
- (void)addToRenderView:(VHRenderView *)attendView
{
    VUI_Log(@"\n某人上麦:%@，流类型：%d，流视频宽高：%@，流id：%@，是否有音频：%d，是否有视频：%d",attendView.userId,attendView.streamType,NSStringFromCGSize(attendView.videoSize),attendView.streamId,attendView.hasAudio,attendView.hasVideo);
    
    // 更新互动人数
    self.current_inav_num = self.current_inav_num + 1;

    // 添加此人画面
    VHLiveMemberModel *model = [VHLiveMemberModel modelWithVHRenderView:(VHLocalRenderView *)attendView];
    model.haveDocPermission = [self.inavRoom.roomInfo.mainSpeakerId isEqualToString:model.account_id];
    [self.interactView addAttendWithUser:model];
    
    //更新视频小窗口显示
    [self updateSmallVideo];
    
    //如果收到插播，则关闭自己麦克风，解决插播时文件与人声混音问题。
    NSDictionary *streamAttributes = attendView.streamAttributes.mj_JSONObject;
    NSInteger stream_type = [streamAttributes[@"stream_type"] integerValue];

    //如果自己上麦中收到插播流，则关闭自己麦克风，解决插播时文件与人声混音问题。
    if(attendView.streamType == VHInteractiveStreamTypeFile || stream_type == 4) {
        //自己已上麦 && 麦克风处于开启状态下
        if([_localRenderView isPublish] && !self.infoDetailView.topToolView.voiceBtn.selected) {
            // 如果是为打开状态需要处理为打开
            [self liveDetaiViewClickMicrophoneBtn:self.infoDetailView voiceBtn:self.infoDetailView.topToolView.voiceBtn];
        }
    }
    
    // 设置主画面
    [self maxScreenVideoView:attendView isAdd:YES];

}

// 移除视频流
- (void)rmToRenderView:(VHRenderView *)attendView
{
    VUI_Log(@"某人下麦:%@",attendView.userId);
    
    // 更新互动人数
    if (self.current_inav_num > 0) {
        self.current_inav_num = self.current_inav_num - 1;
    }

    //移除此人视频画面
    [self.interactView removeAttendView:(VHLocalRenderView *)attendView];

    //更新视频小窗口显示
    [self updateSmallVideo];
    
    //如果收到插播，则关闭自己麦克风，解决插播时文件与人声混音问题。
    NSDictionary *streamAttributes = attendView.streamAttributes.mj_JSONObject;
    NSInteger stream_type = [streamAttributes[@"stream_type"] integerValue];
    
    if (attendView.streamType == VHInteractiveStreamTypeScreen || attendView.streamType == VHInteractiveStreamTypeFile || stream_type == 4) {
        
        //自己已上麦 && 麦克风处于开启状态下
        if([self.interactView haveRenderViewWithTargerId:self.roomInfo.webinarInfoData.join_info.third_party_user_id] ) {
            // 如果是为打开状态需要处理为打开
            if (self.infoDetailView.topToolView.voiceBtn.selected) {
                [self liveDetaiViewClickMicrophoneBtn:self.infoDetailView voiceBtn:self.infoDetailView.topToolView.voiceBtn];
            }
        }
    }
    // 设置旁路直播
    [self openBypassLiveWithStreamType:[self.interactView docPermissionVideoView].streamType];

    // 设置主画面
    [self maxScreenVideoView:attendView isAdd:NO];
}
#pragma mark - 服务器已准备好混流可以调用混流接口
- (void)room:(VHRoom *)room onStreamMixed:(NSDictionary *)msg
{
    // 设置旁路直播
    [self openBypassLiveWithStreamType:(VHInteractiveStreamType)[msg[@"streamType"] integerValue]];
}

#pragma mark - 设置旁路直播
- (void)openBypassLiveWithStreamType:(VHInteractiveStreamType)type {

    if (self.role == VHLiveRole_Host) {
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"precast_pic_exist"] = @(NO); //是展示小人占位图
        param[@"backgroundColor"] = [self.roomInfo.videoBackGroundColor stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];

        NSMutableDictionary * borderDic = [NSMutableDictionary dictionary];
        borderDic[@"exist"] = @(YES);
        borderDic[@"width"] = @(1);
        borderDic[@"color"] = [self.roomInfo.videoBackGroundColor stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
        param[@"border"] = borderDic; //配置背景颜色

        [self.inavRoom publishAnotherLive:YES param:[param copy] completeBlock:^(NSError *error) {
            if(!error) { //设置旁路直播状态成功
                VUI_Log(@"设置旁路成功");
            }else if(error.code == 40008) {//旁路推流正在进行中
                VUI_Log(@"设置旁路错误：当前推流正在进行中");
            }else {
                VUI_Log(@"设置旁路错误：%@",error.domain);
            }
        }];

        // 设置背景图片
        [self.inavRoom settingRoomBroadCastBackgroundImageURL:[NSURL URLWithString:self.roomInfo.finalVideoBackground] cropType:1 finish:^(int code, NSString * _Nonnull message) {

        }];
    }
}

#pragma mark - 设置主画面
/// 设置主画面
/// - Parameters:
///   - videoView: 回调的renderView
///   - isRem: 是否为移除流
- (void)maxScreenVideoView:(VHRenderView *)renderView isAdd:(BOOL)isAdd
{
    if(self.role == VHLiveRole_Host || [self.roomInfo.mainSpeakerId isEqualToString:_localRenderView.userId]) {
        
//        获取当前正在进行中的屏幕共享或插播
//        VHRenderView * view = [self haveStreamTypeScreenOrStreamTypeScreenFile];

        // 大画面
        VHRenderView * mixRenderView;

        // 获取是否有视频
        NSDictionary *streamAttributes = renderView.streamAttributes.mj_JSONObject;
        BOOL has_video = [streamAttributes[@"has_video"] boolValue];

        if((renderView.streamType == VHInteractiveStreamTypeScreen || (renderView.streamType == VHInteractiveStreamTypeFile && has_video)) && isAdd) {
            //流是否为(插播且有视频)或者桌面共享 && 是添加流操作
            mixRenderView = renderView;
        }else if (self.docRenderView && self.docContentView.docShow && [self.docContentView haveShowDocView]) {
            //文档流
            mixRenderView = self.docRenderView;
        }else {
            //主讲人视频
            mixRenderView = [self.interactView docPermissionVideoView];
        }

        //设置旁路大画面
        [mixRenderView setMixLayoutMainScreen:nil finish:nil];
    }
}
#pragma mark - 当前是否有进行中的 屏幕共享 或 插播
- (VHRenderView *)haveStreamTypeScreenOrStreamTypeScreenFile {
    __block VHRenderView *view = nil;
    [self.inavRoom.renderViewsById enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, VHRenderView * _Nonnull renderView, BOOL * _Nonnull stop) {
        if(renderView.streamType == VHInteractiveStreamTypeScreen || renderView.streamType == VHInteractiveStreamTypeFile|| renderView.streamType == VHInteractiveStreamTypeVideoPatrol) {
            *stop = YES;
            view = renderView;
        }
    }];
    return view;
}

#pragma mark - 互动消息
- (void)room:(VHRoom *)room receiveRoomMessage:(VHRoomMessage *)message {
    VUI_Log(@"messageType====%ld",(long)message.messageType);

    BOOL targetIsMyself = message.targetForMe;
    NSString *targetId = message.targetId;
    NSString *targetName = message.targetName;

    //加入用户id
   NSString *joinUser = room.roomInfo.webinarInfoData.join_info.third_party_user_id;
    //主持人id
    NSString *host_id = [NSString stringWithFormat:@"%@",room.roomInfo.webinarInfoData.webinar.userinfo.user_id];
    switch (message.messageType) {
        case VHRoomMessageType_vrtc_connect_apply:{//用户申请上麦
            if (self.role == VHLiveRole_Host || (self.role == VHLiveRole_Guest && [self.inavRoom.roomInfo.mainSpeakerId isEqualToString:joinUser] && [self.inavRoom.roomInfo.permission containsObject:@(100037)])) {
                NSString *name = targetName.length > VH_MaxNickNameCount ? [NSString stringWithFormat:@"%@...",[targetName substringToIndex:VH_MaxNickNameCount]] : targetName;
                NSString *title = [NSString stringWithFormat:@"%@\n申请上麦，是否同意？",name];
                [VHAlertView showAlertWithTitle:title content:nil cancelText:@"拒绝" cancelBlock:^{
                    [self.inavRoom rejectApplyWithTargetUserId:targetId success:^{
                        
                    } fail:^(NSError *error) {
                        VH_ShowToast(error.localizedDescription);
                    }];
                } confirmText:@"同意" confirmBlock:^{
                    [self.inavRoom agreeApplyWithTargetUserId:targetId success:^{
                        
                    } fail:^(NSError *error) {
                        VH_ShowToast(error.localizedDescription);
                    }];
                }];
            }
        }break;
        case VHRoomMessageType_vrtc_connect_invite:{//用户被邀请上麦
            if (targetIsMyself) {
                
                [VHAlertView showAlertWithTitle:[NSString stringWithFormat:@"%@邀请您上麦，是否同意？",VH_MB_HOST] content:nil cancelText:@"拒绝" cancelBlock:^{
                    [self.inavRoom rejectInviteSuccess:^{
                        
                    } fail:^(NSError *error) {
                        VH_ShowToast(error.localizedDescription);
                    }];
                } confirmText:@"同意" confirmBlock:^{
                    ///权限校验
                    __weak __typeof(self)weakSelf = self;
                    [VHHelpTool getMediaAccess:^(BOOL videoAccess, BOOL audioAcess) {
                        [self.inavRoom agreeInviteSuccess:^{
                            [weakSelf.inavRoom publishWithCameraView:weakSelf.localRenderView];
                        } fail:^(NSError *error) {
                            VH_ShowToast(error.localizedDescription);
                        }];
                    }];
                }];
            }
        }break;
        case VHRoomMessageType_vrtc_connect_agree:{//用户上麦申请被同意
            if(targetIsMyself) {
                VUI_Log(@"上麦请求被同意，开启推流");
                [self.inavRoom publishWithCameraView:self.localRenderView];
            }
        }break;
        case VHRoomMessageType_vrtc_connect_refused:{//用户上麦申请被拒绝
            if(targetIsMyself) {
                VH_ShowToast(@"主持人拒绝了您的上麦申请");
                [self.infoDetailView.bottomToolView endTimeByUpMicSuccess:NO];
            }
        }break;
        case VHRoomMessageType_room_vrtc_connect_invite_agree:{
            //更新同意邀请的id
            NSLog(@"invite_id===%@",message.inviter_Id);
        }break;
        case VHRoomMessageType_vrtc_mute:{//静音消息
            if(targetIsMyself) {
                self.infoDetailView.topToolView.voiceBtn.selected = YES;
            }
            [self.interactView targerId:targetId closeMicrophone:YES];
            [self updateSmallVideo];
        }break;
        case VHRoomMessageType_vrtc_mute_cancel:{//取消静音消息
            if(targetIsMyself) {
                self.infoDetailView.topToolView.voiceBtn.selected = NO;
            }
            [self.interactView targerId:targetId closeMicrophone:NO];
            [self updateSmallVideo];
        }break;
        case VHRoomMessageType_vrtc_frames_forbid:{//关闭摄像头消息
            if(targetIsMyself) {
                self.infoDetailView.topToolView.videoBtn.selected = YES;
            }
            [self.interactView targerId:targetId closeCamera:YES];
            [self updateSmallVideo];
        }break;
        case VHRoomMessageType_vrtc_frames_display:{//开启摄像头消息
            if(targetIsMyself) {
                self.infoDetailView.topToolView.videoBtn.selected = NO;
            }
            [self.interactView targerId:targetId closeCamera:NO];
            [self updateSmallVideo];
        }break;
        case VHRoomMessageType_vrtc_big_screen_set:{//用户互动流画面被设置为旁路大画面
            // 设置主画面
            [self maxScreenVideoView:[self.interactView docPermissionVideoView] isAdd:NO];
        }break;
        case VHRoomMessageType_vrtc_speaker_switch:{//设置主讲人
            
            self.roomInfo.mainSpeakerId = targetId;
            
            if(targetIsMyself) { //自己被设为主讲人
                VH_ShowToast(@"您已被设为主讲人");
                if([self.inavRoom.roomInfo.permission containsObject:@(100037)]) {
                    [self updateGuestMainSpeaker:self.isGuest];
                }
                [self setDocEditEnable:YES];

            }else { //其他人被设为主讲人
                
                [self setDocEditEnable:NO];
                [self updateGuestMainSpeaker:NO];
                if(self.role != VHLiveRole_Host) { //自己不是主持人，其他人被设置为主讲人时给提示
                    NSString *name = targetName.length > VH_MaxNickNameCount ? [NSString stringWithFormat:@"%@...",[targetName substringToIndex:VH_MaxNickNameCount]] : targetName;
                    NSString *title = [NSString stringWithFormat:@"%@已被设为主讲人",name];
                    VH_ShowToast(title);
                }
            }
            NSMutableArray *micUserList = [self.interactView getMicUserList];
            [micUserList enumerateObjectsUsingBlock:^(VHLiveMemberModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                model.haveDocPermission = [targetId isEqualToString:model.account_id];
            }];
            //更新成员列表与受限列表
            [self updateUserList];
            //更新视频view 主讲人标识
            [self.interactView reloadAllData];
            //更新小窗口视频
            [self updateSmallVideo];
        }break;
        case VHRoomMessageType_live_start:{//开始直播
            if(self.isGuest && self.interactView.dadaSource.count == 0) {
                VH_ShowToast(@"直播开始");
            }
        }break;
        case VHRoomMessageType_live_over:{//结束直播
            if(self.isGuest) {
                VH_ShowToast(@"直播已结束");
                [self leaveInteracRoom];
                [self popViewController];
            }else {
                //非主持人自己手动关闭，则为封禁消息
                if(!self.closeLiveBySelf) {
                    [VHAlertView showAlertWithTitle:@"直播间已被管理员封禁" content:nil cancelText:nil cancelBlock:nil confirmText:@"退出直播间" confirmBlock:^{
                        [self leaveInteracRoom]; //离开房间，并停止推流
                        [self popViewController]; //返回根控制器
                    }];
                }
            }
        }break;
        case VHRoomMessageType_live_start_rehearsal:{
            // 判断显示彩排标识
            self.infoDetailView.rehearsalLogoView.hidden = NO;
        }break;
        case VHRoomMessageType_live_over_rehearsal:{
            // 判断显示彩排标识
            self.infoDetailView.rehearsalLogoView.hidden = YES;
        }break;
        case VHRoomMessageType_vrtc_disconnect_success:{//用户下麦成功
            if(targetIsMyself) { //自己
                if(_noShowDownMicTip == NO) {
                    if(!self.downMicrophoneBySelf && self.isGuest) {
                        VH_ShowToast(@"您已被主持人下麦");
                    }else {
                        VH_ShowToast(@"您已下麦");
                    }
                }
                self.downMicrophoneBySelf = NO;
                // 停止推流
                [self.inavRoom unpublish];
                //重置上麦按钮状态
                [self.infoDetailView.bottomToolView endTimeByUpMicSuccess:NO];
                //移除自己的视频view
                [self.interactView removeAttendView:self.localRenderView];
                //隐藏视频、语音、美颜等按钮
                [self.infoDetailView.topToolView hiddenCameraOpenBtn:YES microphoneBtn:YES beautyBtn:YES cameraSwitch:YES];
                //更新小窗口视频
                [self updateSmallVideo];
            }else {
                NSString *name = targetName.length > VH_MaxNickNameCount ? [NSString stringWithFormat:@"%@...",[targetName substringToIndex:VH_MaxNickNameCount]] : targetName;
                NSString *tipText = [NSString stringWithFormat:@"%@已下麦",name];
                VH_ShowToast(tipText);
                
                if(self.role == VHLiveRole_Host) { //自己是主持人
                    //如果离开的此流是用户且是主讲人，则收回主讲人，重新设置主讲人为自己
                    if([self.inavRoom.roomInfo.mainSpeakerId isEqualToString:targetId]) {
                        [self.inavRoom setMainSpeakerWithTargetUserId:room.roomInfo.selfUserId success:nil fail:nil];
                    }
                }
            }
            //更新成员列表与受限列表
            [self updateUserList];
        }break;
        case VHRoomMessageType_vrtc_connect_success:{//用户上麦成功
            VUI_Log(@"---上麦成功");
            if(targetIsMyself) {
                //重置上麦按钮状态
                [self.infoDetailView.bottomToolView endTimeByUpMicSuccess:YES];
            }else {
                NSString *name = targetName.length > VH_MaxNickNameCount ? [NSString stringWithFormat:@"%@...",[targetName substringToIndex:VH_MaxNickNameCount]] : targetName;
                NSString *tipText = [NSString stringWithFormat:@"%@已上麦",name];
                VH_ShowToast(tipText);
            }
            //更新成员列表与受限列表
            [self updateUserList];
        }break;
        case VHRoomMessageType_room_kickout:{
            if (targetIsMyself) {
                VH_ShowToast(@"您已被踢出");
                //强制退出直播间
                [self leaveInteracRoom];
                [self popViewController];
            } else {
                //更新成员列表与受限列表
                [self updateUserList];
            }
        }break;
        case VHRoomMessageType_room_kickout_cancel:{
            [self updateUserList];
        }break;
        case VHRoomMessageType_room_banChat:{
            if (targetIsMyself) {
                VH_ShowToast(@"您已被禁言");
                // 停止推流
                [self.inavRoom unpublish];
            }
            [self updateUserList];
        }break;
        case VHRoomMessageType_room_banChat_cancel:{
            if (targetIsMyself) {
                VH_ShowToast(@"您已被取消禁言");
            }
            [self updateUserList];
        }break;
        case VHRoomMessageType_room_allBanChat:{
            if (self.isGuest) {
                VH_ShowToast(@"全员已被禁言");
                // 停止推流
                [self.inavRoom unpublish];
            }
            [self updateUserList];
        }break;
        case VHRoomMessageType_room_allBanChat_cancel:{
            if (self.isGuest) {
                VH_ShowToast(@"全员已被取消禁言");
            }
            [self updateUserList];
        }break;
        case VHRoomMessageType_vrtc_connect_invite_refused:{
                   
                    if (self.isGuest && [joinUser isEqualToString:message.inviter_Id]) {
                        //嘉宾发出的邀请
                        NSLog(@"拒绝嘉宾邀请的要上麦");
                        NSString *title = [NSString stringWithFormat:@"%@拒绝了上麦申请",targetName];
                        VH_ShowToast(title);
                    }else if (self.isSpeaker && [host_id isEqualToString:message.inviter_Id]){
                        NSLog(@"拒绝主持人邀请的要上麦");
                        NSString *title = [NSString stringWithFormat:@"%@拒绝了上麦申请",targetName];
                        VH_ShowToast(title);
                    }
//            if (!self.isGuest) {
//                NSString *title = [NSString stringWithFormat:@"%@拒绝了上麦申请",targetName];
//                VH_ShowToast(title);
//            }
        }break;
        default:
            break;
    }

}

///设置文档演示是否开启
- (void)setDocEditEnable:(BOOL)enable {
    //更新文档容器view空文档时的占位提示文字
    self.docContentView.emptyLab.text = enable ? @"还没有文档哦，点击右下角添加~" : @"还没有文档哦";
//    //开启文档编辑,主持人永远保留文档操作权限
//    self.roomInfo.documentManager.editEnable = self.role == VHLiveRole_Host ? YES : enable;
    //开启文档编辑
    self.roomInfo.documentManager.editEnable = enable;
    //显示主讲人操作按钮
    self.infoDetailView.bottomToolView.isSpeaker = enable;
    //如果当前正在画笔操作，结束画笔（防止嘉宾在进行画笔操作时，主讲人权限被主持人收回，当前画笔弹窗还在问题）
    if([self.infoDetailView brushPopViewIsShow]) {
        [self.infoDetailView.bottomToolView cancelSelectBrush];
    }
}

#pragma mark - lazy load
- (VHInteractContentView *)interactView
{
    if (!_interactView) {
        _interactView = [[VHInteractContentView alloc] initWithLandscapeShow:self.screenLandscape];
    }
    return _interactView;
}

- (VHRoom *)inavRoom {
    if (!_inavRoom) {
        _inavRoom = [[VHRoom alloc] init];
//        _inavRoom.isPublishAnother = YES;
//        _inavRoom.isMainScreen = YES;
        _inavRoom.delegate = self;
    }
    return _inavRoom;
}
- (VHallRehearsalObject *)rehearsalObject
{
    if (!_rehearsalObject) {
        _rehearsalObject = [[VHallRehearsalObject alloc] initWithObject:self.inavRoom];
    }return _rehearsalObject;
}
- (VHLocalRenderView *)localRenderView
{
    if (!_localRenderView) {

        VHFrameResolutionValue resolution = VHFrameResolution480x360;
        
        if (self.role == VHLiveRole_Host || [self.roomInfo.mainSpeakerId isEqualToString:_localRenderView.userId]) {
            resolution = VHFrameResolution640x480;
        }else{
            if (self.current_inav_num > 0 && self.current_inav_num <= 5) {
                resolution = VHFrameResolution480x360;
                self.infoDetailView.resolutionLab.text = @"推流分辨率：480x360";
            } else if (self.current_inav_num > 5 && self.current_inav_num < 10) {
                resolution = VHFrameResolution320x240;
            }else{
                resolution = VHFrameResolution240x160;
            }
        }
        
        NSString *simulcastLayers = self.role == VHLiveRole_Host ? @"2" : @"1";//同时推流数 (主持人可同时推大小两路流)
        NSDictionary *options = @{VHFrameResolutionTypeKey:@(resolution),VHStreamOptionStreamType:@(VHInteractiveStreamTypeAudioAndVideo),VHSimulcastLayersKey:simulcastLayers};
        _localRenderView = [[VHLocalRenderView alloc] initCameraViewWithFrame:CGRectZero options:options];
        _localRenderView.scalingMode = VHRenderViewScalingModeAspectFill;
        _localRenderView.beautifyEnable = YES;
        if (self.beautKit) {
            [[self.beautKit currentModule] setCaptureImageOrientation:(self.screenLandscape == UIDeviceOrientationLandscapeLeft)?2:3];
            [_localRenderView useBeautifyModule:[self.beautKit currentModule] HandleError:^(NSError * _Nonnull error) {
            NSLog(@"error === %@",error.localizedDescription);
            self.isEnableBeauty = (error!=nil)?NO:YES;//是否可以使用美颜
            }];
        }
        
        [_localRenderView setDeviceOrientation:self.screenLandscape ? UIDeviceOrientationLandscapeLeft : UIDeviceOrientationPortrait];
        
//        // 实时回调推流信息
//        [_localRenderView getSsrcStats:^(NSString * _Nonnull mediaType, long kbps, NSDictionary<NSString *,NSString *> * _Nonnull values) {
//            self.infoDetailView.resolutionLab.text = [NSString stringWithFormat:@"推流分辨率：%@",values];
//        }];
//        [_localRenderView startStatsWithCallback:^(NSString * _Nonnull mediaType, long kbps, NSDictionary<NSString *,NSString *> * _Nonnull values) {
//            self.infoDetailView.resolutionLab.text = [NSString stringWithFormat:@"推流分辨率：%@",values];
//        }];
    }
    return _localRenderView;
}
- (void)reciveCustomMsg:(NSArray <VHallCustomMsgModel *> *)msgs{
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
        [self updateUserList];
        [self.interactView reloadAllData];
        return;
    }
    
}
- (void)updateGuestMainSpeaker:(BOOL)isGuestMainSpeaker{
    [[NSUserDefaults standardUserDefaults] setBool:isGuestMainSpeaker forKey:kGuestMainSpeaker];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//- (void)beautyKitModule:(VHBeautifyKit *)module{
//    self.beautKit = module;
//}
- (void)dealloc{
    [self.adjust saveBeautyConfigModel];
    //[VHReflect destoryBeautyEffectKit];
    [VHBeautifyKit destroy];
    NSLog(@"%@_释放了",[self class]);
}
@end
