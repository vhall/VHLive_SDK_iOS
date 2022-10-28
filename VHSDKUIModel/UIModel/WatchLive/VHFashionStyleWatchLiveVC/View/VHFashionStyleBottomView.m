//
//  VHFashionStyleBottomView.m
//  UIModel
//
//  Created by 郭超 on 2022/7/21.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHFashionStyleBottomView.h"
#import "VHLiveSaleAnimationTool.h"
#import "VHLiveWeakTimer.h"
#import "VHInvitationAlert.h"
#import "VHKeyboardToolView.h"

#import "UIButton+VHBadge.h"

@interface VHFashionStyleBottomView ()<MicCountDownViewDelegate,VHInvitationAlertDelegate,VHKeyboardToolViewDelegate,VHallLikeObjectDelegate>

#pragma mark - 上麦控件
/// 上麦邀请弹窗
@property (nonatomic, strong) VHInvitationAlert *   invitationAlertView;

#pragma mark - 礼物控件
/// 礼物按钮
@property (nonatomic, strong) UIButton *        giftBtn;

#pragma mark - 点赞控件
/// 点赞类
@property (nonatomic, strong) VHallLikeObject * likeObject;
/// 点赞按钮
@property (nonatomic, strong) UIButton *        likeBtn;
/// 点赞计时器
@property (nonatomic, strong) dispatch_source_t likeTimer;
/// 点赞图片数量
@property (nonatomic, assign) NSInteger         likeImgNumbers;
/// 点赞图片数组
@property (nonatomic, strong) NSMutableArray *  likeImageArray;
/// 点赞次数
@property (nonatomic, assign) NSInteger         likeTapCount;
/// 计时器
@property (nonatomic, strong) NSTimer *         timer;
/// 当前赞总数
@property (nonatomic, assign) NSInteger         num;

#pragma mark - 聊天
/// 聊天按钮
@property (nonatomic, strong) UIButton * chatBtn;
/// 聊天工具栏
@property (nonatomic, strong) VHKeyboardToolView * messageToolView;
@end

@implementation VHFashionStyleBottomView


- (instancetype)init
{
    if ([super init]) {
        
        // 设置点赞代理
        self.likeObject.delegate = self;
        // 添加控件
        [self addViews];
        
    }return self;
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
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    [self.giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_likeBtn.mas_left).offset(-8);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    [self.upMicBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_giftBtn.mas_left).offset(-8);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];

    [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImg.mas_right).offset(8);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(120, 29.5));
    }];
}

