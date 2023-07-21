//
//  VHPushScreenCardAlert.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/7/4.
//

#import "VHPushScreenCardAlert.h"
#import "VHTimer.h"
#import "VHPushScreenCardDeleteAlert.h"

@interface VHPushScreenCardAlert ()
/// 图片
@property (nonatomic, strong) UIImageView *iconImg;
/// 描述
@property (nonatomic, strong) UILabel * infoLab;
/// 发送按钮
@property (nonatomic, strong) UIButton *linkeBtn;
/// 关闭按钮
@property (nonatomic, strong) UIButton *closeBtn;
/// 倒计时关闭
@property (nonatomic, strong) YYLabel *timeClose;
/// 计时器
@property (nonatomic, strong) VHTimer *vhTimer;

/// 已被删除提示
@property (nonatomic, strong) VHPushScreenCardDeleteAlert *pushScreenCardDeleteAlert;
/// 数据模型
@property (nonatomic, strong) VHPushScreenCardItem *model;

@end

@implementation VHPushScreenCardAlert

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.5];

        [self addSubview:self.iconImg];
        [self addSubview:self.infoLab];
        [self addSubview:self.linkeBtn];
        [self addSubview:self.closeBtn];
        [self addSubview:self.timeClose];
        
        // 初始化布局
        [self setUpMasonry];
    }

    return self;
}

#pragma mark - 初始化布局
- (void)setUpMasonry
{
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    
    [self.infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.iconImg.mas_centerX);
        make.top.mas_equalTo(self.iconImg.mas_bottom).offset(8);
    }];

    [self.linkeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.iconImg.mas_centerX);
        make.top.mas_equalTo(self.infoLab.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];

    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.linkeBtn.mas_centerX);
        make.top.mas_equalTo(self.linkeBtn.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    [self.timeClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.iconImg.mas_right);
        make.bottom.mas_equalTo(self.iconImg.mas_top).offset(-12);
        make.size.mas_equalTo(CGSizeMake(76, 32));
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - 弹窗
- (void)showPushScreenCard:(VHPushScreenCardItem *)model isChat:(BOOL)isChat
{
    self.model = model;
    
    // 判断是否是推屏卡片消息
    if (isChat) {
        [self showAlert:model];
    } else {
        
        __weak __typeof(self)weakSelf = self;
        [VHPushScreenCardObject requestPushScreenCardInfoWithWebinarId:model.webinar_id card_id:model.ID complete:^(VHPushScreenCardItem *item, NSError *error) {
            __strong __typeof(weakSelf)self = weakSelf;

            if (item) {
                // 弹窗
                [self showAlert:item];
            }

            if (error) {
                if (error.code == 513600) {
                    // 卡片已被删除
                    [[VUITool getCurrentScreenViewController].view addSubview:self.pushScreenCardDeleteAlert];
                    [self.pushScreenCardDeleteAlert show];
                } else {
                    [VHProgressHud showToast:error.domain];
                }
            }
        }];
    }
}

- (void)showAlert:(VHPushScreenCardItem *)model
{
    self.model = model;

    [[VUITool getCurrentScreenViewController].view addSubview:self];

    [super show];

    // 图片赋值
    [self.iconImg setContentMode:model.img_mode];
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.img_url]];
    
    // 重置大小
    [self.iconImg mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat width = Screen_Width - 95; CGFloat height = 0;
        if (model.img_rate == 0) {
            height = width * 4 / 3;
        } else if (model.img_rate == 1) {
            height = width * 3 / 4;
        } else {
            height = width;
        }
        make.size.mas_equalTo(CGSizeMake(width, height));
    }];

    // 描述
    self.infoLab.text = model.remark;

    // 关闭类型
    [self.timeClose setHidden:!model.timer_enable];
    [self.closeBtn setHidden:model.timer_enable];

    // 计时器
    if (self.vhTimer) {
        [self.vhTimer stop];
    }
    if (model.timer_enable) {
        [self startTimer:model.timer_interval];
    }

    // 判断发送按钮的显示
    BOOL isShow = model.href_enable && ![VUITool isBlankString:model.href_btn_label];
    [self.linkeBtn setTitle:model.href_btn_label forState:UIControlStateNormal];
    [self.linkeBtn setHidden:!isShow];
    [self.linkeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat height = isShow ? 44 : 0;
        CGFloat width = 0;
        if (isShow) {
            // 根据文本内容自适应高度
            NSDictionary *attributes = @{NSFontAttributeName: FONT(16)};
            CGSize size = CGSizeMake(MAXFLOAT, MAXFLOAT);
            CGRect rect = [model.href_btn_label boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
            width = rect.size.width + 35;
        }
        make.size.mas_equalTo(CGSizeMake(width, height));
    }];
}

