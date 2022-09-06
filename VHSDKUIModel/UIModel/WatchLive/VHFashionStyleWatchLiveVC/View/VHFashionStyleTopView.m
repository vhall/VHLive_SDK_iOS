//
//  VHFashionStyleTopView.m
//  UIModel
//
//  Created by 郭超 on 2022/7/21.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHFashionStyleTopView.h"

@interface VHFashionStyleTopView ()

/// 用户View
@property (nonatomic, strong) UIView * userView;
/// 头像
@property (nonatomic, strong) UIImageView * headImg;
/// 昵称
@property (nonatomic, strong) UILabel * nickNameLab;
/// 在线人数
@property (nonatomic, strong) UILabel * onlineLab;
@property (nonatomic, strong) UIImageView * onlineImg;
@property (nonatomic, assign) NSInteger  all_update_online_num;
/// 热度
@property (nonatomic, strong) UILabel * heatLab;
@property (nonatomic, strong) UIImageView * heatImg;
/// toolView
@property (nonatomic, strong) UIView * toolView;
/// 摄像头切换按钮
@property (nonatomic, strong) UIButton *swapBtn;
/// 摄像头开关按钮
@property (nonatomic, strong) UIButton *cameraBtn;
/// 麦克风按钮
@property (nonatomic, strong) UIButton *micBtn;

/// 本地视频view
@property (nonatomic, strong) VHLocalRenderView * localRenderView;

@end

@implementation VHFashionStyleTopView

