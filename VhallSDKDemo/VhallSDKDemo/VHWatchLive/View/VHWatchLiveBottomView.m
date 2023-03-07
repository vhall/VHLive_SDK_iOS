//
//  VHWatchLiveBottomView.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/13.
//

#import "VHWatchLiveBottomView.h"
#import "VHKeyboardToolView.h"
#import "VHLikeObject.h"

@interface VHWatchLiveBottomView ()<VHKeyboardToolViewDelegate>

/// 注册对象
@property (nonatomic, strong) NSObject * obj;
/// 房间详情
@property (nonatomic, strong) VHWebinarInfoData * webinarInfoData;
/// 头像
@property (nonatomic, strong) UIImageView * headImg;
/// 聊天按钮
@property (nonatomic, strong) UIButton * chatBtn;
/// 问答按钮
@property (nonatomic, strong) UIButton * questionBtn;
/// 聊天工具栏
@property (nonatomic, strong) VHKeyboardToolView * messageToolView;
/// 记录是否被禁言
@property (nonatomic, assign) BOOL forbidChat;
/// 记录是否全体禁言
@property (nonatomic, assign) BOOL allForbidChat;
/// 问答禁言状态
@property (nonatomic, assign) BOOL questionStatus;
/// 回放禁言
@property (nonatomic, assign) BOOL watch_record_no_chatting;
/// 互动连麦按钮
@property (nonatomic, strong) UIButton * inavBtn;
/// 礼物按钮
@property (nonatomic, strong) UIButton * giftBtn;
/// 点赞按钮
@property (nonatomic, strong) VHLikeObject * likeBtn;
/// 是否是聊天
@property (nonatomic, assign) BOOL isChat;
@end

@implementation VHWatchLiveBottomView

#pragma mark - 初始化
- (instancetype)initWithObject:(NSObject *)obj webinarInfoData:(VHWebinarInfoData *)webinarInfoData
{
    if ([super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.obj = obj;
        self.webinarInfoData = webinarInfoData;

        // 添加控件
        [self addViews];
        
        // 初始化布局
        [self masonryUI];

        // 显隐控件
        [self controlsWithIsHidden:webinarInfoData.webinar.type == 1 ? YES : NO];

        // 初始化聊天
        [self participateInIsChat:YES];
        
        // 初始化数据
        [self initWithData];
        
    }return self;
}

#pragma mark - 添加UI
- (void)addViews
{
    [self addSubview:self.headImg];
    [self addSubview:self.chatBtn];
    [self addSubview:self.questionBtn];
    [self addSubview:self.inavBtn];
    [self addSubview:self.giftBtn];
    [self addSubview:self.likeBtn];
}

#pragma mark - 初始化布局
- (void)masonryUI
{
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.headImg.mas_centerY);
        make.right.mas_equalTo(-8);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];

    [self.giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.headImg.mas_centerY);
        make.right.mas_equalTo(self.likeBtn.mas_left).offset(-8);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.inavBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.headImg.mas_centerY);
        make.right.mas_equalTo(self.giftBtn.mas_left).offset(-8);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];

    [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.headImg.mas_centerY);
        make.left.mas_equalTo(self.headImg.mas_right).offset(8);
        make.right.mas_equalTo(self.giftBtn.mas_left).offset(-8);
        make.height.mas_equalTo(30);
    }];
    
    [self.questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.headImg.mas_centerY);
        make.left.mas_equalTo(self.headImg.mas_right).offset(8);
        make.right.mas_equalTo(self.giftBtn.mas_left).offset(-8);
        make.height.mas_equalTo(30);
    }];

}

#pragma mark - 显隐控件 直播为true
- (void)controlsWithIsHidden:(BOOL)isHidden
{
    
}

#pragma mark - 初始化数据
- (void)initWithData
{
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:self.webinarInfoData.join_info.avatar]];
    
    // 获取权限配置项
    [self permissionsCheckWithWebinarId];
}

