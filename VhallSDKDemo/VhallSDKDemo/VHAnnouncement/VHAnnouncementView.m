//
//  VHAnnouncementView.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/19.
//

#import "TXScrollLabelView.h"
#import "VHAnnouncementView.h"
#import "VHTimer.h"

@interface VHAnnouncementView ()
/// icon
@property (nonatomic, strong) UIImageView *anIcon;
/// 关闭
@property (nonatomic, strong) UIButton *closeBtn;
/// 详情
@property (nonatomic, strong) TXScrollLabelView *contentLabel;
/// 计时器
@property (nonatomic, strong) VHTimer *vhTimer;

@end

@implementation VHAnnouncementView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor bm_colorGradientChangeWithSize:frame.size direction:IHGradientChangeDirectionLevel startColor:[UIColor colorWithHex:@"#FDF1ED"] endColor:[UIColor colorWithHex:@"#F3F2FF"]];

        [self addSubview:self.contentLabel];
        [self.contentLabel setFrame:CGRectMake(35, 0, frame.size.width - 35 * 2, frame.size.height)];

        [self addSubview:self.anIcon];
        [self.anIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];

        [self addSubview:self.closeBtn];
        [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
    }

    return self;
}

// 动画
- (void)startAnimationWithContent:(NSString *)content pushTime:(NSString *)pushTime duration:(NSInteger)duration view:(UIView *)view isFull:(BOOL)isFull
{
    // 先结束上次的跑马灯和计时器
    [self endAnimation];

    // 如果 duration == 0 则不限制时长
    if (duration != 0) {
        // 先计算时间差多少秒
        NSInteger timeinterval = [VUITool getTimeDifferenceWithTime:pushTime] + duration;

        // 如果已经过期则不展示
        if (timeinterval <= 0) {
            return;
        }

        // 开始计时器
        [self startTimer:timeinterval];
    }

    // 处理UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setHidden:isFull ? isFull : NO];
        [view addSubview:self];
    });

    // 赋值跑马灯内容
    [self.contentLabel setScrollTitle:content];

    // 开始跑马灯
    [self.contentLabel beginScrolling];
}

// 会结束动画，使finished变量返回Null
- (void)endAnimation
{
    [self.vhTimer stop];

    [self.contentLabel endScrolling];

    // 主线程刷新ui
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setHidden:YES];
        [self removeFromSuperview];
    });
}

#pragma mark - 开始计时器
- (void)startTimer:(NSInteger)timeinterval
{
    __weak __typeof(self) weakSelf = self;
    self.vhTimer = [[VHTimer alloc] initWithStartTimeinterval:timeinterval
                                                     isAscend:NO
                                                progressBlock:^(VHTime *progress) {
    }
                                              completionBlock:^{
        [weakSelf endAnimation];
    }];
    [self.vhTimer resume];
}

#pragma mark - 懒加载

- (TXScrollLabelView *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [TXScrollLabelView scrollWithTitle:@"" type:TXScrollLabelViewTypeLeftRight velocity:.5 options:UIViewAnimationOptionCurveLinear];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.font = FONT(14);
        _contentLabel.scrollTitleColor = [UIColor colorWithHex:@"#262626"];
        _contentLabel.autoWidth = YES;
    }

    return _contentLabel;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn addTarget:self action:@selector(endAnimation) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setImage:[UIImage imageNamed:@"vh_close_alert"] forState:UIControlStateNormal];
    }

    return _closeBtn;
}

- (UIImageView *)anIcon
{
    if (!_anIcon) {
        _anIcon = [[UIImageView alloc] init];
        _anIcon.image = [UIImage imageNamed:@"vh_announcement_icon"];
    }

    return _anIcon;
}

@end
