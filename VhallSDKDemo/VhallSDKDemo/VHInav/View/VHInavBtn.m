//
//  VHInavBtn.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/20.
//

#import "VHInavBtn.h"

@implementation VHInavBtn

- (instancetype)init
{
    if ([super init]) {
        
        self = [VHInavBtn buttonWithType:UIButtonTypeCustom];

        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.icon];
        [self addSubview:self.titleLab];

        // 初始化布局
        [self setUpMasonry];
        
    }return self;
}

#pragma mark - 初始化布局
- (void)setUpMasonry
{
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).offset(-11);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(_icon.mas_bottom).offset(5);
    }];

}

#pragma mark - 懒加载
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor colorWithHex:@"#262626"];
        _titleLab.font = FONT(14);
    }
    return _titleLab;
}


@end
