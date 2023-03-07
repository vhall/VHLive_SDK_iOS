//
//  VHWarmUpStartView.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/1/30.
//

#import "VHWarmUpStartView.h"

@interface VHWarmUpStartView ()
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIImageView * icon;
@property (nonatomic, strong) UILabel * titleLab;
@property (nonatomic, strong) UIButton * startBtn;
@end


@implementation VHWarmUpStartView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.alpha = 0;
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.startBtn];

        // 初始化布局
        [self setUpMasonry];
        
    }return self;
}

#pragma mark - 初始化布局
- (void)setUpMasonry
{
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(_contentView.mas_width);
    }];
    
    [_startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_contentView.mas_centerX);
        make.bottom.mas_equalTo(-25);
        make.size.mas_equalTo(CGSizeMake(170, 40));
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_startBtn.mas_top).offset(-20);
        make.centerX.mas_equalTo(_contentView.mas_centerX);
    }];
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_contentView.mas_centerX);
        make.bottom.mas_equalTo(_titleLab.mas_top).offset(-20);
        make.size.mas_equalTo(CGSizeMake(135, 135));
    }];
    
}
#pragma mark - 显示
- (void)show
{
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {

    }];
}

#pragma mark - 隐藏
- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - 点击立即观看
- (void)startBtnAction
{
    [self dismiss];
    if (self.clickStartBtn) {
        self.clickStartBtn();
    }
}

#pragma mark - 懒加载
- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor colorWithHex:@"#FFF4F4"];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 16;
    }return _contentView;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"vh_warmUp_icon"];
    }
    return _icon;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"直播已开始，请观看直播吧";
        _titleLab.textColor = [UIColor colorWithHex:@"#262626"];
        _titleLab.font = FONT(14);
        _titleLab.preferredMaxLayoutWidth = Screen_Width - 50 * 2 - 10;
    }
    return _titleLab;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startBtn.titleLabel.font = FONT(14);
        _startBtn.backgroundColor = VHMainColor;
        _startBtn.layer.masksToBounds = YES;
        _startBtn.layer.cornerRadius = 40/2;
        [_startBtn setTitle:@"立即观看" forState:UIControlStateNormal];
        [_startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_startBtn addTarget:self action:@selector(startBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}



@end
