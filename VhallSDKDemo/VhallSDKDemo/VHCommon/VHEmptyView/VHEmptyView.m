//
//  VHEmptyView.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/26.
//

#import "VHEmptyView.h"

@interface VHEmptyView ()

@property (nonatomic, strong) UILabel *tileLab;
@property (nonatomic, strong) UIImageView *icon;
@end

@implementation VHEmptyView
- (instancetype)init
{
    if ([super init]) {
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(207, 154));
        }];

        [self.tileLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.icon.mas_bottom).offset(10);
            make.centerX.mas_equalTo(0);
        }];
    }

    return self;
}

#pragma mark - 懒加载
- (UILabel *)tileLab {
    if (!_tileLab) {
        _tileLab = [[UILabel alloc] init];
        _tileLab.text = @"这里空空如也";
        _tileLab.textColor = [UIColor colorWithHex:@"#666666"];
        _tileLab.font = FONT(14);
        [self addSubview:_tileLab];
    }

    return _tileLab;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"vh_info_empty"];
        [self addSubview:_icon];
    }

    return _icon;
}

@end
