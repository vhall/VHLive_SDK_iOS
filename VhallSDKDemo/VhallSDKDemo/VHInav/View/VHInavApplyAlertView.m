//
//  VHInavApplyAlertView.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/20.
//

#import "VHBaseViewController.h"
#import "VHInavApplyAlertView.h"
#import "VHInavBtn.h"
#import "VHTimer.h"

@interface VHInavApplyAlertView ()

/// 申请
@property (nonatomic, strong) VHInavBtn *applyBtn;

/// 取消
@property (nonatomic, strong) UIButton *cancelBtn;

/// 计时器
@property (nonatomic, strong) VHTimer *vhTimer;
@end

@implementation VHInavApplyAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];

        [self addSubview:self.contentView];
        [self.contentView addSubview:self.applyBtn];
        [self.contentView addSubview:self.cancelBtn];

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
        make.height.mas_equalTo(163);
    }];

    [_applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(self.contentView.mas_width);
        make.height.mas_equalTo(100);
    }];

    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-30);
        make.width.mas_equalTo(self.contentView.mas_width);
        make.height.mas_equalTo(22.5);
    }];
}

#pragma mark - 申请连麦
- (void)applyBtnAction:(UIButton *)sender
{
    // 判断权限
    __weak __typeof(self) weakSelf = self;
    [VUITool getMediaAccess:^(BOOL videoAccess, BOOL audioAcess) {
        if (videoAccess && audioAcess) {
            // 防重复点击
            sender.userInteractionEnabled = NO;

            __weak __typeof(self) sonSelf = weakSelf;
            [self.moviePlayer microApplyWithType:1
                                          finish:^(NSError *error) {
                if (error) {
            // 解开限制
                    sender.userInteractionEnabled = YES;
                    NSString *msg = [NSString stringWithFormat:@"申请上麦失败：%@", error.localizedDescription];
                    [VHProgressHud showToast:msg];
                } else {
                    [VHProgressHud showToast:@"申请上麦成功"];
            //开启上麦倒计时
                    [sonSelf startTimer];

            // 返回代理
                    if ([sonSelf.delegate respondsToSelector:@selector(applyInavSuccessful)]) {
                        [sonSelf.delegate applyInavSuccessful];
                    }
                }
            }];
        } else {
            [VHProgressHud showToast:@"请开启麦克风和摄像头权限"];
            [weakSelf disMissContentView];
        }
    }];
}

#pragma mark - 点击取消
- (void)cancelBtnAction:(UIButton *)sender
{
    // 防重复点击
    sender.userInteractionEnabled = NO;

    // 隐藏
    [self disMissContentView];
}

#pragma mark - 开始计时器
- (void)startTimer
{
    __weak __typeof(self) weakSelf = self;
    self.vhTimer = [[VHTimer alloc] initWithStartTimeinterval:30
                                                     isAscend:NO
                                                progressBlock:^(VHTime *progress) {
        [weakSelf setTitleLaText:[NSString stringWithFormat:@"等待中...（%ds）", progress.residueSecond]];
    }
                                              completionBlock:^{
        // 重置文案
        [weakSelf setTitleLaText:@"申请上麦"];
    }];
    [self.vhTimer resume];
}

#pragma mark - 计时器赋值
- (void)setTitleLaText:(NSString *)text
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([text isEqualToString:@"申请上麦"]) {
                // 解开限制
                self.applyBtn.userInteractionEnabled = YES;
            }

            // 赋值
            self.applyBtn.titleLab.text = text;
        });
    });
}

#pragma mark - 结束倒计时
- (void)stopTimer
{
    [self.vhTimer stop];
    // 重置文案
    [self setTitleLaText:@"申请上麦"];
}

#pragma mark - 停止并收起弹窗
- (void)stopOrDismiss
{
    //停止倒计时
    [self stopTimer];
    [self disMissContentView];
}

#pragma mark - 懒加载

- (VHInavBtn *)applyBtn {
    if (!_applyBtn) {
        _applyBtn = [[VHInavBtn alloc] init];
        _applyBtn.icon.image = [UIImage imageNamed:@"vh_apply_icon"];
        _applyBtn.titleLab.text = @"申请上麦";
        [_applyBtn addTarget:self action:@selector(applyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _applyBtn;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.titleLabel.font = FONT(16);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithHex:@"#595959"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _cancelBtn;
}

@end
