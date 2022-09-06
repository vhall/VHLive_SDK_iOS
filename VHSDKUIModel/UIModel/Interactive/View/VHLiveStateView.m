//
//  VHLiveStateView.m
//  UIModel
//
//  Created by leiheng on 2021/4/16.
//  Copyright © 2021 www.vhall.com. All rights reserved.
//

#import "VHLiveStateView.h"

@interface VHLiveStateView ()
/** 彩排按钮*/
@property (nonatomic, strong) UIButton * rehearsalBtn;
/** 底部开始按钮 */
@property (nonatomic, strong) UIButton *stratBtn;
/** 中间操作按钮 */
@property (nonatomic, strong) UIButton *stateActionBtn;
/** 状态描述文案 */
@property (nonatomic, strong) UILabel *stateLab;
/** 状态图片 */
@property (nonatomic, strong) UIImageView *stateImgView;
/** 中间图标、文字、按钮的父视图 */
@property (nonatomic, strong) UIView *centerView;
/** 直播状态 */
@property (nonatomic, assign) VHLiveState liveState;

@end

@implementation VHLiveStateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
        [self configFrame];
    }
    return self;
}

- (void)configUI {
    self.backgroundColor = MakeColorRGB(0x222222);
    [self addSubview:self.centerView];
    [self addSubview:self.rehearsalBtn];
    [self addSubview:self.stratBtn];
    [self.centerView addSubview:self.stateActionBtn];
    [self.centerView addSubview:self.stateLab];
    [self.centerView addSubview:self.stateImgView];
    self.userInteractionEnabled = NO;
}

- (void)configFrame {
    
    [_rehearsalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-50);
        make.centerX.equalTo(self.mas_centerX).offset(-77.5);
        make.height.equalTo(@45);
        make.width.equalTo(@(140));
    }];
    
    [_stratBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-50);
        make.centerX.equalTo(self.mas_centerX).offset(77.5);
        make.height.equalTo(@45);
        make.width.equalTo(@(140));
    }];

    [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.equalTo(_centerView);
        make.center.equalTo(self);
    }];
    
    [self.stateImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(CGSizeMake(70, 70)));
        make.centerX.top.equalTo(_centerView);
    }];
    
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stateImgView.mas_bottom).offset(13);
        make.centerX.equalTo(_centerView);
    }];
    
    [self.stateActionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_centerView);
        make.top.equalTo(self.stateLab.mas_bottom).offset(32);
        make.size.equalTo(@(CGSizeMake(180, 45)));
        make.bottom.equalTo(_centerView);
    }];
}

#pragma mark - ---渲染元素
- (void)upDateLiveState:(VHLiveState)liveState btnTitle:(NSString *)btnTitle
{
    _liveState = liveState;
    if(liveState == VHLiveState_Success || liveState == VHLiveState_RehearsalSuccess) {//直播开始
        self.hidden = YES;
    }else {
        self.hidden = NO;
        
        self.backgroundColor = [UIColor colorWithHex:@"222222"];
        
        self.centerView.hidden = NO;

        self.stratBtn.hidden = YES;
        self.rehearsalBtn.hidden = YES;

        if(liveState == VHLiveState_Prepare) { //开始直播
            self.backgroundColor = [UIColor clearColor];
            self.centerView.hidden = YES;
            self.stratBtn.hidden = NO;
            self.rehearsalBtn.hidden = NO;
            [self.stratBtn setTitle:@"开始直播" forState:UIControlStateNormal];
        }else if (liveState == VHLiveState_Stop) { //直播停止
            [self updataToStateActionTitle:btnTitle stateLabText:@"发生错误，直播已停止" stateImgStr:@"icon-网络异常"];
        }else if (liveState == VHLiveState_Forbid) { //直播被封禁
            [self updataToStateActionTitle:btnTitle stateLabText:@"当前直播涉及违规，已关闭直播间" stateImgStr:@"icon-警示"];
        }else if (liveState == VHLiveState_NetError) { //网络错误
            [self updataToStateActionTitle:btnTitle stateLabText:@"网络被外星人切走了～" stateImgStr:@"icon-网络异常"];
        }
    }
    
    // 视频直播才显示彩排按钮
    if (self.liveVideoType != VHLiveVideoNormal) {
        self.rehearsalBtn.hidden = YES;
    }
}
- (void)updataToStateActionTitle:(NSString *)stateActionTitle stateLabText:(NSString *)stateLabText stateImgStr:(NSString *)stateImgStr
{
    [self.stateActionBtn setTitle:stateActionTitle forState:UIControlStateNormal];
    [self.stateLab setText:stateLabText];
    [self.stateImgView setImage:[UIImage imageNamed:stateImgStr]];
}
#pragma mark - ---云导播新增UI
- (void)cloudBoardCastStatus:(VideoBoardCastType)boardType btnTitle:(NSString *)btnTitle{
    
    self.backgroundColor = [UIColor clearColor];
    self.hidden = NO;
    self.centerView.hidden = YES;
    self.stateActionBtn.hidden = YES;
    self.stratBtn.hidden = YES;
    self.stratBtn.enabled = YES;
    self.stratBtn.alpha = 1.0;
    [self.stratBtn setTitle:@"开始直播" forState:UIControlStateNormal];
    [self.stateImgView setImage:[UIImage imageNamed:@"warning-outline"]];

    switch (boardType) {
        case VideoBoardCastType_Normal:{
            // 普通视频直播
            self.stratBtn.hidden = NO;
        }
            break;
        case VideoBoardCastType_CloudBrocastPush:{
            // 云导播纯推流
            
        }
            break;
        case VideoBoardCastType_LiveBeforePullFailed:{
            // 云导播主持人进入直播前拉流失败
            self.backgroundColor = [UIColor colorWithHex:@"222222"];
            self.centerView.hidden = NO;
            self.stratBtn.alpha = 0.3;
            self.stratBtn.hidden = NO;
            self.stratBtn.enabled = NO;
            self.stateLab.text = @"未检测到云导播推流";
        }
            break;
        case VideoBoardCastType_LivingPullFailed:{
            
            // 云导播主持人进入直播中拉流异常
            self.backgroundColor = [UIColor colorWithHex:@"222222"];
            self.centerView.hidden = NO;
        }
            break;
        case VideoBoardCastType_LivingPullSucceed:{
            self.backgroundColor = [UIColor clearColor];
            self.hidden = YES;
        }
            break;
        case VideoBoardCastType_start:{
            
        }
            break;
        default:
            break;
    }
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if(self.hidden == YES) {
       return [super hitTest:point withEvent:event];
    }
    
    CGPoint rehearsalBtnPoint = [self convertPoint:point toView:self.rehearsalBtn];
    if (self.rehearsalBtn.hidden == NO && [self.rehearsalBtn pointInside:rehearsalBtnPoint withEvent:event]) {
        return [self.rehearsalBtn hitTest:rehearsalBtnPoint withEvent:event];
    }

    CGPoint startBtnPoint = [self convertPoint:point toView:self.stratBtn];
    if (self.stratBtn.hidden == NO && [self.stratBtn pointInside:startBtnPoint withEvent:event]) {
        return [self.stratBtn hitTest:startBtnPoint withEvent:event];
    }
    
    CGPoint stateActionBtnPoint =  [self convertPoint:point toView:self.stateActionBtn];
    if (self.centerView.hidden == NO && [self.stateActionBtn pointInside:stateActionBtnPoint withEvent:event]) {
        return [self.stateActionBtn hitTest:stateActionBtnPoint withEvent:event];
    }
    return [super hitTest:point withEvent:event];
}
 