#pragma mark - 获取房间配置项权限
- (void)permissionsCheckWithWebinarId
{
    __weak __typeof(self)weakSelf = self;
    [VHWebinarBaseInfo permissionsCheckWithWebinarId:self.webinarInfoData.webinar.data_id webinar_user_id:self.webinarInfoData.webinar.userinfo.user_id scene_id:@"1" success:^(VHPermissionConfigItem * _Nonnull item) {
        
        // 是否开启回放禁言
        if (weakSelf.webinarInfoData.webinar.type == 4 || weakSelf.webinarInfoData.webinar.type == 5) {
            weakSelf.watch_record_no_chatting = item.watch_record_no_chatting;
            [weakSelf isForbidChat:item.watch_record_no_chatting questionStatus:weakSelf.questionStatus];
        }
        // 礼物
        weakSelf.giftBtn.hidden = !item.hide_gifts;
        // 点赞
        weakSelf.likeBtn.hidden = !item.watch_hide_like;

        // 刷新点赞和礼物的显示
        [weakSelf isGiftHidden:weakSelf.giftBtn.hidden likeHidden:weakSelf.likeBtn.hidden];

    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 刷新点赞和礼物的显示
- (void)isGiftHidden:(BOOL)giftHidden likeHidden:(BOOL)likeHidden
{
    [self.likeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.headImg.mas_centerY);
        make.right.mas_equalTo(likeHidden ? 0 : -8);
        make.size.mas_equalTo(CGSizeMake(likeHidden ? 0 :30, likeHidden ? 0 : 30));
    }];

    [self.giftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.headImg.mas_centerY);
        make.right.mas_equalTo(self.likeBtn.mas_left).offset(giftHidden ? 0 : -8);
        make.size.mas_equalTo(CGSizeMake(giftHidden ? 0 : 30, giftHidden ? 0 : 30));
    }];
}

#pragma mark - 当前活动是否允许举手申请上麦回调
- (void)isInteractiveActivity:(BOOL)isInteractive interactivePermission:(VHInteractiveState)state
{
    // 互动期间常显连麦按钮
    if (!self.isLive) {
        
        [self inavBtnIsHidden:NO];

    } else {
        
        // 非互动期间 根据状态判断 是否显示参与互动连麦的按钮
        BOOL isShow = isInteractive && state == VHInteractiveStateHave;
        
        [self inavBtnIsHidden:!isShow];
    }
}

#pragma mark - 刷新按钮状态
- (void)inavBtnIsHidden:(BOOL)isHidden
{
    self.inavBtn.hidden = isHidden;

    [self.inavBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(isHidden ? 0 : 35, isHidden ? 0 : 35));
    }];
    
    [self.chatBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.headImg.mas_centerY);
        make.left.mas_equalTo(self.headImg.mas_right).offset(8);
        make.right.mas_equalTo(isHidden ? self.giftBtn.mas_left : self.inavBtn.mas_left).offset(-8);
        make.height.mas_equalTo(30);
    }];
    
    [self.questionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.headImg.mas_centerY);
        make.left.mas_equalTo(self.headImg.mas_right).offset(8);
        make.right.mas_equalTo(isHidden ? self.giftBtn.mas_left : self.inavBtn.mas_left).offset(-8);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark - 参与聊天还是参与问答
- (void)participateInIsChat:(BOOL)isChat
{
    self.isChat = isChat;
    
    self.chatBtn.hidden = !isChat;
    self.questionBtn.hidden = isChat;

    [self isForBidChatToLiveType];
}

#pragma mark - 收到自己被禁言/取消禁言
- (void)forbidChat:(BOOL)forbidChat
{
    self.forbidChat = forbidChat;
    
    if (forbidChat) {
        [self.messageToolView resignFirstResponder];
    }
    
    [self isForBidChatToLiveType];
}

#pragma mark - 收到全体被禁言/取消禁言
- (void)allForbidChat:(BOOL)allForbidChat
{
    self.allForbidChat = allForbidChat;

    if (allForbidChat) {
        [self.messageToolView resignFirstResponder];
    }

    [self isForBidChatToLiveType];
}

#pragma mark - 问答状态
- (void)questionStatus:(BOOL)questionStatus
{
    self.questionStatus = questionStatus;
    
    [self isForBidChatToLiveType];
}

#pragma mark - 判断状态是直播还是回放
- (void)isForBidChatToLiveType
{
    if (self.webinarInfoData.webinar.type == 4 || self.webinarInfoData.webinar.type == 5) {
        [self isForbidChat:self.watch_record_no_chatting || self.allForbidChat questionStatus:self.questionStatus];
    } else {
        [self isForbidChat:self.forbidChat || self.allForbidChat questionStatus:self.questionStatus];
    }
}

#pragma mark - 更新禁言状态
- (void)isForbidChat:(BOOL)isForbidChat questionStatus:(BOOL)questionStatus
{
    self.messageToolView.maxLength = self.isChat ? 140 : 0;
    self.messageToolView.placeholder = self.isChat ? @"参与聊天" : @"快来提问吧";

    [self.chatBtn setTitle:isForbidChat ? @"禁止发言" : @"参与聊天" forState:UIControlStateNormal];

    [self.questionBtn setTitle:questionStatus ? @"快来提问吧" : @"禁止发言" forState:UIControlStateNormal];
}