- (instancetype)init
{
    if ([super init]) {
        
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
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(34);
    }];
    
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(4);
        make.centerY.mas_equalTo(_userView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    [self.nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImg.mas_right).offset(6);
        make.top.mas_equalTo(_headImg.mas_top);
    }];
    
    [self.onlineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImg.mas_right).offset(6);
        make.bottom.mas_equalTo(_headImg.mas_bottom).offset(-2);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    [self.onlineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_onlineImg.mas_right).offset(2);
        make.bottom.mas_equalTo(_headImg.mas_bottom);
    }];
    
    [self.heatImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_onlineLab.mas_right).offset(4);
        make.bottom.mas_equalTo(_headImg.mas_bottom).offset(-2);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    [self.heatLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_heatImg.mas_right).offset(2);
        make.bottom.mas_equalTo(_headImg.mas_bottom);
    }];
    
    [self.userView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_greaterThanOrEqualTo(_nickNameLab.mas_right).offset(10).priorityHigh();
        make.right.mas_greaterThanOrEqualTo(_heatLab.mas_right).offset(10).priorityHigh();
    }];
    
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(34*3 + 12*4, 34));
    }];

    [self.swapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(_toolView);
        make.size.mas_equalTo(CGSizeMake(34, 34));
    }];

    [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_swapBtn.mas_right).offset(12);
        make.centerY.mas_equalTo(_toolView);
        make.size.mas_equalTo(CGSizeMake(34, 34));
    }];

    [self.micBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_cameraBtn.mas_right).offset(12);
        make.centerY.mas_equalTo(_toolView);
        make.size.mas_equalTo(CGSizeMake(34, 34));
    }];

}
- (void)layoutSubviews
{
    [super layoutSubviews];
}
#pragma mark - 数据赋值
- (void)setWebinarInfo:(VHWebinarInfo *)webinarInfo
{
    _webinarInfo = webinarInfo;
    
    [_headImg sd_setImageWithURL:[NSURL URLWithString:webinarInfo.author_avatar] placeholderImage:[UIImage new]];
    
    NSString * nickName = webinarInfo.author_nickname;
    if (nickName.length > 8) {
        nickName = [NSString stringWithFormat:@"%@...",[webinarInfo.author_nickname substringToIndex:8]];
    }
    _nickNameLab.text = nickName;
    
    self.all_update_online_num = self.all_update_online_num + webinarInfo.online_virtual;
    
    NSInteger olNum = [_onlineLab.text integerValue]+webinarInfo.online_real+webinarInfo.online_virtual;
    
    _onlineLab.text = olNum > 999 ? @"999+" : [NSString stringWithFormat:@"%ld",olNum];

    NSInteger heatNum = [_heatLab.text integerValue]+webinarInfo.pv_real+webinarInfo.pv_virtual;
    
    _heatLab.text = heatNum > 999 ? @"999+" : [NSString stringWithFormat:@"%ld",heatNum];

    _onlineImg.hidden = !webinarInfo.online_show;
    _onlineLab.hidden = !webinarInfo.online_show;

    _heatImg.hidden = !webinarInfo.pv_show;
    _heatLab.hidden = !webinarInfo.pv_show;
    
    if (webinarInfo.online_show) {
        [_heatImg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_onlineLab.mas_right).offset(4);
            make.bottom.mas_equalTo(_headImg.mas_bottom).offset(-2);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
    }else{
        [_heatImg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImg.mas_right).offset(6);
            make.bottom.mas_equalTo(_headImg.mas_bottom).offset(-2);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
    }
}
#pragma mark - 开启互动
- (void)watchLiveChangeInteract:(BOOL)isChange localRenderView:(VHLocalRenderView *)localRenderView
{
    self.localRenderView = localRenderView;
    self.toolView.hidden = !isChange;
}
#pragma mark - 收到虚拟人数消息
- (void)vhBaseNumUpdateToUpdate_online_num:(NSInteger)update_online_num
                                 update_pv:(NSInteger)update_pv
{
    self.all_update_online_num = self.all_update_online_num + update_online_num;

    NSInteger olNum = [_onlineLab.text integerValue] + update_online_num;
    
    _onlineLab.text = olNum > 999 ? @"999+" : [NSString stringWithFormat:@"%ld",olNum];
    
    NSInteger heatNum = [_heatLab.text integerValue] + update_pv;
    
    _heatLab.text = heatNum > 999 ? @"999+" : [NSString stringWithFormat:@"%ld",heatNum];
}
#pragma mark - 收到上下线消息
- (void)reciveOnlineMsg:(NSArray <VHallOnlineStateModel *> *)msgs
{
    for (VHallOnlineStateModel * m in msgs) {
        
        NSInteger olNum = [m.concurrent_user integerValue] + self.all_update_online_num;

        _onlineLab.text = olNum > 999 ? @"999+" : [NSString stringWithFormat:@"%ld",olNum];

        NSInteger heatNum = [_heatLab.text integerValue] + ([m.event isEqualToString:@"online"] ? 1 : 0);

        _heatLab.text = heatNum > 999 ? @"999+" : [NSString stringWithFormat:@"%ld",heatNum];
    }
}
#pragma mark - -------------------按钮点击事件--------------------
#pragma mark - 摄像头切换
- (void)swapStatusChanged:(UIButton *)sender {
    _localRenderView.hidden = YES;
    AVCaptureDevicePosition position = [_localRenderView switchCamera];
    _localRenderView.transform = CGAffineTransformMakeScale((position == AVCaptureDevicePositionFront)?-1:1,1);//镜像
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _localRenderView.hidden = NO;
    });
}
#pragma mark - 麦克风按钮事件
- (void)micBtnStatusChanged:(UIButton *)sender {
    //麦克风按钮图标变更
    sender.selected = !sender.selected;
    //麦克风操作
    (sender.selected) ? [_localRenderView muteAudio] : [_localRenderView unmuteAudio];
}
#pragma mark - 摄像头按钮事件
- (void)videoStatusChanged:(UIButton *)sender {
    //麦克风按钮图标变更
    sender.selected = !sender.selected;
    //摄像头操作
    (sender.selected) ? [_localRenderView muteVideo] : [_localRenderView unmuteVideo];
}
#pragma mark - 自己的麦克风开关状态改变回调
- (void)room:(VHRoom *)room microphoneClosed:(BOOL)isClose
{
    _micBtn.selected = isClose;
}
#pragma mark - 自己的摄像头开关状态改变回调
- (void)room:(VHRoom *)room screenClosed:(BOOL)isClose
{
    _cameraBtn.selected = isClose;
}

