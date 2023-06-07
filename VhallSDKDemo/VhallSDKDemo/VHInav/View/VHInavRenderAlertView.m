//
//  VHInavRenderAlertView.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/20.
//

#import "VHInavBtn.h"
#import "VHInavRenderAlertView.h"

@interface VHInavRenderAlertView ()

/// 摄像头
@property (nonatomic, strong) VHInavBtn *cameraBtn;
/// 麦克风
@property (nonatomic, strong) VHInavBtn *micBtn;
/// 摄像头翻转
@property (nonatomic, strong) VHInavBtn *overturnBtn;
/// 下麦
@property (nonatomic, strong) VHInavBtn *unApplyBtn;

/// 摄像头状态
@property (nonatomic, assign) BOOL cameraStatus;
/// 麦克风状态
@property (nonatomic, assign) BOOL micStatus;

@end

@implementation VHInavRenderAlertView


- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];

        [self addSubview:self.contentView];
        [self.contentView addSubview:self.cameraBtn];
        [self.contentView addSubview:self.micBtn];
        [self.contentView addSubview:self.overturnBtn];
        [self.contentView addSubview:self.unApplyBtn];

        // 初始化布局
        [self setUpMasonry];
        
        // 绑定自动化标识
        [self initKIF];
    }

    return self;
}

#pragma mark - 初始化布局
- (void)setUpMasonry
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(123);
    }];

    NSArray *array = @[self.cameraBtn, self.micBtn, self.overturnBtn, self.unApplyBtn];
    [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:50 leadSpacing:20 tailSpacing:20];
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(self.contentView.mas_height);
    }];
}

#pragma mark - 绑定自动化标识
- (void)initKIF
{
    self.cameraBtn.accessibilityLabel = VHTests_Inav_CameraBtn;
    self.micBtn.accessibilityLabel = VHTests_Inav_MicBtn;
    self.overturnBtn.accessibilityLabel = VHTests_Inav_OverturnBtn;
    self.unApplyBtn.accessibilityLabel = VHTests_Inav_UnApplyBtn;
}

#pragma mark - 显示并传递当前摄像头 麦克风状态
- (void)showCameraStatus:(BOOL)cameraStatus micStatus:(BOOL)micStatus isShow:(BOOL)isShow
{
    if (isShow) {
        [self show];
    }

    self.cameraStatus = cameraStatus;
    self.micStatus = micStatus;

    self.cameraBtn.icon.image = [UIImage imageNamed:cameraStatus ? @"vh_inav_camera" : @"vh_inav_camera_un"];
    self.micBtn.icon.image = [UIImage imageNamed:micStatus ? @"vh_inav_mic" : @"vh_inav_mic_un"];
}

#pragma mark - 操作摄像头
- (void)cameraBtnAction
{
    if (self.cameraAction) {
        self.cameraAction(self.cameraStatus);
    }

    [self disMissContentView];
}

#pragma mark - 操作麦克风
- (void)micBtnAction
{
    if (self.micAction) {
        self.micAction(self.micStatus);
    }

    [self disMissContentView];
}

#pragma mark - 操作摄像头翻转
- (void)overturnBtnAction
{
    if (self.overturnAction) {
        self.overturnAction();
    }
}

#pragma mark - 操作下麦
- (void)unApplyBtnAction
{
    if (self.unApplyAction) {
        self.unApplyAction();
    }

    [self disMissContentView];
}

#pragma mark - 点击取消
- (void)cancelBtnAction
{
    [self disMissContentView];
}

#pragma mark - 懒加载

- (VHInavBtn *)cameraBtn {
    if (!_cameraBtn) {
        _cameraBtn = [[VHInavBtn alloc] init];
        _cameraBtn.titleLab.text = @"摄像头";
        [_cameraBtn addTarget:self action:@selector(cameraBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }

    return _cameraBtn;
}

- (VHInavBtn *)micBtn {
    if (!_micBtn) {
        _micBtn = [[VHInavBtn alloc] init];
        _micBtn.titleLab.text = @"麦克风";
        [_micBtn addTarget:self action:@selector(micBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }

    return _micBtn;
}

- (VHInavBtn *)overturnBtn {
    if (!_overturnBtn) {
        _overturnBtn = [[VHInavBtn alloc] init];
        _overturnBtn.icon.image = [UIImage imageNamed:@"vh_ flip_cmera"];
        _overturnBtn.titleLab.text = @"翻转";
        [_overturnBtn addTarget:self action:@selector(overturnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }

    return _overturnBtn;
}

- (VHInavBtn *)unApplyBtn {
    if (!_unApplyBtn) {
        _unApplyBtn = [[VHInavBtn alloc] init];
        _unApplyBtn.icon.image = [UIImage imageNamed:@"vh_unapply_icon"];
        _unApplyBtn.titleLab.text = @"下麦";
        [_unApplyBtn addTarget:self action:@selector(unApplyBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }

    return _unApplyBtn;
}

@end
