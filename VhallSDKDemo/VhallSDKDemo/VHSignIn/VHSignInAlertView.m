//
//  VHSignInAlertView.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/22.
//

#import "VHSignInAlertView.h"
#import "VHTimer.h"

@interface VHSignInAlertView ()<VHallSignDelegate>

/// 签到类
@property (nonatomic, strong) VHallSign * vhSign;
/// 标题
@property (nonatomic, strong) UILabel * titleLab;
/// 计时器
@property (nonatomic, strong) UILabel * timeLab;
/// 取消
@property (nonatomic, strong) UIButton * applyBtn;
/// 关闭按钮
@property (nonatomic, strong) UIButton * closeBtn;
/// 活动详情
@property (nonatomic, strong) VHWebinarInfoData * webinarInfoData;
@end

@implementation VHSignInAlertView

#pragma mark - 初始化
- (instancetype)initSignWithFrame:(CGRect)frame obj:(NSObject *)obj webinarInfoData:(VHWebinarInfoData *)webinarInfoData
{
    if ([super initWithFrame:frame]){
        
        self.backgroundColor = [UIColor clearColor];
        
        self.webinarInfoData = webinarInfoData;
        
        self.vhSign = [[VHallSign alloc] initWithObject:obj];
        self.vhSign.delegate = self;
        
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.applyBtn];
        [self.contentView addSubview:self.closeBtn];

        // 初始化布局
        [self setUpMasonry];

    }return self;

}

#pragma mark - 初始化布局
- (void)setUpMasonry
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(300);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(45);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLab.mas_bottom).offset(60);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    
    [_applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-60);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(180, 45));
    }];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.right.mas_equalTo(-16);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setBackgroundColor:[UIColor bm_colorGradientChangeWithSize:self.contentView.size direction:IHGradientChangeDirectionLevel startColor:[UIColor colorWithHex:@"#FDF1ED"] endColor:[UIColor colorWithHexString:@"#F3F2FF"]]];
}

- (void)show
{
    [[VUITool getCurrentScreenViewController].view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];

    [super show];
}

#pragma mark - VHallSignDelegate
#pragma mark - 收到主持人发起签到消息
- (void)startSign
{
    [VHProgressHud showToast:@"开始签到"];

    [self show];
    
    if ([self.delegate respondsToSelector:@selector(startSign)]) {
        [self.delegate startSign];
    }
}

#pragma mark - 距签到结束剩余时间，每秒会回调一次
- (void)signRemainingTime:(NSTimeInterval)remainingTime
{
    NSInteger seconds = remainingTime;
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",seconds/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    [self setTitleLaText:format_time];
}

#pragma mark - 计时器赋值
- (void)setTitleLaText:(NSString *)text
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        dispatch_async(dispatch_get_main_queue(),^{
            // 赋值
            self.timeLab.text = text;
        });
    });
}

#pragma mark - 签到结束 （签到剩余倒计时结束后回调）
- (void)stopSign
{
    // 隐藏弹窗
    [self disMissContentView];
}

#pragma mark - 点击签到
- (void)applyBtnAction:(UIButton *)sender
{
    // 防重复点击
    sender.userInteractionEnabled = NO;
    
    __weak typeof(self) weakSelf = self;
    [self.vhSign signSuccessIsStop:YES success:^{
        // 解开限制
        sender.userInteractionEnabled = YES;
        // 隐藏弹窗
        [weakSelf disMissContentView];
        // 提示文案
        [VHProgressHud showToast:@"签到成功"];
    } failed:^(NSDictionary *failedData) {
        // 解开限制
        sender.userInteractionEnabled = YES;
        // 提示文案
        NSString * msg = [NSString stringWithFormat:@"%@",failedData[@"content"]];
        [VHProgressHud showToast:msg];
    }];

}

#pragma mark - 懒加载
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"主持人发起了签到";
        _titleLab.textColor = [UIColor colorWithHex:@"#1A1A1A"];
        _titleLab.font = FONT(14);
    }
    return _titleLab;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = [UIColor colorWithHex:@"#1A1A1A"];
        _timeLab.font = FONT_Blod(25);
    }
    return _timeLab;
}

- (UIButton *)applyBtn {
    if (!_applyBtn) {
        _applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _applyBtn.backgroundColor = [UIColor colorWithHex:@"#FB2626"];
        _applyBtn.titleLabel.font = FONT(16);
        _applyBtn.layer.cornerRadius = 45/2;
        [_applyBtn setTitle:@"立即签到" forState:UIControlStateNormal];
        [_applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_applyBtn addTarget:self action:@selector(applyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn addTarget:self action:@selector(disMissContentView) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setImage:[UIImage imageNamed:@"vh_close_alert"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

@end
