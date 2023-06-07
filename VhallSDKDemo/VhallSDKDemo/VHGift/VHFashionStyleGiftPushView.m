//
//  VHFashionStyleGiftPushView.m
//  UIModel
//
//  Created by 郭超 on 2022/8/3.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHFashionStyleGiftPushView.h"
#import "VHLiveWeakTimer.h"

@interface VHFashionStyleGiftPushView ()

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UIImageView *giftImgView;

@end

@implementation VHFashionStyleGiftPushView
- (instancetype)init
{
    if ([super init]) {
        self.alpha = 0;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 20 / 2;
        // 添加控件
        [self addViews];
    }

    return self;
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
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.centerY.mas_equalTo(self);
        make.width.mas_lessThanOrEqualTo(165);
    }];

    [self.giftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLab.mas_right).offset(5);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];

    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_giftImgView.mas_right).offset(5);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self setBackgroundColor:[UIColor bm_colorGradientChangeWithSize:self.size direction:IHGradientChangeDirectionLevel startColor:[UIColor colorWithHex:@"#8274FF"] endColor:[UIColor colorWithHexString:@"#F933F9" alpha:.4]]];
}

#pragma mark - 礼物动画
- (void)showGiftPushForNickName:(NSString *)nickName giftName:(NSString *)giftName giftImg:(NSString *)giftImg
{
    if (nickName.length > 8) {
        nickName = [NSString stringWithFormat:@"%@...", [nickName substringToIndex:8]];
    }

    NSString *content = [NSString stringWithFormat:@"%@ 送出的%@", nickName, giftName];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    attributedString.yy_font = FONT(12);
    attributedString.yy_color = [UIColor colorWithHex:@"#FFFFFF"];

    NSRange nickNameRange = [content rangeOfString:nickName];
    [attributedString yy_setColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:.6] range:nickNameRange];

    self.titleLab.attributedText = attributedString;

    [self.giftImgView sd_setImageWithURL:[NSURL URLWithString:giftImg]];

    // 礼物动画
    self.alpha = 0;
    self.transform = CGAffineTransformMakeTranslation(-self.width, 0);
    [UIView animateWithDuration:.5
                     animations: ^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeTranslation(0, 0);
    }
                     completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                           [self dismiss];
                       });
    }];
}

#pragma mark - 隐藏
- (void)dismiss
{
    self.transform = CGAffineTransformMakeTranslation(-self.width, 0);
    self.alpha = 0;
    [self removeFromSuperview];
}

#pragma mark - 懒加载
- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = FONT(12);
        [self addSubview:_titleLab];
    }

    return _titleLab;
}

- (UIImageView *)giftImgView
{
    if (!_giftImgView) {
        _giftImgView = [UIImageView new];
        _giftImgView.layer.masksToBounds = YES;
        _giftImgView.layer.cornerRadius = 20 / 2;
        [self addSubview:_giftImgView];
    }

    return _giftImgView;
}

@end
