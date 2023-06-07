//
//  VHLotteryLosingView.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/3/16.
//

#import "VHLotteryLosingView.h"

@interface VHLotteryLosingView ()
/// 图片
@property (nonatomic, strong) UIImageView *iconImg;
/// 装饰
@property (nonatomic, strong) UIImageView *decorateImg;
/// 标题图片
@property (nonatomic, strong) UIImageView *titleImg;
/// 关闭按钮
@property (nonatomic, strong) UIButton *closeBtn;
/// 查看中奖名单按钮
@property (nonatomic, strong) UIButton *checkBtn;

/// 抽奖类
@property (nonatomic, strong) VHallLottery *vhLottery;
/// 结束抽奖数据
@property (nonatomic, strong) VHallEndLotteryModel *endLotteryModel;

@end

@implementation VHLotteryLosingView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.5];

        [self addSubview:self.decorateImg];
        [self addSubview:self.iconImg];
        [self addSubview:self.titleImg];
        [self addSubview:self.closeBtn];
        [self addSubview:self.checkBtn];

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
        make.size.mas_equalTo(CGSizeMake(230, 230));
    }];

    [self.decorateImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImg.mas_top).offset(-30);
        make.centerX.mas_equalTo(self.iconImg.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(320, 270));
    }];

    [self.titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.iconImg);
        make.size.mas_equalTo(CGSizeMake(165.5, 38.5));
    }];

    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImg.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.iconImg.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(160, 44));
    }];

    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.checkBtn.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.iconImg.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - 弹窗
- (void)showLotteryLosingWithVHLottery:(VHallLottery *)vhLottery endLotteryModel:(VHallEndLotteryModel *)endLotteryModel
{
    self.vhLottery = vhLottery;
    self.endLotteryModel = endLotteryModel;

    [[VUITool getCurrentScreenViewController].view addSubview:self];

    [super show];
    
    // 自动化测试,结束抽奖,中奖了
    NSMutableDictionary *otherInfo = [NSMutableDictionary dictionary];
    [VUITool sendTestsNotificationCenterWithKey:VHTests_Lottery_End_Losing otherInfo:otherInfo];
}

#pragma mark - 隐藏
- (void)disMissContentView {
}

#pragma mark - 隐藏
- (void)dismiss
{
    [super disMissContentView];
}

#pragma mark - 点击查看中奖名单
- (void)clickCheckBtn
{
    if ([self.delegate respondsToSelector:@selector(clickCheckWinListWithEndLotteryModel:)]) {
        [self.delegate clickCheckWinListWithEndLotteryModel:self.endLotteryModel];
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
        _iconImg.image = [UIImage imageNamed:@"vh_lottery_alert_losing_bg"];
        _iconImg.userInteractionEnabled = YES;
    }

    return _iconImg;
}

- (UIImageView *)decorateImg {
    if (!_decorateImg) {
        _decorateImg = [[UIImageView alloc] init];
        _decorateImg.image = [UIImage imageNamed:@"vh_lottery_alert_decorate"];
    }

    return _decorateImg;
}

- (UIImageView *)titleImg
{
    if (!_titleImg) {
        _titleImg = [[UIImageView alloc] init];
        _titleImg.image = [UIImage imageNamed:@"vh_lottery_alert_losing_title"];
    }

    return _titleImg;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setImage:[UIImage imageNamed:@"vh_lottery_alert_close"] forState:UIControlStateNormal];
    }

    return _closeBtn;
}

- (UIButton *)checkBtn {
    if (!_checkBtn) {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkBtn.accessibilityLabel = VHTests_Lottery_LosingCheck;
        [_checkBtn.layer setMasksToBounds:YES];
        [_checkBtn.layer setCornerRadius:44 / 2];
        [_checkBtn.titleLabel setFont:FONT(16)];
        [_checkBtn setTitle:@"查看中奖名单" forState:UIControlStateNormal];
        [_checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_checkBtn setBackgroundColor:VHMainColor];
        [_checkBtn addTarget:self action:@selector(clickCheckBtn) forControlEvents:UIControlEventTouchUpInside];
    }

    return _checkBtn;
}

@end
