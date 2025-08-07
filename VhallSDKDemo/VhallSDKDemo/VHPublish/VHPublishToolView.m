//
//  VHPublishToolView.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/4/17.
//

#import "VHPublishToolView.h"

@interface VHPublishToolView ()

/// 镜像

/// 镜像
@property (nonatomic, strong) UIButton *beautyBtn;
/// 镜像
@property (nonatomic, strong) UIButton *mirrorBtn;
/// 前后置
@property (nonatomic, strong) UIButton *cameraBtn;
/// 音频
@property (nonatomic, strong) UIButton *micBtn;
/// 播放按钮
@property (nonatomic, strong) UIButton *playBtn;

@end

@implementation VHPublishToolView

- (instancetype)init
{
    if ([super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.2];

        [self.kbpsLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];

        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        [self.micBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.playBtn.mas_left).offset(-15);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.micBtn.mas_left).offset(-15);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        [self.mirrorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.cameraBtn.mas_left).offset(-15);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        [self.beautyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mirrorBtn.mas_left).offset(-15);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
         [self.cameraCaptureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
             make.right.mas_equalTo(self.beautyBtn.mas_left).offset(-15);
             make.centerY.mas_equalTo(self.mas_centerY);
             make.size.mas_equalTo(CGSizeMake(30, 30));
         }];
    }

    return self;
}
#pragma mark - 点击美颜
- (void)beautyBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (self.clickOpenBeauty) {
        self.clickOpenBeauty(sender.selected);
    }
}

#pragma mark - 摄像头开关
- (void)cameraCaptureBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (self.clickCameraCapture) {
        self.clickCameraCapture(sender.selected);
    }
}

#pragma mark - 点击镜像
- (void)mirrorBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (self.clickMirror) {
        self.clickMirror(sender.selected);
    }
}
#pragma mark - 点击摄像头
- (void)cameraBtnAction:(UIButton *)sender
{
    if (self.clickCamera) {
        self.clickCamera(sender.selected);
    }
}

#pragma mark - 点击麦克风
- (void)micBtnAction:(UIButton *)sender
{
    if (self.clickMic) {
        self.clickMic(sender.selected);
    }

    sender.selected = !sender.selected;
}

#pragma mark - 点击播放按钮
- (void)playBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;

    if (self.clickPlay) {
        self.clickPlay(sender.selected);
    }
}

#pragma mark - 懒加载
- (UILabel *)kbpsLab {
    if (!_kbpsLab) {
        _kbpsLab = [[UILabel alloc] init];
        _kbpsLab.textColor = [UIColor whiteColor];
        _kbpsLab.font = FONT_Light(13);
        [self addSubview:_kbpsLab];
    }

    return _kbpsLab;
}

- (UIButton *)beautyBtn {
    if (!_beautyBtn) {
        _beautyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_beautyBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [_beautyBtn setImage:[UIImage imageNamed:@"ruddy_select"] forState:UIControlStateNormal];
        [_beautyBtn addTarget:self action:@selector(beautyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_beautyBtn];
    }

    return _beautyBtn;
}



- (UIButton *)cameraCaptureBtn {
    if (!_cameraCaptureBtn) {
         _cameraCaptureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraCaptureBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [_cameraCaptureBtn setImage:[UIImage imageNamed:@"live_topTool_video_on"] forState:UIControlStateNormal];
        [_cameraCaptureBtn addTarget:self action:@selector(cameraCaptureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cameraCaptureBtn];
    }

    return _cameraCaptureBtn;
}

- (UIButton *)mirrorBtn {
    if (!_mirrorBtn) {
        _mirrorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mirrorBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [_mirrorBtn setImage:[UIImage imageNamed:@"vh_crame_mirror"] forState:UIControlStateNormal];
        [_mirrorBtn addTarget:self action:@selector(mirrorBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_mirrorBtn];
    }

    return _mirrorBtn;
}

- (UIButton *)cameraBtn {
    if (!_cameraBtn) {
        _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [_cameraBtn setImage:[UIImage imageNamed:@"vh_publish_crame"] forState:UIControlStateNormal];
        [_cameraBtn addTarget:self action:@selector(cameraBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cameraBtn];
    }

    return _cameraBtn;
}

- (UIButton *)micBtn {
    if (!_micBtn) {
        _micBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _micBtn.selected = YES;
        [_micBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [_micBtn setImage:[UIImage imageNamed:@"vh_publish_micoff"] forState:UIControlStateNormal];
        [_micBtn setImage:[UIImage imageNamed:@"vh_publish_micon"] forState:UIControlStateSelected];
        [_micBtn addTarget:self action:@selector(micBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_micBtn];
    }

    return _micBtn;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.selected = YES;
        [_playBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [_playBtn setImage:[UIImage imageNamed:@"vh_publish_play"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"vh_publish_pause"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(playBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playBtn];
    }

    return _playBtn;
}

@end