#pragma mark - 获取房间详情
- (void)getWebinarBaseInfo
{
    [VHWebinarBaseInfo permissionsCheckWithWebinarId:self.moviePlayer.webinarInfo.webinarId webinar_user_id:self.moviePlayer.webinarInfo.author_userId scene_id:@"1" success:^(NSDictionary * _Nonnull data) {
        NSString * permissions = data[@"permissions"];
        NSDictionary * permissionsDic = [UIModelTools objectWithJsonString:permissions];
        // 点赞
        self.likeBtn.hidden = ![permissionsDic[@"ui.watch_hide_like"] boolValue];
        // 礼物
        self.giftBtn.hidden = ![permissionsDic[@"ui.hide_gifts"] boolValue];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - ---------------------上麦业务---------------------------
#pragma mark - 点击申请/取消上麦操作
- (void)micUpClick:(UIButton *)button
{
    if(_chat.isAllSpeakBlocked) {
        VH_ShowToast(@"已开启全体禁言");
        return;
    }
    if(_chat.isSpeakBlocked) {
        VH_ShowToast(@"您已被禁言");
        return;
    }

    if (self.upMicBtnView.isPublish) {
        // 正在推流
        if (self.clickUnpublish) {
            self.clickUnpublish();
        }
    }else{
        // 未推流
        button.selected = !button.selected;
        if (button.selected) {
            //申请上麦
            @weakify(self);
            [VHHelpTool getMediaAccess:^(BOOL videoAccess, BOOL audioAcess) {
                @strongify(self);
                [self microApplyWithType:1 button:button];
            }];
        } else {
            //取消上麦申请
            [self microApplyWithType:0 button:button];
        }
    }

}
#pragma mark - 申请上麦按钮倒计时结束回调
- (void)countDownViewDidEndCountDown:(MicCountDownView *)view
{
    //取消上麦申请
    [self microApplyWithType:0 button:_upMicBtnView.button];
}
#pragma mark - 主持人邀请上麦弹窗操作
- (void)alert:(VHInvitationAlert *)alert clickAtIndex:(NSInteger)index
{
    // index 1 同意邀请 2 拒绝邀请
    if(index == 1){
        // 先校验权限再上麦进入互动
        @weakify(self);
        [VHHelpTool getToMediaAccess:^(BOOL videoAccess, BOOL audioAcess) {
            @strongify(self);
            if (videoAccess && audioAcess) {
                [self replyInvitationWithType:1];
            }else{
                [self replyInvitationWithType:2];
            }
        }];
    }else if(index == 0){
        [self replyInvitationWithType:2];
    }
}
#pragma mark - 申请 上麦/下麦 接口请求封装
- (void)microApplyWithType:(NSInteger)type button:(UIButton *)button
{
    button.userInteractionEnabled = NO;
    NSString *str = type == 1 ? @"申请" : @"取消";

    @weakify(self);
    [_moviePlayer microApplyWithType:type finish:^(NSError *error) {
        @strongify(self);
        button.userInteractionEnabled = YES;
        if(!error) {
            if (type == 1) {
                //开启申请上麦倒计时
                [self.upMicBtnView countdDown:30];
            }
            NSString *msg = [NSString stringWithFormat:@"%@上麦成功",str];
            VH_ShowToast(msg);
        } else {
            //停止倒计时
            [self.upMicBtnView stopCountDown];

            NSString *msg = [NSString stringWithFormat:@"%@上麦失败: %@",str,error.description];
            VH_ShowToast(msg);
        }
    }];
}
#pragma mark - 同意/拒绝 邀请上麦接口请求封装
- (void)replyInvitationWithType:(NSInteger)type
{
    // type 1 同意 2 拒绝 3 超时
    [self.moviePlayer replyInvitationWithType:type finish:^(NSError *error) {
        if (type == 1) {
            if (!error) {
                if (self.clickReplyInvitation) {
                    self.clickReplyInvitation();
                }
            }else{
                VH_ShowToast(error.localizedDescription);
            }
        }
    }];
}
#pragma mark - --------------------播放器的上下麦回调---------------------------
#pragma mark - 是否允许举手
- (void)isInteractiveActivity:(BOOL)isInteractive interactivePermission:(VHInteractiveState)state
{
    //显示举手按钮
    if (isInteractive && state == VHInteractiveStateHave) {
        [self.upMicBtnView showCountView];
    } else { //隐藏举手按钮
        [self.upMicBtnView hiddenCountView];
    }
}
#pragma mark - 主持人同意上麦
- (void)microInvitationWithAttributes:(NSDictionary *)attributes error:(NSError *)error
{
    //停止倒计时
    [_upMicBtnView stopCountDown];
}
#pragma mark - 主持人邀请你上麦
- (void)microInvitation:(NSDictionary *)attributes
{
    
    //停止倒计时
    [_upMicBtnView stopCountDown];

    _invitationAlertView = [[VHInvitationAlert alloc] initWithDelegate:self
                                                                   tag:1000
                                                                 title:@"上麦邀请"
                                                               content:[NSString stringWithFormat:@"%@邀请您上麦，是否接受？",VH_MB_HOST]];
    [self.superview addSubview:_invitationAlertView];
}

#pragma mark - ---------------------礼物业务---------------------------
- (void)clickGiftBtn
{
    if (self.clickGiftBtnBlock) {
        self.clickGiftBtnBlock();
    }
}
#pragma mark - ---------------------点赞业务---------------------------
#pragma mark - 获取当前房间点赞总数
- (void)requestGetRoomLikeWithRoomId
{
    @weakify(self);
    [VHallLikeObject getRoomLikeWithRoomId:self.moviePlayer.webinarInfo.webinarInfoData.interact.room_id complete:^(NSInteger total, NSError *error) {
        @strongify(self);
        VHLog(@"当前房间点赞总数 === %ld",total);
        if (total) {
            [self vhPraiseTotalToNum:total];
        }
        if (error) {
            VH_ShowToast(error.localizedDescription);
        }
    }];
}

#pragma mark - 更新点赞总数
- (void)vhPraiseTotalToNum:(NSInteger)num
{
    self.num = num;
    //数值
    _likeBtn.badgeValue = num > 999 ? @"999+" :[NSString stringWithFormat:@"%ld",num];
    //边距尺寸
    _likeBtn.badgePadding = 5;
    //尺寸
    _likeBtn.badgeMinSize = 10;
    //背景颜色
    _likeBtn.badgeBGColor = [UIColor redColor];
    //字体颜色
    _likeBtn.badgeTextColor = [UIColor whiteColor];
    //x坐标值
    _likeBtn.badgeOriginX = 0;
    //y坐标值
    _likeBtn.badgeOriginY = -10;
}

#pragma mark - 点赞
- (void)clickLikeBtn
{
    [self destroyTimer];

    self.timer = [VHLiveWeakTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(recoverLikeImg) userInfo:nil repeats:NO];
    
    self.likeTapCount ++;

    self.likeImgNumbers = round(random() % 4) + 1+self.likeImgNumbers;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(requestRoomlikeToNum) object:nil];

    [self vhPraiseTotalToNum:self.num+1];
    
    [self startLikeTimer:self.likeImgNumbers];
}

- (void)destroyTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
#pragma mark - 恢复点赞效果
- (void)recoverLikeImg
{
    [self destroyTimer];
}
#pragma mark - 连续点赞
- (void)startLikeTimer:(NSInteger)likeNumber {
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.likeTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(.1 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.likeTimer, start, interval, 0);
    dispatch_source_set_event_handler(self.likeTimer, ^{
        static NSInteger liveTimeIdx = 0;
        liveTimeIdx += 1;
        if (self.likeImageArray.count) {
            uint32_t count = (uint32_t)self.likeImageArray.count;
            NSUInteger r = arc4random_uniform(count);
            NSString *imgUrl = self.likeImageArray[r];
            [VHLiveSaleAnimationTool praiseAnimation:imgUrl view:self.superview.superview];
        } else {
            [VHLiveSaleAnimationTool praiseAnimation:@"" view:self.superview.superview];
        }
        if (liveTimeIdx >= self.likeImgNumbers) {
                        
            self.likeImgNumbers = 0;
            dispatch_source_cancel(self.likeTimer);
            liveTimeIdx = 0;
            
            [self performSelector:@selector(requestRoomlikeToNum) withObject:nil afterDelay:2];
        }
        
    });
    dispatch_resume(self.likeTimer);
    
}
- (void)badgeThumbsUpCount:(int)count
{
    if (count<1) {
        return;
    }
}
#pragma mark - 点赞接口
- (void)requestRoomlikeToNum
{
    @weakify(self);
    [VHallLikeObject createUserLikeWithRoomId:self.moviePlayer.webinarInfo.webinarInfoData.interact.room_id num:self.likeTapCount complete:^(NSDictionary *responseObject, NSError *error) {
        @strongify(self);
        VHLog(@"点赞成功");
        self.likeTapCount = 0;
    }];
}

#pragma mark - -------------------------聊天------------------------
#pragma mark - 说点什么
- (void)chatBtnClick {
    self.messageToolView = [[VHKeyboardToolView alloc] init];
    _messageToolView.delegate = self;
    [_messageToolView becomeFirstResponder];
    [[UIApplication sharedApplication].delegate.window addSubview:_messageToolView];
}

#pragma mark VHKeyboardToolViewDelegate
- (void)keyboardToolView:(VHKeyboardToolView *)view sendText:(NSString *)text {
    if(_chat.isAllSpeakBlocked) {
        VH_ShowToast(@"已开启全体禁言");
        return;
    }
    if(_chat.isSpeakBlocked) {
        VH_ShowToast(@"您已被禁言");
        return;
    }
    
    if ([UIModelTools safeString:text].length == 0) {
        VH_ShowToast(@"发送的消息不能为空");
        return;
    }
    
    [_chat sendMsg:text success:^{
    } failed:^(NSDictionary *failedData) {
        NSString* str = [NSString stringWithFormat:@"%@ %@", failedData[@"code"],failedData[@"content"]];
        VH_ShowToast(str);
    }];
}

#pragma mark - 懒加载
- (MicCountDownView *)upMicBtnView
{
    if (!_upMicBtnView){
        _upMicBtnView = [[MicCountDownView alloc] init];
        _upMicBtnView.hidden = YES;
        _upMicBtnView.delegate = self;
        [_upMicBtnView.button addTarget:self action:@selector(micUpClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_upMicBtnView];
    }
    return _upMicBtnView;
}
- (UIButton *)giftBtn
{
    if (!_giftBtn) {
        _giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _giftBtn.hidden = YES;
        _giftBtn.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.3];
        _giftBtn.layer.masksToBounds = YES;
        _giftBtn.layer.cornerRadius = 35/2;
        [_giftBtn setImage:BundleUIImage(@"vh_fs_gift_btn") forState:UIControlStateNormal];
        [_giftBtn addTarget:self action:@selector(clickGiftBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_giftBtn];
    }return _giftBtn;
}
- (VHallLikeObject *)likeObject
{
    if (!_likeObject) {
        _likeObject = [[VHallLikeObject alloc] initWithObject:self.moviePlayer];
    }return _likeObject;
}
- (UIButton *)likeBtn
{
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeBtn.hidden = YES;
        _likeBtn.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.3];
        _likeBtn.layer.masksToBounds = YES;
        _likeBtn.layer.cornerRadius = 35/2;
        [_likeBtn setImage:BundleUIImage(@"vh_fs_like_btn") forState:UIControlStateNormal];
        [_likeBtn addTarget:self action:@selector(clickLikeBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_likeBtn];
    }return _likeBtn;
}
- (NSMutableArray *)likeImageArray
{
    if (!_likeImageArray) {
        _likeImageArray = [NSMutableArray arrayWithObjects:@"vh_fs_like_btn_1",@"vh_fs_like_btn_2",@"vh_fs_like_btn_3",@"vh_fs_like_btn_4",@"vh_fs_like_btn_5",@"vh_fs_like_btn_6",@"vh_fs_like_btn_7",@"vh_fs_like_btn_8",@"vh_fs_like_btn_9",nil];
    }return _likeImageArray;
}
- (UIImageView *)headImg
{
    if (!_headImg) {
        _headImg = [UIImageView new];
        _headImg.layer.masksToBounds = YES;
        _headImg.layer.cornerRadius = 28/2;
        [self addSubview:_headImg];
    }return _headImg;
}
- (UIButton *)chatBtn
{
    if (!_chatBtn)
    {
        _chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _chatBtn.layer.cornerRadius = 29.5/2.0;
        _chatBtn.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.3];
        _chatBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _chatBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _chatBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_chatBtn setTitle:@"参与聊天" forState:UIControlStateNormal];
        [_chatBtn setTitleColor:[UIColor colorWithHex:@"#E1E2E6"] forState:UIControlStateNormal];
        [_chatBtn addTarget:self action:@selector(chatBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_chatBtn];
    }
    return _chatBtn;
}

@end