#pragma mark - 参与聊天 或者 参与问答
- (void)chatBtnClick
{
    if (self.isChat) {
        
        if (self.forbidChat || self.allForbidChat) {
            [VHProgressHud showToast:@"您已被禁言"];
            return;
        }

        if (self.webinarInfoData.webinar.type == 4 || self.webinarInfoData.webinar.type == 5) {
            if (self.watch_record_no_chatting) {
                [VHProgressHud showToast:@"您已被禁言"];
                return;
            }
        }
    } else {
        if (!self.questionStatus) {
            [VHProgressHud showToast:@"您已被禁言"];
            return;
        }
    }
    
    [self.messageToolView becomeFirstResponder];
}

#pragma mark - 点击互动连麦
- (void)clickInavBtn
{
    if ([self.delegate respondsToSelector:@selector(clickInav)]){
        [self.delegate clickInav];
    }
}

#pragma mark - 点击礼物
- (void)clickGiftBtn
{
    if ([self.delegate respondsToSelector:@selector(clickGift)]){
        [self.delegate clickGift];
    }
}

#pragma mark VHKeyboardToolViewDelegate
- (void)keyboardToolView:(VHKeyboardToolView *)view sendText:(NSString *)text {
    
    if ([self.delegate respondsToSelector:@selector(sendText:)]){
        [self.delegate sendText:text];
    }
}

#pragma mark - 懒加载
- (UIImageView *)headImg {
    if (!_headImg) {
        _headImg = [[UIImageView alloc] init];
        _headImg.layer.masksToBounds = YES;
        _headImg.layer.cornerRadius = 30/2;
    }
    return _headImg;
}

- (UIButton *)chatBtn
{
    if (!_chatBtn)
    {
        _chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _chatBtn.layer.cornerRadius = 30/2.0;
        _chatBtn.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
        _chatBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _chatBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _chatBtn.titleLabel.font = FONT(14);
        [_chatBtn setTitle:@"参与聊天" forState:UIControlStateNormal];
        [_chatBtn setTitleColor:[UIColor colorWithHex:@"#BFBFBF"] forState:UIControlStateNormal];
        [_chatBtn addTarget:self action:@selector(chatBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_chatBtn];
    }
    return _chatBtn;
}

- (UIButton *)questionBtn
{
    if (!_questionBtn)
    {
        _questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _questionBtn.layer.cornerRadius = 30/2.0;
        _questionBtn.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
        _questionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _questionBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _questionBtn.titleLabel.font = FONT(14);
        [_questionBtn setTitle:@"快来提问吧" forState:UIControlStateNormal];
        [_questionBtn setTitleColor:[UIColor colorWithHex:@"#BFBFBF"] forState:UIControlStateNormal];
        [_questionBtn addTarget:self action:@selector(chatBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_questionBtn];
    }
    return _questionBtn;
}

- (UIButton *)inavBtn
{
    if (!_inavBtn) {
        _inavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _inavBtn.hidden = YES;
        [_inavBtn setImage:[UIImage imageNamed:@"vh_inav_icon"] forState:UIControlStateNormal];
        [_inavBtn addTarget:self action:@selector(clickInavBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_inavBtn];
    }return _inavBtn;
}

- (UIButton *)giftBtn
{
    if (!_giftBtn) {
        _giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _giftBtn.hidden = YES;
        [_giftBtn setImage:[UIImage imageNamed:@"vh_fs_gift_btn"] forState:UIControlStateNormal];
        [_giftBtn addTarget:self action:@selector(clickGiftBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_giftBtn];
    }return _giftBtn;
}
- (VHLikeObject *)likeBtn
{
    if (!_likeBtn) {
        _likeBtn = [[VHLikeObject alloc] initLikeWithObject:self.obj webinarInfoData:self.webinarInfoData];
        _likeBtn.hidden = YES;
        [self addSubview:_likeBtn];
    }return _likeBtn;
}

- (VHKeyboardToolView *)messageToolView
{
    if (!_messageToolView) {
        _messageToolView = [[VHKeyboardToolView alloc] init];
        [_messageToolView setHidden:NO];
        [_messageToolView setDelegate:self];
        [[VUITool mainWindow] addSubview:_messageToolView];
    }return _messageToolView;
}

#pragma mark - 释放
- (void)dealloc
{
    // 置空
    if (_messageToolView) {
        [_messageToolView removeFromSuperview];
        _messageToolView = nil;
    }
    VHLog(@"%s释放",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String]);
}

@end
