//
//  VHLotteryTurntableView.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/3/15.
//

#import "VHLotteryTurntableView.h"

@interface VHLotteryTurntableView ()
/// 图片
@property (nonatomic, strong) UIImageView * iconImg;
/// 关闭按钮
@property (nonatomic, strong) UIButton * closeBtn;
/// 发送按钮
@property (nonatomic, strong) UIButton * sendBtn;

/// 抽奖类
@property (nonatomic, strong) VHallLottery * vhLottery;
/// 开始抽奖数据
@property (nonatomic, strong) VHallStartLotteryModel * startModel;
@end

@implementation VHLotteryTurntableView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]){
        
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.5];
                
        [self addSubview:self.iconImg];
        [self addSubview:self.sendBtn];
        [self addSubview:self.closeBtn];
        // 初始化布局
        [self setUpMasonry];

    }return self;

}

#pragma mark - 初始化布局
- (void)setUpMasonry
{
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.iconImg.mas_centerX);
        make.top.mas_equalTo(self.iconImg.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(160, 44));
    }];

    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.sendBtn.mas_centerX);
        make.top.mas_equalTo(self.sendBtn.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - 弹窗
- (void)showLotteryTurntableWithVHLottery:(VHallLottery *)vhLottery startModel:(VHallStartLotteryModel *)startModel
{
    self.vhLottery = vhLottery;
    self.startModel = startModel;
    
    [[VUITool getCurrentScreenViewController].view addSubview:self];
    
    // 调整图片大小
    __weak __typeof(self)weakSelf = self;
    NSString * imgStr = @"";
    if ([startModel.icon containsString:@"https"] || [startModel.icon containsString:@"http"]){
        imgStr = startModel.icon;
    } else {
        imgStr = [NSString stringWithFormat:@"https:%@",startModel.icon];
    }
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"正在加载"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            [weakSelf.iconImg mas_updateConstraints:^(MASConstraintMaker *make) {
                CGFloat width = Screen_Width - 30;
                CGFloat scale = width/image.size.width;
                CGFloat height = image.size.height * scale;
                make.size.mas_equalTo(CGSizeMake(width, height));
            }];
        }
    }];

    // 判断发送按钮的显示
    [self.sendBtn setHidden:startModel.huadieInfo.lottery_type != 8];
    [self.sendBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160, startModel.huadieInfo.lottery_type == 8 ? 44 : 0));
    }];
    
    [super show];
}
#pragma mark - 隐藏
- (void)disMissContentView{}
#pragma mark - 隐藏
- (void)dismiss
{
    [super disMissContentView];
}
#pragma mark - 点击发送
- (void)clickSendBtn
{
    [self.vhLottery lotteryParticipationWithRoomId:self.startModel.huadieInfo.room_id lottery_id:self.startModel.huadieInfo.lottery_id command:self.startModel.huadieInfo.command success:^{
        [VHProgressHud showToast:@"参与成功"];
        [super disMissContentView];
    } failed:^(NSDictionary *failedData) {
        NSString * msg = [NSString stringWithFormat:@"%@",failedData[@"content"]];
        [VHProgressHud showToast:msg];
    }];
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
    }
    return _iconImg;
}
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setImage:[UIImage imageNamed:@"vh_lottery_alert_close"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}
- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.hidden = YES;
        [_sendBtn.layer setMasksToBounds:YES];
        [_sendBtn.layer setCornerRadius:44/2];
        [_sendBtn.titleLabel setFont:FONT(16)];
        [_sendBtn setTitle:@"立即发送口令" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendBtn setBackgroundColor:VHMainColor];
        [_sendBtn addTarget:self action:@selector(clickSendBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

@end