#pragma mark - 开始计时器
- (void)startTimer:(NSInteger)timeinterval
{
    __weak __typeof(self) weakSelf = self;
    self.vhTimer = [[VHTimer alloc] initWithStartTimeinterval:timeinterval
                                                     isAscend:NO
                                                progressBlock:^(VHTime *progress) {
        __strong __typeof(weakSelf)self = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            // 在主线程中刷新UI
            self.timeClose.text = [NSString stringWithFormat:@"%ds 关闭", (progress.residueMinute * 60) + progress.residueSecond + 1];
        });
    }
                                              completionBlock:^{
        __strong __typeof(weakSelf)self = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            // 在主线程中刷新UI
            [self dismiss];
        });
        [self.vhTimer stop];
    }];
    [self.vhTimer resume];
}

#pragma mark - 隐藏
- (void)disMissContentView
{
    // 判断是否开启跳转连接
    [self clickLinkeBtn];
}

#pragma mark - 隐藏
- (void)dismiss
{
    [super disMissContentView];
}

#pragma mark - 点击链接
- (void)clickLinkeBtn
{
    // 判断是否开启跳转连接
    if (self.model.href_enable) {
        
        [self dismiss];
        
        [VHPushScreenCardObject requestPushScreenCardClickWithWebinarId:self.model.webinar_id switch_id:self.model.switch_id card_id:self.model.ID fail:^(NSError *error) {
            if (error) {
                [VHProgressHud showToast:error.domain];
            }
        }];
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.model.href]]) {
            NSDictionary *options = @{
                    UIApplicationOpenURLOptionUniversalLinksOnly: @NO
            };
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.model.href] options:options completionHandler:nil];
        }
    }
}

#pragma mark - 点击关闭
- (void)clickCloseBtn
{
    [self dismiss];
}

#pragma mark - 懒加载
- (UIImageView *)iconImg {
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.backgroundColor = [UIColor clearColor];
        _iconImg.contentMode = UIViewContentModeScaleAspectFit;
        _iconImg.layer.masksToBounds = YES;
    }

    return _iconImg;
}

- (UILabel *)infoLab {
    if (!_infoLab) {
        _infoLab = [[UILabel alloc] init];
        _infoLab.textColor = [UIColor colorWithHex:@"#FFF1D7"];
        _infoLab.font = FONT(16);
        _infoLab.numberOfLines = 2;
        _infoLab.preferredMaxLayoutWidth = Screen_Width - 30;
        _infoLab.textAlignment = NSTextAlignmentCenter;
    }

    return _infoLab;
}

- (UIButton *)linkeBtn {
    if (!_linkeBtn) {
        _linkeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _linkeBtn.hidden = YES;
        [_linkeBtn.layer setMasksToBounds:YES];
        [_linkeBtn.layer setCornerRadius:44 / 2];
        [_linkeBtn.titleLabel setFont:FONT(16)];
        [_linkeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_linkeBtn setBackgroundColor:VHMainColor];
        [_linkeBtn addTarget:self action:@selector(clickLinkeBtn) forControlEvents:UIControlEventTouchUpInside];
    }

    return _linkeBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.hidden = YES;
        _closeBtn.accessibilityLabel = VHTests_PushScreenCard_Close;
        [_closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setImage:[UIImage imageNamed:@"vh_lottery_alert_close"] forState:UIControlStateNormal];
    }

    return _closeBtn;
}

#pragma mark - 懒加载
- (YYLabel *)timeClose
{
    if (!_timeClose) {
        _timeClose = [YYLabel new];
        _timeClose.hidden = YES;
        _timeClose.textColor = [UIColor whiteColor];
        _timeClose.font = FONT(15);
        _timeClose.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.45];
        _timeClose.layer.masksToBounds = YES;
        _timeClose.layer.cornerRadius = 32 / 2;
        _timeClose.textAlignment = NSTextAlignmentCenter;
    }

    return _timeClose;
}

- (VHPushScreenCardDeleteAlert *)pushScreenCardDeleteAlert
{
    if (!_pushScreenCardDeleteAlert) {
        _pushScreenCardDeleteAlert = [[VHPushScreenCardDeleteAlert alloc] initWithFrame:[VUITool getCurrentScreenViewController].view.bounds];
    }
    
    return _pushScreenCardDeleteAlert;
}
@end