#pragma mark - 懒加载
- (UIView *)userView
{
    if (!_userView) {
        _userView = [UIView new];
        _userView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.3];
        _userView.layer.masksToBounds = YES;
        _userView.layer.cornerRadius = 34/2;
        [self addSubview:_userView];
    }return _userView;
}

- (UIImageView *)headImg
{
    if (!_headImg) {
        _headImg = [UIImageView new];
        _headImg.layer.masksToBounds = YES;
        _headImg.layer.cornerRadius = 28/2;
        [self.userView addSubview:_headImg];
    }return _headImg;
}

- (UILabel *)nickNameLab
{
    if (!_nickNameLab) {
        _nickNameLab = [UILabel new];
        _nickNameLab.font = FONT_FZZZ(12);
        _nickNameLab.textColor = [UIColor whiteColor];
        [self.userView addSubview:_nickNameLab];
    }return _nickNameLab;
}

- (UILabel *)onlineLab
{
    if (!_onlineLab) {
        _onlineLab = [UILabel new];
        _onlineLab.hidden = YES;
        _onlineLab.font = FONT_FZZZ(10);
        _onlineLab.text = @"1";
        _onlineLab.textColor = [UIColor colorWithHex:@"#CECED1"];
        [self.userView addSubview:_onlineLab];
    }return _onlineLab;
}

- (UIImageView *)onlineImg
{
    if (!_onlineImg) {
        _onlineImg = [UIImageView new];
        _onlineImg.hidden = YES;
        _onlineImg.image = BundleUIImage(@"vh_fs_online_btn");
        [self.userView addSubview:_onlineImg];
    }return _onlineImg;
}

- (UILabel *)heatLab
{
    if (!_heatLab) {
        _heatLab = [UILabel new];
        _heatLab.hidden = YES;
        _heatLab.font = FONT_FZZZ(10);
        _heatLab.text = @"1";
        _heatLab.textColor = [UIColor colorWithHex:@"#CECED1"];
        [self.userView addSubview:_heatLab];
    }return _heatLab;
}

- (UIImageView *)heatImg
{
    if (!_heatImg) {
        _heatImg = [UIImageView new];
        _heatImg.hidden = YES;
        _heatImg.image = BundleUIImage(@"vh_fs_heat_btn");
        [self.userView addSubview:_heatImg];
    }return _heatImg;
}

- (UIView *)toolView
{
    if (!_toolView) {
        _toolView = [UIView new];
        _toolView.hidden = YES;
        [self addSubview:_toolView];
    }return _toolView;
}

- (UIButton *)swapBtn
{
    if (!_swapBtn) {
        _swapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_swapBtn setBackgroundImage:BundleUIImage(@"icon_video_camera_switching") forState:UIControlStateNormal];
        [_swapBtn setBackgroundImage:BundleUIImage(@"icon_video_camera_switching") forState:UIControlStateSelected];
        [_swapBtn addTarget:self action:@selector(swapStatusChanged:) forControlEvents:UIControlEventTouchUpInside];
        [self.toolView addSubview:_swapBtn];
    }return _swapBtn;
}

- (UIButton *)cameraBtn
{
    if (!_cameraBtn) {
        _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraBtn setBackgroundImage:BundleUIImage(@"icon_video_open_camera") forState:UIControlStateNormal];
        [_cameraBtn setBackgroundImage:BundleUIImage(@"icon_video_close_camera") forState:UIControlStateSelected];
        [_cameraBtn addTarget:self action:@selector(videoStatusChanged:) forControlEvents:UIControlEventTouchUpInside];
        [self.toolView addSubview:_cameraBtn];
    }return _cameraBtn;
}

- (UIButton *)micBtn
{
    if (!_micBtn) {
        _micBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_micBtn setBackgroundImage:BundleUIImage(@"icon_video_open_microphone") forState:UIControlStateNormal];
        [_micBtn setBackgroundImage:BundleUIImage(@"icon_video_close_microphone") forState:UIControlStateSelected];
        [_micBtn addTarget:self action:@selector(micBtnStatusChanged:) forControlEvents:UIControlEventTouchUpInside];
        [self.toolView addSubview:_micBtn];
    }return _micBtn;
}

@end
