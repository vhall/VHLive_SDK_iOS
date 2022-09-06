//
//  VHLiveRehearsalLogoView.m
//  VhallLive
//
//  Created by 郭超 on 2022/8/24.
//  Copyright © 2022 vhall. All rights reserved.
//

#import "VHLiveRehearsalLogoView.h"

@interface VHLiveRehearsalLogoView ()

@property (nonatomic, strong) UIImageView * icon;

@property (nonatomic, strong) UILabel * name;

@end

@implementation VHLiveRehearsalLogoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.3];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 24/2;
        
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(6, 6));
        }];
        
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.icon.mas_right).offset(3);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
    }return self;
}

#pragma mark - 懒加载
- (UIImageView *)icon
{
    if (!_icon) {
        _icon = [UIImageView new];
        _icon.image = BundleUIImage(@"vh_icon_rehearsal");
        [self addSubview:_icon];
    }return _icon;
}
- (UILabel *)name
{
    if (!_name) {
        _name = [UILabel new];
        _name.font = FONT_FZZZ(12);
        _name.text = @"彩排中";
        _name.textColor = [UIColor whiteColor];
        [self addSubview:_name];
    }return _name;
}
@end
