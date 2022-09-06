//
//  VHWatchLiveTimerImg.m
//  UIModel
//
//  Created by 郭超 on 2022/7/22.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHWatchLiveTimerImg.h"

@interface VHWatchLiveTimerImg ()

/// 背景图
@property (nonatomic, strong) UIImageView * img;

/// 内容
@property (nonatomic, strong) UILabel * titleLab;

@end

@implementation VHWatchLiveTimerImg

- (instancetype)init
{
    if ([super init]) {
        
        self.backgroundColor = [UIColor colorWithHex:@"#D9D9D9"];
        
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
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 62));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
}
#pragma mark - 赋值
- (void)setString:(NSString *)string
{
    _string = string;
    
    _titleLab.text = string;
}
- (void)setStringColor:(UIColor *)stringColor
{
    _stringColor = stringColor;
    
    _titleLab.textColor = stringColor;
}
#pragma mark - 懒加载
- (UIImageView *)img
{
    if (!_img) {
        _img = [UIImageView new];
        _img.image = BundleUIImage(@"vh_timer_img");
        [self addSubview:_img];
    }return _img;
}
- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textColor = [UIColor colorWithHex:@"#262626"];
        _titleLab.font = FONT_Medium(44);
        [self addSubview:_titleLab];
    }return _titleLab;
}
@end