- (void)clickRehersalBtn
{
    if ([self.delegate respondsToSelector:@selector(clickRehersalToBlock)]) {
        [self.delegate clickRehersalToBlock];
    }
}

- (void)startBtnClick:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(liveStateView:actionType:)]) {
        [self.delegate liveStateView:self actionType:self.liveState];
    }
}

- (void)stateActionBtnClick:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(liveStateView:actionType:)]) {
        [self.delegate liveStateView:self actionType:self.liveState];
    }
}

#pragma mark - 懒加载
- (UIButton *)rehearsalBtn
{
    if (!_rehearsalBtn)
    {
        _rehearsalBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _rehearsalBtn.hidden = YES;
        _rehearsalBtn.backgroundColor = [UIColor whiteColor];
        _rehearsalBtn.titleLabel.font = FONT_FZZZ(17);
        _rehearsalBtn.layer.cornerRadius = 45/2.0;
        _rehearsalBtn.layer.masksToBounds = YES;
        [_rehearsalBtn setTitle:@"开始彩排" forState:UIControlStateNormal];
        [_rehearsalBtn setTitleColor:[UIColor colorWithHex:@"#333333"] forState:UIControlStateNormal];
        [_rehearsalBtn addTarget:self action:@selector(clickRehersalBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rehearsalBtn;
}

- (UIButton *)stratBtn
{
    if (!_stratBtn)
    {
        _stratBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _stratBtn.backgroundColor = MakeColorRGBA(0xFC5659,0.8);
        _stratBtn.titleLabel.font = FONT_FZZZ(17);
        [_stratBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _stratBtn.layer.cornerRadius = 45/2.0;
        _stratBtn.layer.masksToBounds = YES;
        [_stratBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stratBtn;
}

- (UIButton *)stateActionBtn
{
    if (!_stateActionBtn)
    {
        _stateActionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _stateActionBtn.backgroundColor = MakeColorRGBA(0xFC5659,0.8);
        _stateActionBtn.titleLabel.font = FONT_FZZZ(17);
        [_stateActionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _stateActionBtn.layer.cornerRadius = 45/2.0;
        _stateActionBtn.layer.masksToBounds = YES;
        [_stateActionBtn addTarget:self action:@selector(stateActionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stateActionBtn;
}

- (UIImageView *)stateImgView
{
    if (!_stateImgView)
    {
        _stateImgView = [[UIImageView alloc] init];
        _stateImgView.contentMode = UIViewContentModeCenter;
    }
    return _stateImgView;
}

- (UILabel *)stateLab
{
    if (!_stateLab) {
        _stateLab = [[UILabel alloc] init];
        _stateLab.textColor = MakeColorRGB(0x999999);
        _stateLab.textAlignment = NSTextAlignmentCenter;
        _stateLab.font = FONT_FZZZ(16);
    }
    return _stateLab;
}

- (UIView *)centerView
{
    if (!_centerView) {
        _centerView = [[UIView alloc] init];
        _centerView.backgroundColor = [UIColor clearColor];
    }
    return _centerView;
}

@end
