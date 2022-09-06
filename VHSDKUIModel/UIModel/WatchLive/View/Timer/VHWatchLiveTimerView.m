//
//  VHWatchLiveTimerView.m
//  UIModel
//
//  Created by 郭超 on 2022/7/22.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHWatchLiveTimerView.h"
#import "VHWatchLiveTimerImg.h"
#import "VHLiveWeakTimer.h"
#import "OMTimer.h"

@interface VHWatchLiveTimerView ()

/// 容器
@property (nonatomic, strong) UIView * contentView;
/// 标题
@property (nonatomic, strong) UILabel * titleLab;
/// 关闭按钮
@property (nonatomic, strong) UIButton * closeBtn;

/// 计时器view
@property (nonatomic, strong) UIView * timerView;

/// 分钟
@property (nonatomic, strong) VHWatchLiveTimerImg * minute1;
/// 分钟
@property (nonatomic, strong) VHWatchLiveTimerImg * minute2;
/// 秒
@property (nonatomic, strong) VHWatchLiveTimerImg * second1;
/// 秒
@property (nonatomic, strong) VHWatchLiveTimerImg * second2;

/// 分割线
@property (nonatomic, strong) UIView * lineView;

/// 计时器
@property (nonatomic, strong) OMTimer * timer;

/// 记录时间
@property (nonatomic, assign) NSInteger  duration;
/// 当前时间
@property (nonatomic, assign) NSInteger  currentTime;
/// 是否可以超时
@property (nonatomic, assign) BOOL  is_timeout;

@end

@implementation VHWatchLiveTimerView

- (instancetype)init
{
    if ([super init]) {
        
        self.alpha = 0;

        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(isHiddenView)];
        [self addGestureRecognizer:tap];

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
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(272, 150));
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];

    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(_closeBtn.mas_left).offset(-10);
        make.centerY.mas_equalTo(_closeBtn.mas_centerY);
    }];
    
    [self.timerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(-16);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(78);
    }];
    
    [self.minute1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.centerY.mas_equalTo(_timerView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 62));
    }];
    
    [self.minute2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_minute1.mas_right).offset(4);
        make.centerY.mas_equalTo(_timerView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 62));
    }];
    
    [self.second1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_minute2.mas_right).offset(4);
        make.centerY.mas_equalTo(_timerView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 62));
    }];
    
    [self.second2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_second1.mas_right).offset(4);
        make.centerY.mas_equalTo(_timerView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 62));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(8);
        make.centerY.mas_equalTo(_timerView.mas_centerY);
        make.height.mas_equalTo(2);
    }];
}

#pragma mark - 显示
- (void)showTimerView:(NSInteger)duration is_timeout:(BOOL)is_timeout
{
    self.is_timeout = is_timeout;
    
    self.duration = duration;
    
    self.currentTime = 0;

    [self initTimerToIsAscend:is_timeout hasTimeout:NO duration:self.duration currentTime:self.currentTime];
    
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {

    }];
}

