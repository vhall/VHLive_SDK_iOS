//
//  VHLotteryPrivateView.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/3/17.
//

#import "VHLotteryPrivateView.h"

@interface VHLotteryPrivateView ()
/// 标题图片
@property (nonatomic, strong) UIImageView *titleImg;
/// 关闭按钮
@property (nonatomic, strong) UIButton *closeBtn;
/// 查看中奖名单按钮
@property (nonatomic, strong) UIView *bgView;
/// 标题
@property (nonatomic, strong) UILabel *titleLab;
/// 抽奖类
@property (nonatomic, strong) UIImageView *contentImg;
/// 结束抽奖数据
@property (nonatomic, strong) UILabel *infoLab;
/// 抽奖类
@property (nonatomic, strong) VHallLottery *vhLottery;
/// 结束抽奖数据
@property (nonatomic, strong) VHallEndLotteryModel *endLotteryModel;

@end

@implementation VHLotteryPrivateView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.5];

        [self addSubview:self.contentView];
        [self addSubview:self.titleImg];
        [self.contentView addSubview:self.closeBtn];
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.titleLab];
        [self.bgView addSubview:self.contentImg];
        [self.bgView addSubview:self.infoLab];

        // 初始化布局
        [self setUpMasonry];
    }

    return self;
}

#pragma mark - 初始化布局
- (void)setUpMasonry
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(322);
    }];

    [self.titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(-6.5);
        make.size.mas_equalTo(CGSizeMake(240, 40));
    }];

    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.right.mas_equalTo(-16);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleImg.mas_bottom).offset(16);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(218);
    }];

    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(22);
    }];

    [self.contentImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(130, 130));
    }];

    [self.infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentImg.mas_bottom).offset(10);
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(22);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.contentView setBackgroundColor:[UIColor bm_colorGradientChangeWithSize:self.contentView.size direction:IHGradientChangeDirectionLevel startColor:[UIColor colorWithHex:@"#FFFBE8"] endColor:[UIColor colorWithHex:@"#FBF0E6"]]];
}

#pragma mark - 弹窗
- (void)showLotteryPrivateWithVHLottery:(VHallLottery *)vhLottery endLotteryModel:(VHallEndLotteryModel *)endLotteryModel submitList:(NSArray <VHallLotterySubmitConfig *> *)submitList
{

    [[VUITool getCurrentScreenViewController].view addSubview:self];

    [super show];

    self.vhLottery = vhLottery;
    self.endLotteryModel = endLotteryModel;

    for (VHallLotterySubmitConfig *submitConfig in submitList) {
        if ([submitConfig.field_key isEqualToString:@"private_number"]) {
            self.titleLab.text = [VUITool substringToIndex:20 text:submitConfig.placeholder isReplenish:YES];
        }

        if ([submitConfig.field_key isEqualToString:@"private_qrcode"]) {
            [self.contentImg sd_setImageWithURL:[NSURL URLWithString:submitConfig.placeholder]];
        }

        if ([submitConfig.field_key isEqualToString:@"tip_note"]) {
            self.infoLab.text = submitConfig.placeholder;
        }
    }

    // 自动化测试,私信领奖
    NSMutableDictionary *otherInfo = [NSMutableDictionary dictionary];
    [VUITool sendTestsNotificationCenterWithKey:VHTests_Lottery_Private otherInfo:otherInfo];
}

#pragma mark - 隐藏
- (void)disMissContentView {
}

#pragma mark - 隐藏
- (void)dismiss
{
    [super disMissContentView];
}

#pragma mark - 长按保存相册
- (void)imglongTapClick:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请问需要将此图片保存到相册吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *needAlertAction = [UIAlertAction actionWithTitle:@"需要"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *_Nonnull action) {
            UIImageWriteToSavedPhotosAlbum(self.contentImg.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }];
        [needAlertAction setValue:VHMainColor forKey:@"titleTextColor"];
        UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:@"不用" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) { }];
        [alertController addAction:needAlertAction];
        [alertController addAction:cancelAlertAction];
        [[VUITool getCurrentScreenViewController] presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [VHProgressHud showToast:@"保存成功"];
    } else {
        [VHProgressHud showToast:@"保存失败"];
    }
}

#pragma mark - 点击关闭
- (void)clickCloseBtn
{
    [self dismiss];
}

#pragma mark - 懒加载
- (UIImageView *)titleImg
{
    if (!_titleImg) {
        _titleImg = [[UIImageView alloc] init];
        _titleImg.image = [UIImage imageNamed:@"vh_lottery_alert_Private_title"];
    }

    return _titleImg;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.accessibilityLabel = VHTests_Lottery_PrivateClose;
        [_closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setImage:[UIImage imageNamed:@"vh_lottery_alert_submit_close"] forState:UIControlStateNormal];
    }

    return _closeBtn;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 6;
        _bgView.backgroundColor = [UIColor whiteColor];
    }

    return _bgView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor colorWithHex:@"#262626"];
        _titleLab.font = FONT(16);
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }

    return _titleLab;
}

- (UIImageView *)contentImg {
    if (!_contentImg) {
        _contentImg = [[UIImageView alloc] init];
        _contentImg.userInteractionEnabled = YES;
        _contentImg.contentMode = UIViewContentModeScaleAspectFit;
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imglongTapClick:)];
        [_contentImg addGestureRecognizer:longTap];
    }

    return _contentImg;
}

- (UILabel *)infoLab {
    if (!_infoLab) {
        _infoLab = [[UILabel alloc] init];
        _infoLab.textColor = [UIColor colorWithHex:@"#262626"];
        _infoLab.font = FONT(16);
        _infoLab.textAlignment = NSTextAlignmentCenter;
    }

    return _infoLab;
}

@end