#pragma mark - 隐藏
- (void)dismiss
{
    [_timer stop];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - 计时器显示
- (void)isShowView
{
    self.alpha = 1;
}
#pragma mark - 计时器隐藏
- (void)isHiddenView
{
    self.alpha = 0;
}

#pragma mark - 暂停
- (void)timerPause
{
    // 提示文案
    self.titleLab.text = @"已暂停";
    self.titleLab.textColor = [UIColor colorWithHex:@"#FC9600"];

    [_timer suspend];
}

#pragma mark - 恢复
- (void)timerResume:(NSInteger)duration is_timeout:(BOOL)is_timeout
{
    self.is_timeout = is_timeout;
    
    BOOL hasTimeout = duration < 0 ? YES : NO;

    self.duration = hasTimeout ? 3599 : duration;

    self.currentTime = hasTimeout ? labs(duration) : 0;

    [self initTimerToIsAscend:self.is_timeout hasTimeout:hasTimeout duration:self.duration currentTime:self.currentTime];
    
    self.alpha = 1;
}

#pragma mark - 初始化计时器
- (void)initTimerToIsAscend:(BOOL)isAscend hasTimeout:(BOOL)hasTimeout duration:(NSInteger)duration currentTime:(NSInteger)currentTime
{
    [_timer stop];
    
    _timer = [[OMTimer alloc] init];
    _timer.timerInterval = duration;
    _timer.currentTime = currentTime;
    _timer.isAscend = isAscend && hasTimeout; // 允许超时 并且 已经超时
    _timer.precision = 1000;
    @weakify(self);
    _timer.progressBlock = ^(OMTime *progress) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            // 计时器显示
            [self startCountdownProgress:progress hasTimeout:hasTimeout];
            // 提示文案
            if (hasTimeout) {
                self.titleLab.text = [NSString stringWithFormat:@"已超时，开始正向计时"];
            }else{
                self.titleLab.text = [NSString stringWithFormat:@"%ld秒 倒计时进行中...",self.duration];
            }
            self.titleLab.textColor = [UIColor colorWithHex:isAscend ? @"#FB2626" : @"#0FBB5A"];
        });
    };
    _timer.completion = ^{
        @strongify(self);
        if (!isAscend) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // 开始超时计时
            [self initTimerToIsAscend:YES hasTimeout:YES duration:3599 currentTime:0];
        });
    };
    
    // 开始计时器
    [_timer resume];
}
#pragma mark - 计时器显示
- (void)startCountdownProgress:(OMTime *)progress hasTimeout:(BOOL)hasTimeout
{
    self.minute1.string = [progress.minute substringToIndex:1];
    self.minute1.stringColor = [UIColor colorWithHex:hasTimeout ? @"#FB2626" : @"#262626"];

    self.minute2.string = [progress.minute substringFromIndex:1];
    self.minute2.stringColor = [UIColor colorWithHex:hasTimeout ? @"#FB2626" : @"#262626"];

    self.second1.string = [progress.second substringToIndex:1];
    self.second1.stringColor = [UIColor colorWithHex:hasTimeout ? @"#FB2626" : @"#262626"];

    self.second2.string = [progress.second substringFromIndex:1];
    self.second2.stringColor = [UIColor colorWithHex:hasTimeout ? @"#FB2626" : @"#262626"];

}

#pragma mark - 懒加载
- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor colorWithHex:@"#DFDFDF"];
        [self addSubview:_contentView];
    }return _contentView;
}
- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        [self.contentView addSubview:_titleLab];
    }return _titleLab;
}
- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:BundleUIImage(@"vh_an_close") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(isHiddenView) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_closeBtn];
    }return _closeBtn;
}
- (UIView *)timerView
{
    if (!_timerView) {
        _timerView = [UIView new];
        _timerView.backgroundColor = [UIColor colorWithHex:@"#D9D9D9"];
        _timerView.layer.masksToBounds = YES;
        _timerView.layer.cornerRadius = 8;
        [self.contentView addSubview:_timerView];
    }return _timerView;
}
- (VHWatchLiveTimerImg *)minute1
{
    if (!_minute1) {
        _minute1 = [VHWatchLiveTimerImg new];
        [self.timerView addSubview:_minute1];
    }return _minute1;
}
- (VHWatchLiveTimerImg *)minute2
{
    if (!_minute2) {
        _minute2 = [VHWatchLiveTimerImg new];
        [self.timerView addSubview:_minute2];
    }return _minute2;
}
- (VHWatchLiveTimerImg *)second1
{
    if (!_second1) {
        _second1 = [VHWatchLiveTimerImg new];
        [self.timerView addSubview:_second1];
    }return _second1;
}
- (VHWatchLiveTimerImg *)second2
{
    if (!_second2) {
        _second2 = [VHWatchLiveTimerImg new];
        [self.timerView addSubview:_second2];
    }return _second2;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithHex:@"#D9D9D9"];
        [self.timerView addSubview:_lineView];
    }return _lineView;
}
@end
